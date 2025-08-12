# Модуль prettyLogger.nim

## Описание
Модуль `prettyLogger.nim` предоставляет продвинутую систему логирования для PrettyTerm с поддержкой различных стилей вывода, отслеживания компонентов, временных меток и гибкой конфигурации. Это мощный инструмент для создания структурированных и информативных логов в приложениях.

## Назначение
Модуль предназначен для:
- Создания структурированных логов с временной меткой
- Отслеживания компонентов, из которых были отправлены логи
- Поддержки различных стилей форматирования вывода
- Гибкой настройки логгера под разные нужды
- Сохранения логов в файл и вывода в терминал

## Основные типы и структуры

### LogTime
```nim
type
  LogTime* = ref object
    hour*:     int
    minute*:   int
    seconds*:  int
```

Объект `LogTime` представляет собой временную метку лога с часами, минутами и секундами.

### Component
```nim
type
  Component* = ref object
    fileName*: string
    funcName*: string
    dirPath*:  string
```

Объект `Component` хранит информацию о компоненте, из которого был отправлен лог: имя файла, имя функции и путь к директории.

### Log
```nim
type
  Log* = ref object
    status*:     Status
    message*:    string
    component*:  Component
    time*:       LogTime
```

Основной объект `Log` представляет собой одно сообщение лога со статусом, сообщением, компонентом-источником и временем создания.

### LoggerPrintStyle
```nim
type
  LoggerPrintStyle* = enum
    loggerStyleFlat,   # стиль без символов, больше слов
    loggerStyleTiny,   # компактный стиль с упрощённым выводом
    loggerStyleFull    # полный вывод всей информации с чётким форматированием
```

Перечисление `LoggerPrintStyle` определяет стиль форматирования логов при выводе.

### Logger
```nim
type
  Logger* = ref object
    logs*:                 seq[Log]
    creationTime*:         LogTime
    destructionTime*:      LogTime
    printableInTerminal*:  bool
    style*:                LoggerPrintStyle
```

Основной объект `Logger` представляет собой логгер с коллекцией логов, временем создания и уничтожения, флагом вывода в терминал и стилем форматирования.

## Основные функции

### Функции создания объектов

#### newLogTime
```nim
proc newLogTime*(hour, minute, seconds: int): LogTime
proc newLogTime*(): LogTime
```

Создает объект времени лога. Первая версия принимает ручные параметры времени, вторая - определяет время автоматически.

#### newComponent
```nim
proc newComponent*(fileName, funcName, dirPath: string): Component
```

Создает объект компонента с указанными параметрами файла, функции и директории.

#### newLog
```nim
proc newLog*(status: Status; message: string, component: Component; time: LogTime): Log
```

Создает объект лога с указанным статусом, сообщением, компонентом и временем.

#### newLogger
```nim
proc newLogger*(creationTime: LogTime, printableInTerminal: bool = true): Logger
```

Создает основной объект логгера с временем создания и флагом вывода в терминал.

### Функции работы с логгером

#### addLog
```nim
proc addLog*(logger: Logger, message: string, component: Component, status: Status, time: LogTime = newLogTime()): string
```

Добавляет лог в логгер и возвращает отформатированную строку для вывода (если включен вывод в терминал).

#### destroyLogger
```nim
proc destroyLogger*(logger: Logger, fileForLogs: string; writeToFile = true, printEverythingNow: bool = false)
```

Уничтожает логгер, сохраняя логи в файл и/или выводя их в терминал.

### Вспомогательные функции

#### formatLogTime
```nim
proc formatLogTime(time: LogTime): string
```

Форматирует время лога в строку формата "HH:MM:SS".

#### formatLog
```nim
proc formatLog*(log: Log, style: LoggerPrintStyle): string
```

Форматирует лог в строку в соответствии с указанным стилем.

## Стили форматирования

### loggerStyleTiny (Компактный)
```
Ok: Операция завершена успешно | from main.nim-func:main, time is 14:30:25
```

### loggerStyleFlat (Плоский)
```
Ok: Операция завершена успешно | file main.nim | time 14:30:25
```

### loggerStyleFull (Полный)
```
[Ok|14:30:25][/src/main.nim-main]: Операция завершена успешно
```

## Где можно применить

### 1. Веб-приложения и API
```nim
# Логирование HTTP запросов
proc logHttpRequest(logger: Logger, method, path: string, statusCode: int) =
  let component = newComponent("server.nim", "handleRequest", "/src")
  let status = 
    if statusCode >= 200 and statusCode < 300: Ok
    elif statusCode >= 400 and statusCode < 500: Error
    else: Warn
  
  let message = "{method} {path} - {statusCode}"
  discard logger.addLog(message, component, status)

# Использование
let logger = newLogger(newLogTime())
logHttpRequest(logger, "GET", "/api/users", 200)
logHttpRequest(logger, "POST", "/api/users", 201)
logHttpRequest(logger, "GET", "/api/nonexistent", 404)
```

### 2. Системы сборки и CI/CD
```nim
# Логирование процесса сборки
proc logBuildStep(logger: Logger, stepName: string, success: bool) =
  let component = newComponent("build.nim", "buildStep", "/build")
  let status = if success: Ok else: Error
  let message = "Шаг сборки: {stepName} - " & (if success: "Успешно" else: "Ошибка")
  discard logger.addLog(message, component, status)

# Использование
logBuildStep(logger, "Компиляция исходного кода", true)
logBuildStep(logger, "Запуск тестов", true)
logBuildStep(logger, "Сборка артефактов", false)
```

### 3. Базы данных и ORM
```nim
# Логирование операций с базой данных
proc logDatabaseOperation(logger: Logger, operation: string, table: string, duration: float) =
  let component = newComponent("database.nim", "executeQuery", "/src/db")
  let status = 
    if duration < 1.0: Ok
    elif duration < 5.0: Warn
    else: Error
  
  let message = "{operation} на таблице {table} выполнена за {duration:.2f}с"
  discard logger.addLog(message, component, status)

# Использование
logDatabaseOperation(logger, "SELECT", "users", 0.45)
logDatabaseOperation(logger, "INSERT", "orders", 2.34)
logDatabaseOperation(logger, "UPDATE", "products", 8.91)
```

### 4. Файловые операции и I/O
```nim
# Логирование файловых операций
proc logFileOperation(logger: Logger, operation, filename: string, success: bool) =
  let component = newComponent("filesystem.nim", operation, "/src/utils")
  let status = if success: Ok else: Error
  let message = "{operation} файла '{filename}' - " & (if success: "Успешно" else: "Ошибка")
  discard logger.addLog(message, component, status)

# Использование
logFileOperation(logger, "Чтение", "config.json", true)
logFileOperation(logger, "Запись", "output.log", true)
logFileOperation(logger, "Удаление", "temp.tmp", false)
```

### 5. Аутентификация и безопасность
```nim
# Логирование событий безопасности
proc logSecurityEvent(logger: Logger, eventType: string, username: string, success: bool) =
  let component = newComponent("auth.nim", "authenticate", "/src/security")
  let status = if success: Ok else: Error
  
  let message = 
    if eventType == "login":
      "Попытка входа пользователя '{username}' - " & (if success: "Успешно" else: "Отказано")
    elif eventType == "logout":
      "Выход пользователя '{username}'"
    else:
      "{eventType} для пользователя '{username}'"
  
  discard logger.addLog(message, component, status)

# Использование
logSecurityEvent(logger, "login", "admin", true)
logSecurityEvent(logger, "login", "hacker", false)
logSecurityEvent(logger, "logout", "admin", true)
```

### 6. Обработка ошибок и исключений
```nim
# Логирование исключений
proc logException(logger: Logger, e: ref Exception, context: string) =
  let component = newComponent("exception.nim", "handleException", "/src/utils")
  let status = Error
  
  let message = "Исключение в контексте '{context}': {e.name} - {e.msg}"
  discard logger.addLog(message, component, status)

# Использование
try:
  # Операция, которая может вызвать исключение
  riskyOperation()
except e as Exception:
  logException(logger, e, "обработка пользовательского ввода")
```

### 7. Производительность и профилирование
```nim
# Логирование времени выполнения операций
proc logPerformance(logger: Logger, operation: string, duration: float) =
  let component = newComponent("performance.nim", "measureTime", "/src/utils")
  let status = 
    if duration < 0.1: Ok
    elif duration < 1.0: Warn
    else: Error
  
  let message = "Операция '{operation}' выполнена за {duration:.3f}с"
  discard logger.addLog(message, component, status)

# Использование с замером времени
proc timedOperation[T](logger: Logger, name: string, operation: proc(): T): T =
  let start = epochTime()
  result = operation()
  let duration = epochTime() - start
  logPerformance(logger, name, duration)

# Использование
let result = timedOperation(logger, "загрузка данных", proc(): string =
  # Длительная операция
  return loadData()
)
```
