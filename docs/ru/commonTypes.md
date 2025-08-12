# Модуль commonTypes.nim

## Описание
Модуль `commonTypes.nim` определяет базовые типы данных, используемые во всей библиотеке PrettyTerm. Это фундаментальный модуль, который предоставляет общие типы для статусов и других общих сущностей.

## Назначение
Модуль предназначен для:
- Определения стандартных статусов операций
- Предоставления единых типов для использования во всех модулях
- Обеспечения консистентности и типобезопасности

## Основные типы

### Status
```nim
type
  Status* = enum
    Ok      = "Ok"      # Успешное выполнение операции
    Error   = "Error"   # Ошибка выполнения операции
    Fatal   = "Fatal"   # Критическая ошибка
    Info    = "Info"    # Информационное сообщение
    Warn    = "Warning" # Предупреждение
```

Тип `Status` представляет собой перечисление, которое определяет возможные статусы выполнения операций или сообщений в системе.

## Где можно применить

### 1. Логирование и отчеты
```nim
# В логгере для обозначения типа сообщения
proc addLog(logger: Logger, message: string, component: Component, status: Status) =
  let log = newLog(status, message, component, newLogTime())
  logger.logs.add(log)

# Использование
discard logger.addLog("Операция завершена успешно", component, Ok)
discard logger.addLog("Ошибка подключения", component, Error)
discard logger.addLog("Критическая ошибка системы", component, Fatal)
```

### 2. Обработка ошибок
```nim
# В функциях для возврата статуса выполнения
proc processData(data: string): Status =
  try:
    # Обработка данных
    if data.len == 0:
      return Error
    # Успешная обработка
    return Ok
  except:
    return Fatal

# Использование
let result = processData(userInput)
case result
of Ok:
  echo "Данные обработаны успешно"
of Error:
  echo "Ошибка при обработке данных"
of Fatal:
  echo "Критическая ошибка, приложение будет закрыто"
else:
  echo "Передан не поддержваемый статус для обраточика"
```

### 3. Проверка состояния системы
```nim
# Для проверки состояния различных компонентов
proc checkSystemStatus(): seq[tuple[name: string, status: Status]] =
  result.add @[
    ("База данных", checkDatabase()),
    ("Сеть", checkNetwork()),
    ("Файловая система", checkFileSystem())
  ]

# Вывод статусов
for component, status in checkSystemStatus():
  case status
  of Ok:
    echo FgGreen & "[✓] " & component & ": работает нормально" & ResetColor
  of Error:
    echo FgRed & "[✗] " & component & ": ошибка" & ResetColor
  of Warn:
    echo FgYellow & "[⚠] " & component & ": предупреждение" & ResetColor
  else:
    echo FgBlue & "[i] " & component & ": информация" & ResetColor
```

### 4. Валидация данных
```nim
# Для валидации пользовательского ввода
proc validateEmail(email: string): Status =
  if email.len == 0:
    return Error
  if not email.contains('@'):
    return Error
  if email.len < 5:
    return Warn
  return Ok

proc validatePassword(password: string): Status =
  if password.len < 8:
    return Error
  if not password.anyIt(it.isDigit()):
    return Warn
  return Ok

# Использование
let emailStatus = validateEmail(userEmail)
let passwordStatus = validatePassword(userPassword)

if emailStatus == Ok and passwordStatus == Ok:
  echo "Данные валидны"
else:
  echo "Ошибка валидации"
```

### 5. Состояние операций
```nim
# Для отслеживания состояния длительных операций
type
  Operation = ref object
    name: string
    status: Status
    progress: float

proc updateOperation(op: Operation, newStatus: Status) =
  op.status = newStatus
  case newStatus
  of Ok:
    echo FgGreen & "Операция '" & op.name & "' завершена" & ResetColor
  of Error:
    echo FgRed & "Ошибка в операции '" & op.name & "'" & ResetColor
  of Fatal:
    echo FgRed & styleBold & "КРИТИЧЕСКАЯ ОШИБКА в '" & op.name & "'" & ResetColor
  else:
    discard

# Использование
var installOp = Operation(name: "Установка", status: Info, progress: 0.0)
installOp.updateOperation(Ok)
```

### 6. Конфигурация и настройки
```nim
# Для проверки конфигурации
proc validateConfig(config: Config): Status =
  if not fileExists(config.path):
    return Error
  if config.timeout < 0:
    return Error
  if config.timeout > 300:
    return Warn
  return Ok

# Использование
let configStatus = validateConfig(appConfig)
case configStatus
of Ok:
  echo "Конфигурация валидна"
of Error:
  echo "Ошибка в конфигурации"
of Warn:
  echo "Предупреждение: неоптимальные настройки"
else:
  discard
```

## Преимущества использования

### 1. Типобезопасность
Использование перечисления `Status` вместо строк обеспечивает типобезопасность и предотвращает ошибки, связанные с опечатками в статусах.

### 2. Консистентность
Все модули используют одинаковые статусы, что обеспечивает консистентность кода и упрощает понимание.

### 3. Расширяемость
Легко добавить новые статусы при необходимости, не нарушая существующий код.

### 4. Интеграция с другими модулями
Тип `Status` используется в других модулях библиотеки:
- В `prettyLogger.nim` для обозначения типа лога
- В `themeConfig.nim` для настройки цветов под разные статусы
- В `stylish.nim` для стилизации сообщений в зависимости от статуса

## Примеры комплексного использования

```nim
# Пример использования с цветами и стилями
import colors

proc printStatusMessage(message: string, status: Status) =
  case status
  of Ok:
    echo FgGreen & "[✓] " & message & ResetColor
  of Error:
    echo FgRed & "[✗] " & message & ResetColor
  of Fatal:
    echo styleBold & FgRed & "[FATAL] " & message & ResetColor
  of Info:
    echo FgBlue & "[i] " & message & ResetColor
  of Warn:
    echo FgYellow & "[⚠] " & message & ResetColor

# Пример с обработкой результатов
proc processFile(filename: string): Status =
  if not fileExists(filename):
    return Error
  
  try:
    let content = readFile(filename)
    if content.len == 0:
      return Warn
    # Обработка файла
    return Ok
  except:
    return Fatal

# Использование
let files = ["config.json", "data.txt", "empty.log"]
for file in files:
  let status = processFile(file)
  printStatusMessage("Обработка файла: " & file, status)
```

## Зависимости
Модуль не имеет внешних зависимостей и использует только стандартные возможности Nim.

Этот модуль является основой для типобезопасной работы со статусами во всей библиотеке PrettyTerm и обеспечивает единообразие обработки состояний операций и сообщений.
