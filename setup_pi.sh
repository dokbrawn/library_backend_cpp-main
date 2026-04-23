#!/usr/bin/env bash
################################################################################
# ULTIMATE RASPBERRY PI SETUP SCRIPT
# Поместите этот файл в корень репозитория.
# Запуск: chmod +x setup_pi.sh && ./setup_pi.sh
################################################################################
set -e
trap 'echo -e "\n\033[0;31m[ОШИБКА] Скрипт прерван. Проверьте вывод выше.\033[0m"; exit 1' ERR

# Цвета
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

log()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "\n${CYAN}=== $1 ===${NC}\n"; }

# Определяем директорию скрипта (работает из любой папки)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$REAL_USER)

# ================= 1. АРХИТЕКТУРА =================
step "🔍 ПРОВЕРКА СИСТЕМЫ"
ARCH=$(uname -m)
if [[ "$ARCH" != "aarch64" ]]; then
    err "❌ Требуется 64-битная ОС (aarch64). Обнаружено: $ARCH"
    echo -e "📖 Переустановите Raspberry Pi OS на версию '64-bit'.\n"
    exit 1
fi
ok "Архитектура: ARM64 (aarch64)"

# ================= 2. НАСТРОЙКА БД И ПРОВЕРКА СЕТИ (ДО УСТАНОВКИ) =================
step "🌐 НАСТРОЙКА ПОДКЛЮЧЕНИЯ К БАЗЕ ДАННЫХ"
echo -e "${YELLOW}Введите IP-адрес вашего Windows-ПК с PostgreSQL:${NC}"
read -p "IP компьютера [192.168.1.55]: " DB_IP
DB_IP=${DB_IP:-192.168.1.55}

echo -e "\n🔍 Проверка связи (ping)..."
if ping -c 1 -W 2 "$DB_IP" >/dev/null 2>&1; then
    ok "✅ Сеть доступна. Пинг прошёл."
else
    warn "⚠️  Пинг не прошёл. Убедитесь, что Pi и ПК подключены к одному роутеру."
    read -p "Продолжить установку? (y/N): " CONT
    [[ "$CONT" =~ ^[Yy]$ ]] || exit 1
fi

echo -e "\n🔌 Проверка порта PostgreSQL (5432)..."
# Простая проверка через bash, без внешних утилит
if (echo > /dev/tcp/$DB_IP/5432) 2>/dev/null; then
    ok "✅ Порт 5432 открыт и доступен!"
else
    warn "⚠️  Порт 5432 закрыт или недоступен."
    echo -e "\n${YELLOW}📋 ЧТО СДЕЛАТЬ НА WINDOWS-ПК:${NC}"
    echo "   1. Брандмауэр: Разрешить входящие подключения для порта 5432 (TCP)"
    echo "   2. pg_hba.conf: Добавить строку 'host all all 0.0.0.0/0 scram-sha-256'"
    echo "   3. postgresql.conf: Установить 'listen_addresses = \"*\"'"
    echo "   4. Перезапустить службу PostgreSQL в services.msc\n"
    read -p "Исправьте настройки на ПК и нажмите Enter для продолжения, или Ctrl+C для выхода: "
fi

# Сохраняем IP для дальнейшего использования
DB_CONN="host=$DB_IP port=5432 dbname=library user=postgres password=123"
ok "Параметры БД сохранены."

# ================= 3. ПАМЯТЬ И ЗАВИСИМОСТИ =================
step "📦 СИСТЕМНЫЕ ПАКЕТЫ И ПАМЯТЬ"
# Swap для Pi 3/4 с малым ОЗУ
if [[ -f /etc/dphys-swapfile ]] && grep -q "CONF_SWAPSIZE=100" /etc/dphys-swapfile; then
    log "🔄 Увеличиваю Swap до 4 ГБ (критично для сборки)..."
    sudo sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=4096/' /etc/dphys-swapfile
    sudo /etc/init.d/dphys-swapfile stop 2>/dev/null || true
    sudo /etc/init.d/dphys-swapfile start
fi

log "Установка зависимостей..."
sudo apt update -qq
sudo apt install -y -qq git curl unzip xz-utils zip libglu1-mesa libgtk-3-0 \
    libblkid1 liblzma5 libgl1-mesa-glx cmake g++ libpq-dev postgresql-client \
    netcat-openbsd build-essential clang llvm pkg-config ninja-build file > /dev/null 2>&1
ok "✅ Зависимости установлены."

# ================= 4. FLUTTER SDK =================
step "🎯 УСТАНОВКА FLUTTER"
FLUTTER_DIR="$USER_HOME/flutter"
if [[ ! -f "$FLUTTER_DIR/bin/flutter" ]]; then
    log "⬇️  Скачиваю Flutter SDK (ARM64)..."
    su - "$REAL_USER" -c "cd ~ && curl -L -o flutter.tar.xz 'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz' --progress-bar"
    su - "$REAL_USER" -c "cd ~ && tar xf flutter.tar.xz && rm flutter.tar.xz"
    
    if ! grep -q "flutter/bin" "$USER_HOME/.bashrc"; then
        echo 'export PATH="$PATH:$HOME/flutter/bin"' >> "$USER_HOME/.bashrc"
    fi
    chown -R "$REAL_USER:$REAL_USER" "$FLUTTER_DIR"
    ok "✅ Flutter установлен в $FLUTTER_DIR"
else
    ok "✅ Flutter уже установлен."
fi

# ================= 5. ВАЛИДАЦИЯ И СБОРКА БИНАРНИКОВ =================
step "⚙️ ПРОВЕРКА И СБОРКА ПРИЛОЖЕНИЯ"
DEPLOY_DIR="$SCRIPT_DIR/deploy_pi"
mkdir -p "$DEPLOY_DIR"

# Функция проверки валидного ELF-бинарника
is_valid_bin() {
    [[ -f "$1" ]] && [[ $(stat -c%s "$1" 2>/dev/null || echo 0) -gt 500000 ]] && file "$1" | grep -q "ELF"
}

# 5.1 Backend
BACK_SRC="$SCRIPT_DIR/build/library_backend"
BACK_DST="$DEPLOY_DIR/library_backend"
if is_valid_bin "$BACK_DST"; then
    ok "✅ Бэкенд в deploy_pi валиден (пропуск сборки)."
else
    warn "⚠️  Бэкенд отсутствует или битый (<500KB). Собираю C++ backend..."
    mkdir -p "$SCRIPT_DIR/build"
    su - "$REAL_USER" -c "cd $SCRIPT_DIR && cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j2"
    if is_valid_bin "$BACK_SRC"; then
        cp "$BACK_SRC" "$BACK_DST"
        chmod +x "$BACK_DST"
        ok "✅ Бэкенд собран и скопирован."
    else
        err "❌ Ошибка сборки бэкенда. Проверьте логи cmake/make."; exit 1
    fi
fi

# 5.2 Frontend
FLUTTER_SRC="$SCRIPT_DIR/flutter_frontend_windows/build/linux/arm64/release/bundle/library_flutter_frontend"
FLUTTER_DST="$DEPLOY_DIR/library_flutter_frontend"
if is_valid_bin "$FLUTTER_DST"; then
    ok "✅ Фронтенд в deploy_pi валиден (пропуск сборки)."
else
    warn "⚠️  Фронтенд отсутствует или битый. Собираю Flutter app (20-40 мин)..."
    su - "$REAL_USER" -c "
        export PATH=\"\$PATH:$FLUTTER_DIR/bin\"
        cd $SCRIPT_DIR/flutter_frontend_windows
        flutter pub get
        flutter build linux --release
    "
    if is_valid_bin "$FLUTTER_SRC"; then
        cp "$FLUTTER_SRC" "$FLUTTER_DST"
        chmod +x "$FLUTTER_DST"
        ok "✅ Фронтенд собран и скопирован."
    else
        err "❌ Ошибка сборки фронтенда. Запустите 'flutter doctor' для диагностики."; exit 1
    fi
fi

# ================= 6. КОНФИГУРАЦИЯ И ЗАПУСК =================
step "🚀 ФИНАЛЬНАЯ НАСТРОЙКА"
# Создаём .env
cat > "$SCRIPT_DIR/.env" << EOF
export LIBRARY_PG_CONN="$DB_CONN"
EOF
chown "$REAL_USER:$REAL_USER" "$SCRIPT_DIR/.env"

# Создаём run.sh
cat > "$DEPLOY_DIR/run.sh" << 'RUNEOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/.env"
export LIBRARY_PG_CONN
cd "$(dirname "$0")"
exec ./library_flutter_frontend "$@"
RUNEOF
chmod +x "$DEPLOY_DIR/run.sh"
chown -R "$REAL_USER:$REAL_USER" "$DEPLOY_DIR"

echo -e "\n${GREEN}🎉 ВСЁ ГОТОВО!${NC}"
echo -e "📂 Готовая папка: ${DEPLOY_DIR}"
echo -e "🚀 Команда запуска: cd ${DEPLOY_DIR} && ./run.sh\n"

read -p "Запустить приложение прямо сейчас? (Y/n): " RUN
if [[ "$RUN" =~ ^[Yy]$ ]] || [[ -z "$RUN" ]]; then
    log "🔄 Запуск..."
    sleep 1
    su - "$REAL_USER" -c "
        source $SCRIPT_DIR/.env
        export LIBRARY_PG_CONN
        export PATH=\"\$PATH:$FLUTTER_DIR/bin\"
        cd $DEPLOY_DIR
        exec ./run.sh
    "
fi