# prettyLogger.nim Module

## Description
The `prettyLogger.nim` module provides an advanced logging system for PrettyTerm with support for various output styles, component tracking, timestamps, and flexible configuration. This is a powerful tool for creating structured and informative logs in applications.

## Purpose
The module is designed for:
- Creating structured logs with timestamps
- Tracking components from which logs were sent
- Supporting various output formatting styles
- Flexible logger configuration for different needs
- Saving logs to files and outputting to terminal

## Main Types and Structures

### LogTime
```nim
type
  LogTime* = ref object
    hour*:     int
    minute*:   int
    seconds*:  int
```

The `LogTime` object represents a log timestamp with hours, minutes, and seconds.

### Component
```nim
type
  Component* = ref object
    fileName*: string
    funcName*: string
    dirPath*:  string
```

The `Component` object stores information about the component from which the log was sent: file name, function name, and directory path.

### Log
```nim
type
  Log* = ref object
    status*:     Status
    message*:    string
    component*:  Component
    time*:       LogTime
```

The main `Log` object represents a single log message with status, message, source component, and creation time.

### LoggerPrintStyle
```nim
type
  LoggerPrintStyle* = enum
    loggerStyleFlat,   # style without symbols, more words
    loggerStyleTiny,   # compact style with simplified output
    loggerStyleFull    # full output of all information with clear formatting
```

The `LoggerPrintStyle` enumeration defines the log formatting style for output.

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

The main `Logger` object represents a logger with a collection of logs, creation and destruction times, terminal output flag, and formatting style.

## Main Functions

### Object Creation Functions

#### newLogTime
```nim
proc newLogTime*(hour, minute, seconds: int): LogTime
proc newLogTime*(): LogTime
```

Creates a log time object. The first version accepts manual time parameters, the second determines time automatically.

#### newComponent
```nim
proc newComponent*(fileName, funcName, dirPath: string): Component
```

Creates a component object with specified file, function, and directory parameters.

#### newLog
```nim
proc newLog*(status: Status; message: string, component: Component; time: LogTime): Log
```

Creates a log object with specified status, message, component, and time.

#### newLogger
```nim
proc newLogger*(creationTime: LogTime, printableInTerminal: bool = true): Logger
```

Creates the main logger object with creation time and terminal output flag.

### Logger Working Functions

#### addLog
```nim
proc addLog*(logger: Logger, message: string, component: Component, status: Status, time: LogTime = newLogTime()): string
```

Adds a log to the logger and returns a formatted string for output (if terminal output is enabled).

#### destroyLogger
```nim
proc destroyLogger*(logger: Logger, fileForLogs: string; writeToFile = true, printEverythingNow: bool = false)
```

Destroys the logger, saving logs to a file and/or outputting them to the terminal.

### Helper Functions

#### formatLogTime
```nim
proc formatLogTime(time: LogTime): string
```

Formats log time to "HH:MM:SS" format string.

#### formatLog
```nim
proc formatLog*(log: Log, style: LoggerPrintStyle): string
```

Formats a log to a string according to the specified style.

## Formatting Styles

### loggerStyleTiny (Compact)
```
Ok: Operation completed successfully | from main.nim-func:main, time is 14:30:25
```

### loggerStyleFlat (Flat)
```
Ok: Operation completed successfully | file main.nim | time 14:30:25
```

### loggerStyleFull (Full)
```
[Ok|14:30:25][/src/main.nim-main]: Operation completed successfully
```

## Where to Apply

### 1. Web Applications and APIs
```nim
# Logging HTTP requests
proc logHttpRequest(logger: Logger, method, path: string, statusCode: int) =
  let component = newComponent("server.nim", "handleRequest", "/src")
  let status = 
    if statusCode >= 200 and statusCode < 300: Ok
    elif statusCode >= 400 and statusCode < 500: Error
    else: Warn
  
  let message = "{method} {path} - {statusCode}"
  discard logger.addLog(message, component, status)

# Usage
let logger = newLogger(newLogTime())
logHttpRequest(logger, "GET", "/api/users", 200)
logHttpRequest(logger, "POST", "/api/users", 201)
logHttpRequest(logger, "GET", "/api/nonexistent", 404)
```

### 2. Build Systems and CI/CD
```nim
# Logging build process
proc logBuildStep(logger: Logger, stepName: string, success: bool) =
  let component = newComponent("build.nim", "buildStep", "/build")
  let status = if success: Ok else: Error
  let message = "Build step: {stepName} - " & (if success: "Successfully" else: "Error")
  discard logger.addLog(message, component, status)

# Usage
logBuildStep(logger, "Source code compilation", true)
logBuildStep(logger, "Running tests", true)
logBuildStep(logger, "Building artifacts", false)
```

### 3. Databases and ORM
```nim
# Logging database operations
proc logDatabaseOperation(logger: Logger, operation: string, table: string, duration: float) =
  let component = newComponent("database.nim", "executeQuery", "/src/db")
  let status = 
    if duration < 1.0: Ok
    elif duration < 5.0: Warn
    else: Error
  
  let message = "{operation} on table {table} completed in {duration:.2f}s"
  discard logger.addLog(message, component, status)

# Usage
logDatabaseOperation(logger, "SELECT", "users", 0.45)
logDatabaseOperation(logger, "INSERT", "orders", 2.34)
logDatabaseOperation(logger, "UPDATE", "products", 8.91)
```

### 4. File Operations and I/O
```nim
# Logging file operations
proc logFileOperation(logger: Logger, operation, filename: string, success: bool) =
  let component = newComponent("filesystem.nim", operation, "/src/utils")
  let status = if success: Ok else: Error
  let message = "{operation} file '{filename}' - " & (if success: "Successfully" else: "Error")
  discard logger.addLog(message, component, status)

# Usage
logFileOperation(logger, "Reading", "config.json", true)
logFileOperation(logger, "Writing", "output.log", true)
logFileOperation(logger, "Deleting", "temp.tmp", false)
```

### 5. Authentication and Security
```nim
# Logging security events
proc logSecurityEvent(logger: Logger, eventType: string, username: string, success: bool) =
  let component = newComponent("auth.nim", "authenticate", "/src/security")
  let status = if success: Ok else: Error
  
  let message = 
    if eventType == "login":
      "Login attempt for user '{username}' - " & (if success: "Success" else: "Denied")
    elif eventType == "logout":
      "Logout for user '{username}'"
    else:
      "{eventType} for user '{username}'"
  
  discard logger.addLog(message, component, status)

# Usage
logSecurityEvent(logger, "login", "admin", true)
logSecurityEvent(logger, "login", "hacker", false)
logSecurityEvent(logger, "logout", "admin", true)
```

### 6. Error Handling and Exceptions
```nim
# Logging exceptions
proc logException(logger: Logger, e: ref Exception, context: string) =
  let component = newComponent("exception.nim", "handleException", "/src/utils")
  let status = Error
  
  let message = "Exception in context '{context}': {e.name} - {e.msg}"
  discard logger.addLog(message, component, status)

# Usage
try:
  # Operation that might cause an exception
  riskyOperation()
except e as Exception:
  logException(logger, e, "processing user input")
```

