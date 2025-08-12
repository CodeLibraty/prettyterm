# stylish.nim Module

## Description
The `stylish.nim` module provides a powerful text styling system using HTML-like tags and the `sty` macro for variable interpolation. This is one of the most convenient and intuitive modules of PrettyTerm for creating styled text.

## Purpose
The module is designed for:
- Simplifying text styling using tags instead of ANSI codes
- Providing convenient syntax for variable interpolation
- Supporting combination of multiple styles
- Automatic processing of ANSI escape-codes and style reset

## Main Functions

### processStyleTags
```nim
proc processStyleTags*(text: string): string
```

The main function that processes text with styling tags and converts them to ANSI escape-codes. The function supports:
- Opening and closing tags (`<tag>...</tag>`)
- Combination of multiple styles (`<red|bold>...</red|bold>`)
- Automatic style reset when closing tags
- Nested tags and proper style stack management

### sty
```nim
macro sty*(text: static string): string
```

A macro that provides convenient syntax for text styling with variable interpolation support. Supports:
- Variable interpolation in curly braces: `{variable}`
- Automatic processing of styling tags
- Compile-time syntax checking

## Supported Tags and Styles

### Text Colors
- `<red>` - Red text
- `<green>` - Green text
- `<blue>` - Blue text
- `<yellow>` - Yellow text
- `<magenta>` - Magenta text
- `<cyan>` - Cyan text
- `<white>` - White text
- `<black>` - Black text

### Background Colors
- `<bg-red>` - Red background
- `<bg-green>` - Green background
- `<bg-blue>` - Blue background
- `<bg-yellow>` - Yellow background
- `<bg-magenta>` - Magenta background
- `<bg-cyan>` - Cyan background
- `<bg-white>` - White background
- `<bg-black>` - Black background

### Text Styles
- `<bold>` - Bold text
- `<italic>` - Italic text
- `<underline>` - Underlined text
- `<faded>` - Faded text
- `<blinking>` - Blinking text
- `<crossedOut>` - Crossed out text

## Where to Apply

### 1. Interactive Console Applications
```nim
# Creating interactive menus and interfaces
proc showMainMenu() =
  echo sty"<cyan|bold>=== Main Menu ===</cyan|bold>"
  echo sty"<green>1. Start work</green>"
  echo sty"<yellow>2. Settings</yellow>"
  echo sty"<red>3. Exit</red>"
  echo sty"<blue>Select option: </blue>"

# Usage
showMainMenu()
```

### 2. Logging with Color Highlighting
```nim
# Colored logging with importance levels
proc log(level, message: string) =
  case level.toLower()
  of "error":
    echo sty"<red|bold>[ERROR]</red|bold> {message}"
  of "warn":
    echo sty"<yellow|bold>[WARN]</yellow|bold> {message}"
  of "info":
    echo sty"<blue|bold>[INFO]</blue|bold> {message}"
  of "success":
    echo sty"<green|bold>[SUCCESS]</green|bold> {message}"
  else:
    echo sty"[{level}] {message}"

# Usage
log("error", "Database connection error")
log("success", "Operation completed successfully")
```

### 3. Reports and Tables
```nim
# Creating colored reports
proc printReport(data: seq[tuple[name: string, value: int, status: string]]) =
  echo sty"<cyan|bold>=== Execution Report ===</cyan|bold>"
  for item in data:
    let statusColor = if item.status == "ok": "green" else: "red"
    echo sty"• {item.name}: <{statusColor}>{item.value}</{statusColor}> [{item.status}]"

# Usage
let reportData = @[
  ("Task 1", 100, "ok"),
  ("Task 2", 75, "error"),
  ("Task 3", 90, "ok")
]
printReport(reportData)
```

### 4. Progress Bars and Indicators
```nim
# Creating progress bars
proc showProgress(current, total: int) =
  let percentage = (current * 100) div total
  let filledLength = (current * 20) div total
  let bar = "█".repeat(filledLength) & " ".repeat(20 - filledLength)
  
  echo sty"<yellow>Progress: [{bar}]</yellow> <cyan|bold>{percentage}%</cyan|bold> <green>({current}/{total})</green>"
  stdout.flushFile()

# Usage
for i in 0..100:
  showProgress(i, 100)
  sleep(50)
echo ""
```

### 5. Validation and Forms
```nim
# User input validation with error highlighting
proc validateInput(input: string): bool =
  if input.len == 0:
    echo sty"<red|bold>Error: Field cannot be empty</red|bold>"
    return false
  if input.len < 3:
    echo sty"<yellow>Warning: Value too short</yellow>"
    return false
  echo sty"<green>✓ Input is correct</green>"
  return true

# Usage
while true:
  stdout.write sty"<blue>Enter value (minimum 3 characters): </blue>"
  let input = stdin.readLine()
  if validateInput(input):
    break
```

### 6. Gaming and Entertainment Applications
```nim
# Text games with color styling
proc showGameStats(player: tuple[name: string, hp: int, mp: int]) =
  echo sty"<magenta|bold>=== {player.name} ===</magenta|bold>"
  echo sty"<red>❤️ HP: {player.hp}</red>"
  echo sty"<blue>💧 MP: {player.mp}</blue>"

proc battleMessage(attacker, target: string, damage: int) =
  echo sty"<yellow>{attacker}</yellow> deals <red|bold>{damage}</red|bold> damage to <cyan>{target}</cyan>"

# Usage
let player = (name: "Hero", hp: 100, mp: 50)
showGameStats(player)
battleMessage("Hero", "Dragon", 25)
```

### 7. Help Systems and Documentation
```nim
# Creating colored help
proc showHelp() =
  echo sty"<cyan|bold>=== Available Commands ===</cyan|bold>"
  echo sty"<green>help</green>     - show this help"
  echo sty"<blue>start</blue>    - start work"
  echo sty"<yellow>config</yellow>  - open settings"
  echo sty"<red>exit</red>     - exit program"

# Usage
showHelp()
```

### 8. Dynamic Messages with Variables
```nim
# Personalized messages
proc greetUser(name: string, isAdmin: bool) =
  if isAdmin:
    echo sty"<green|bold>Welcome, {name}!</green|bold> <red|italic>(Administrator)</red|italic>"
  else:
    echo sty"<blue>Hello, {name}!</blue>"

proc showSystemInfo(os: string, version: string, uptime: int) =
  echo sty"<cyan>System: <bold>{os}</bold></cyan>"
  echo sty"<yellow>Version: <italic>{version}</italic></yellow>"
  echo sty"<green>Uptime: {uptime} hours</green>"

# Usage
greetUser("Alexander", true)
showSystemInfo("Linux", "5.4.0", 72)
```

## Combining Styles

### Multiple Styles
```nim
# Combining colors and styles
echo sty"<red|bold|underline>Bold underlined red text</red|bold|underline>"
echo sty"<blue|italic|bg-yellow>Italic blue on yellow background</blue|italic|bg-yellow>"
echo sty"<green|bold|underline|italic>All styles at once</green|bold|underline|italic>"
```

### Complex Combinations
```nim
# Complex formatting
proc formatComplexMessage(title: string, content: string, status: string) =
  let statusColors = {"ok": "green", "error": "red", "warning": "yellow"}.toTable
  let color = statusColors.getOrDefault(status.toLower, "white")
  
  echo sty"<cyan|bold>[{status.upper()}]</cyan|bold> <{color}|underline>{title}</{color}|underline>"
  echo sty"  <italic>{content}</italic>"

# Usage
formatComplexMessage("Successful connection", "Connection to server established", "ok")
formatComplexMessage("Network error", "Failed to connect to remote server", "error")
```

## Advanced Techniques

### Creating Templates
```nim
# Creating reusable templates
proc createHeader(title: string): string =
  result = sty"<cyan|bold>=== {title} ===</cyan|bold>"

proc createFooter(): string =
  result = sty"<yellow>--- End of Report ---</yellow>"

proc generateReport(title: string, data: seq[string]) =
  echo createHeader(title)
  for item in data:
    echo sty"• {item}"
  echo createFooter()

# Usage
let tasks = @["Complete project", "Write tests", "Update documentation"]
generateReport("Tasks for the week", tasks)
```

## Advantages of Usage

### 1. Readability
Tag syntax is much more readable than direct use of ANSI escape-codes.

### 2. Safety
Automatic style reset processing prevents color "sticking" in the terminal.

### 3. Flexibility
Easy to combine multiple styles and create complex visual effects.

### 4. Interpolation
Variable interpolation support makes code cleaner and more understandable.

### 5. Extensibility
Easy to add new tags and styles as needed.
