#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/prettyLogger.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
# 

import std/[
  strformat, strutils, times, os
]

import ./[
  commonTypes # Для типов: `Status`
]

type
  LogTime* = ref object # Время регистрации лога
    hour*:     int
    minute*:   int
    seconds*:  int

  Component* = ref object # Компонент
    fileName*: string     # Имя файла
    funcName*: string     # Имя функции
    dirPath*:  string     # Путь к папке
      # в котором был зарегестрирован лог

  Log* = ref object # Одно сообщение лога
    status*:     Status    # Статус успеха. Тип из файла sharedTypes
    message*:    string    # Сообщение
    component*:  Component # Из какого компонента лог был отправлен
    time*:       LogTime   # Время создания Лога

  LoggerPrintStyle* = enum
    loggerStyleFlat,   # стиль без символов, больше слов
    loggerStyleTiny,   # компактный стиль с упрощённым выводом
    loggerStyleFull    # полный вывод всей информации с чётким форматированием

  Logger* = ref object # Основной класс логгера
    logs*:                 seq[Log]         # Содержит все логи. Добавляются с помощью функции `addLog`
    creationTime*:         LogTime          # Время создания экземпляра логера
    destructionTime*:      LogTime          # Время уничтожения экземпляра. Устанавливается функцией `destroyLogger` когда экзмепляр удаляется
    printableInTerminal*:  bool             # Можно ли отображать логи в терминале для дебага
    style*:                LoggerPrintStyle # Стиль вывода в терминал и записи в файл

# Объявление всех функций файла
proc newLogger*(creationTime: LogTime, printableInTerminal: bool = true): Logger
proc newComponent*(fileName, funcName, dirPath: string): Component
proc newLogTime*(hour, minute, seconds: int): LogTime
proc newLogTime*(): LogTime
proc addLog*(logger: Logger, message: string, component: Component, status: Status, time: LogTime = newLogTime()): string
proc newLog*(status: Status; message: string, component: Component; time: LogTime): Log
proc formatLogTime*(time: LogTime): string
proc formatLog*(log: Log, style: LoggerPrintStyle): string
proc destroyLogger*(logger: Logger, fileForLogs: string; writeToFile = true, printEverythingNow: bool = false)

# Фнукция инициализации нового экземпляра Логгера
proc newLogger*(
    creationTime:         LogTime,
    printableInTerminal:  bool = true
): Logger = 
  result = Logger(
    logs:                 @[],                  # Cразу после создания мы не знаем какием будут логи во время работы, это значение обновляется функцией `addLog`
    creationTime:         creationTime,
    destructionTime:      newLogTime(0, 0, 0),  # Сразу после создания мы не можем знать когда будет уничтожен экземпляр, это значение выстовляется функцией `destroyLogger`
    printableInTerminal:  printableInTerminal
  )

# Функция создания новового комопонента
proc newComponent*(fileName, funcName, dirPath: string): Component = 
  result = Component(
    fileName: fileName,
    funcName: funcName,
    dirPath:  dirPath
  )

# Функция создания нового времени лога с ручным указнием
proc newLogTime*(hour, minute, seconds: int): LogTime =
  result = LogTime(
    hour:     hour,
    minute:   minute,
    seconds:  seconds
  )

# Перегрузка функции создания новго времни лога с автоматическим определением времени
proc newLogTime*(): LogTime =
  let time = now()
  result = LogTime(
    hour:     time.hour,
    minute:   time.minute,
    seconds:  time.second
  )

# Функция создания нового лога
proc newLog*(
    status:     Status;
    message:    string,
    component:  Component;
    time:       LogTime
): Log = 
  result = Log(
    status:     status,
    message:    message,
    component:  component,
    time:       time
  )

# Функция форматирования времни Лога в строчку
proc formatLogTime(time: LogTime): string =
  fmt"{time.hour}:{time.minute}:{time.seconds}"

# Функция форматирования Лога в строчку для будущего вывода и записи в файл
proc formatLog*(
    log:      Log,
    style:    LoggerPrintStyle
): string =
  case style
  of loggerStyleTiny:
    result = fmt"{log.status}: {log.message} | from {log.component.fileName}-func:{log.component.funcName}, time is {formatLogTime(log.time)}"
  of loggerStyleFlat:
    result = fmt"{log.status}: {log.message} | file {log.component.fileName} | time {formatLogTime(log.time)}"
  of loggerStyleFull:
    result = fmt"[{log.status}|{formatLogTime(log.time)}][{log.component.dirPath}/{log.component.fileName}-{log.component.funcName}]: {log.message}"

# Обычная функция добавления лога в логгер
proc addLog*(
    logger:     Logger,
    message:    string,
    component:  Component,
    status:     Status,
    time:       LogTime = newLogTime()
): string =
  let log: Log = newLog(status, message, component, time)
  logger.logs.add(log)

  if logger.printableInTerminal: 
    result = log.formatLog(logger.style)

# Функция уничтожения экзмепляра логгера
proc destroyLogger*(
    logger:             Logger,
    fileForLogs:        string,       # Полный путь к файлу в который будут записыватся логи если writeToFile равен true
    writeToFile:        bool = true,  # Записывать в файл
    printEverythingNow: bool = false  # Вывести разом все логи из поля `Logger.logs` 
) = 
  var logs: seq[string]

  for log in logger.logs:
    logs.add(
      formatLog(log, logger.style)
    )

  if printEverythingNow:
    echo logs.join("\n")

  if writeToFile:
    var file: File

    if not fileExists(fileForLogs):
      try: writeFile(fileForLogs, "")
      except IOError as e:
        raise newException(IOError, fmt"Writng log file failed: {e.msg}")  

    file = open(fileForLogs, fmWrite)

    file.write(logs.join("\n"))

    file.close

when isMainModule:
  let testLogger = newLogger(
    creationTime = newLogTime(),
    printableInTerminal = true
  )

  let testComponent = newComponent(
    fileName = "testFile.nim",
    funcName = "testFunction",
    dirPath  = "test/path/to/file"
  )

  echo "print log"
  testLogger.style = loggerStyleTiny
  echo testLogger.addLog("test success log, style tiny", testComponent, Ok)
  testLogger.style = loggerStyleFlat
  echo testLogger.addLog("test success log, style flat", testComponent, Ok)
  testLogger.style = loggerStyleFull
  echo testLogger.addLog("test success log, style full", testComponent, Ok)
  echo "print log end"

  testLogger.destroyLogger("./test.log", true, true)