# commonTypes.nim Module

## Description
The `commonTypes.nim` module defines basic data types used throughout the PrettyTerm library. This is a fundamental module that provides common types for statuses and other common entities.

## Purpose
The module is designed for:
- Defining standard operation statuses
- Providing unified types for use across all modules
- Ensuring consistency and type safety

## Main Types

### Status
```nim
type
  Status* = enum
    Ok      = "Ok"      # Successful operation completion
    Error   = "Error"   # Operation execution error
    Fatal   = "Fatal"   # Critical error
    Info    = "Info"    # Informational message
    Warn    = "Warning" # Warning
```

The `Status` type is an enumeration that defines possible statuses of operation execution or messages in the system.

## Where to Apply

### 1. Logging and Reporting
```nim
# In logger for denoting message type
proc addLog(logger: Logger, message: string, component: Component, status: Status) =
  let log = newLog(status, message, component, newLogTime())
  logger.logs.add(log)

# Usage
discard logger.addLog("Operation completed successfully", component, Ok)
discard logger.addLog("Connection error", component, Error)
discard logger.addLog("Critical system error", component, Fatal)
```

### 2. Error Handling
```nim
# In functions for returning execution status
proc processData(data: string): Status =
  try:
    # Data processing
    if data.len == 0:
      return Error
    # Successful processing
    return Ok
  except:
    return Fatal

# Usage
let result = processData(userInput)
case result
of Ok:
  echo "Data processed successfully"
of Error:
  echo "Error processing data"
of Fatal:
  echo "Critical error, application will be closed"
else:
  echo "Unsupported status passed to handler"
```

### 3. System Status Checking
```nim
# For checking status of various components
proc checkSystemStatus(): seq[tuple[name: string, status: Status]] =
  result.add @[
    ("Database", checkDatabase()),
    ("Network", checkNetwork()),
    ("File System", checkFileSystem())
  ]

# Output statuses
for component, status in checkSystemStatus():
  case status
  of Ok:
    echo FgGreen & "[✓] " & component & ": working normally" & ResetColor
  of Error:
    echo FgRed & "[✗] " & component & ": error" & ResetColor
  of Warn:
    echo FgYellow & "[⚠] " & component & ": warning" & ResetColor
  else:
    echo FgBlue & "[i] " & component & ": information" & ResetColor
```

### 4. Data Validation
```nim
# For validating user input
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

# Usage
let emailStatus = validateEmail(userEmail)
let passwordStatus = validatePassword(userPassword)

if emailStatus == Ok and passwordStatus == Ok:
  echo "Data is valid"
else:
  echo "Validation error"
```

### 5. Operation Status
```nim
# For tracking status of long-running operations
type
  Operation = ref object
    name: string
    status: Status
    progress: float

proc updateOperation(op: Operation, newStatus: Status) =
  op.status = newStatus
  case newStatus
  of Ok:
    echo FgGreen & "Operation '" & op.name & "' completed" & ResetColor
  of Error:
    echo FgRed & "Error in operation '" & op.name & "'" & ResetColor
  of Fatal:
    echo FgRed & styleBold & "CRITICAL ERROR in '" & op.name & "'" & ResetColor
  else:
    discard

# Usage
var installOp = Operation(name: "Installation", status: Info, progress: 0.0)
installOp.updateOperation(Ok)
```

### 6. Configuration and Settings
```nim
# For checking configuration
proc validateConfig(config: Config): Status =
  if not fileExists(config.path):
    return Error
  if config.timeout < 0:
    return Error
  if config.timeout > 300:
    return Warn
  return Ok

# Usage
let configStatus = validateConfig(appConfig)
case configStatus
of Ok:
  echo "Configuration is valid"
of Error:
  echo "Configuration error"
of Warn:
  echo "Warning: non-optimal settings"
else:
  discard
```

## Advantages of Usage

### 1. Type Safety
Using the `Status` enumeration instead of strings ensures type safety and prevents errors related to typos in statuses.

### 2. Consistency
All modules use the same statuses, which ensures code consistency and simplifies understanding.

### 3. Extensibility
Easy to add new statuses when needed without breaking existing code.

### 4. Integration with Other Modules
The `Status` type is used in other library modules:
- In `prettyLogger.nim` for denoting log type
- In `themeConfig.nim` for configuring colors for different statuses
- In `stylish.nim` for styling messages based on status

## Complex Usage Examples

```nim
# Example of usage with colors and styles
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

# Example with result processing
proc processFile(filename: string): Status =
  if not fileExists(filename):
    return Error
  
  try:
    let content = readFile(filename)
    if content.len == 0:
      return Warn
    # File processing
    return Ok
  except:
    return Fatal

# Usage
let files = ["config.json", "data.txt", "empty.log"]
for file in files:
  let status = processFile(file)
  printStatusMessage("Processing file: " & file, status)
```

## Dependencies
The module has no external dependencies and uses only standard Nim features.

This module is the foundation for type-safe work with statuses throughout the PrettyTerm library and ensures uniform handling of operation states and messages.
