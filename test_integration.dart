import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔗 Тест интеграции: Flutter Frontend -> C++ Backend');
  
  // Путь к твоему ARM-бинарнику
  final backendPath = '/project/build/library_backend';
  final dbConn = 'host=host.docker.internal port=5432 dbname=library user=postgres password=123';

  if (!await File(backendPath).exists()) {
    print('❌ Бинарник не найден: $backendPath');
    return;
  }

  try {
    print('⏳ Запуск бэкенда...');
    
    // Запускаем команду 'list' точно так же, как это делает твое приложение
    final result = await Process.run(
      backendPath, 
      ['list'], 
      environment: {'LIBRARY_PG_CONN': dbConn}
    );

    if (result.exitCode == 0) {
      print('✅ Бэкенд успешно ответил!');
      
      // Имитация парсинга, как в твоем коде (поиск BEGIN_BOOK)
      final output = result.stdout.toString();
      if (output.contains('BEGIN_BOOK')) {
        print('✅ Формат данных корректен (найден маркер BEGIN_BOOK).');
        
        // Выводим первые 3 книги для наглядности
        final lines = output.split('\n');
        int bookCount = 0;
        for (var line in lines) {
          if (line.startsWith('title=')) {
            bookCount++;
            print('   📚 Книга $bookCount: ${line.substring(6)}');
            if (bookCount >= 3) break;
          }
        }
        
        print('\n🎉 ИНТЕГРАЦИЯ РАБОТАЕТ! Фронтенд может получать данные от бэкенда.');
      } else {
        print('⚠️ Внимание: в выводе нет маркера BEGIN_BOOK. Проверь формат вывода в C++.');
        print('Вывод бэкенда:\n$output');
      }
    } else {
      print('❌ Ошибка выполнения бэкенда (Exit code: ${result.exitCode})');
      print('Stderr: ${result.stderr}');
    }
  } catch (e) {
    print('❌ Исключение при запуске процесса: $e');
  }
}
