# colors.nim Module

## Description
The `colors.nim` module provides constants for ANSI escape codes used for coloring and styling text in the terminal. This is a fundamental module that forms the visual foundation of the PrettyTerm library.

## Purpose
The module is designed for:
- Providing standard ANSI colors for text
- Providing ANSI colors for backgrounds
- Providing text formatting styles
- Simplifying terminal color management

## Main Constants

### Text Colors
```nim
FgBlack*    = "\e[30m"    # Black text
FgRed*      = "\e[31m"    # Red text
FgGreen*    = "\e[32m"    # Green text
FgYellow*   = "\e[33m"    # Yellow text
FgBlue*     = "\e[34m"    # Blue text
FgMagenta*  = "\e[35m"    # Magenta text
FgCyan*     = "\e[36m"    # Cyan text
FgWhite*    = "\e[37m"    # White text
```

### Background Colors
```nim
BgBlack*    = "\e[40m"    # Black background
BgRed*      = "\e[41m"    # Red background
BgGreen*    = "\e[42m"    # Green background
BgYellow*   = "\e[43m"    # Yellow background
BgBlue*     = "\e[44m"    # Blue background
BgMagenta*  = "\e[45m"    # Magenta background
BgCyan*     = "\e[46m"    # Cyan background
BgWhite*    = "\e[47m"    # White background
```

### Text Styles
```nim
styleBold*        = "\e[1m"   # Bold text
styleFaded*       = "\e[2m"   # Faded text
styleItalic*      = "\e[3m"   # Italic text
styleUnderline*   = "\e[4m"   # Underlined text
styleBlinking*    = "\e[5m"   # Blinking text
styleCrossedOut*  = "\e[9m"   # Crossed out text

ResetColor*       = "\e[0m"   # Reset all colors and styles
```

## Where to Apply

### 1. Simple Text Coloring
```nim
# Output colored text
echo FgRed & "Error: " & ResetColor & "something went wrong"
echo FgGreen & "Success: " & ResetColor & "operation completed"
echo BgYellow & FgBlack & "Warning" & ResetColor
```

### 2. Combining Styles
```nim
# Bold red text
echo styleBold & FgRed & "Important message" & ResetColor

# Underlined blue text
echo styleUnderline & FgBlue & "Link" & ResetColor
```

### 3. Creating Color Schemes
```nim
# Define color scheme for application
const
  ErrorColor = FgRed
  SuccessColor = FgGreen
  WarningColor = FgYellow
  InfoColor = FgBlue

proc log(level: string, message: string) =
  case level
  of "error":   echo ErrorColor & message & ResetColor
  of "success": echo SuccessColor & message & ResetColor
  of "warning": echo WarningColor & message & ResetColor
  of "info":    echo InfoColor & message & ResetColor
  else:         echo message
```

### 4. Command Line Interfaces
```nim
# Create colored menu
echo FgCyan & "=== Main Menu ===" & ResetColor
echo FgGreen & "1. Start work" & ResetColor
echo FgYellow & "2. Settings" & ResetColor
echo FgRed & "3. Exit" & ResetColor
```

### 5. Debugging and Logging
```nim
# Colored output for debugging
echo FgMagenta & "[DEBUG] " & ResetColor & "Variable x = " & $x
echo FgBlue & "[INFO] " & ResetColor & "Connecting to database"
```

## Usage Features

1. **Always reset colors** - after using color codes, always use `ResetColor` to avoid color "sticking" in the terminal.

2. **Combine styles** - you can combine multiple styles by simply concatenating strings with escape codes.

3. **Check support** - ensure that the user's terminal supports ANSI escape codes.

4. **Use for accents** - colors are best used for highlighting important information, not for all text.

## Dependencies
The module has no external dependencies and uses only standard Nim features.

## Usage Examples

```nim
# Simple example
echo FgRed & "This is red text" & ResetColor
echo BgBlue & FgWhite & "White text on blue background" & ResetColor
echo styleBold & FgGreen & "Bold green text" & ResetColor

# Complex example
proc printStatus(status: string, message: string) =
  case status.toLower()
  of "ok", "success":
    echo styleBold & FgGreen & "[✓] " & ResetColor & message
  of "error", "fail":
    echo styleBold & FgRed & "[✗] " & ResetColor & message
  of "warning", "warn":
    echo styleBold & FgYellow & "[⚠] " & ResetColor & message
  else:
    echo styleBold & FgBlue & "[i] " & ResetColor & message

printStatus("success", "Operation completed successfully")
printStatus("error", "An error occurred")
printStatus("warning", "Warning: possible issues")
```

This module is the foundation for all other components of the PrettyTerm library and provides low-level access to ANSI escape codes for the terminal.
