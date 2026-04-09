import 'dart:io';

void main() async {
  print('🧪 Тест логики: Flutter -> C++ Backend -> PostgreSQL');
  
  final backend = '/project/build/library_backend';
  final dbConn = 'host=host.docker.internal port=5432 dbname=library user=postgres password=123';

  if (!await File(backend).exists()) {
    print('❌ Бэкенд не найден!');
    return;
  }

  try {
    final result = await Process.run(backend, ['list'], environment: {'LIBRARY_PG_CONN': dbConn});
    
    if (result.exitCode == 0) {
      print('✅ УСПЕХ! Данные получены из БД:');
      print(result.stdout.toString().split('\n').take(5).join('\n'));
      print('\n🎉 Логика работает корректно!');
    } else {
      print('❌ Ошибка бэкенда: ${result.stderr}');
    }
  } catch (e) {
    print('❌ Исключение: $e');
  }
}
