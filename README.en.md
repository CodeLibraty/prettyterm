# PrettyTerm - Pretty Terminal Printers

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Nim Version](https://img.shields.io/badge/nim-%3E%3D1.6.0-blue.svg)](https://nim-lang.org)
[![Version](https://img.shields.io/badge/version-0.2.4-green.svg)](https://github.com/CodeLibraty/PrettyTerm)

Library for creating beautiful terminal interfaces in Nim.

## Description

PrettyTerm is a powerful Nim library that provides tools for creating styled and beautiful terminal interfaces. The library includes:

- 🎨 ANSI colors and styles support
- 🎭 Theming system with customizable colors and icons
- 📝 Tag system for simple text styling
- 🌳 Tree printer for structured output
- 📊 Advanced logging system

## Installation

```bash
nimble install prettyterm
```

## Quick Start

```nim
import prettyterm

# Using styled strings
echo sty"<red>Red text</red> and <green|bold>bold green</green|bold>"

# Theme configuration
let config = newDisplayConfig()
# ... using configuration

# Logging
let logger = newLogger(newLogTime())
let component = newComponent("myfile.nim", "myFunction", "/path")
discard logger.addLog("Test message", component, Ok)
```

## Main Features

### 🎨 Colors and Styles

The library provides a complete set of ANSI colors and styles:

```nim
# Text colors
echo FgRed & "Red text" & ResetColor
echo FgGreen & "Green text" & ResetColor
echo FgBlue & "Blue text" & ResetColor

# Background colors
echo BgYellow & "Text on yellow background" & ResetColor

# Text styles
echo styleBold & "Bold text" & ResetColor
echo styleItalic & "Italic text" & ResetColor
echo styleUnderline & "Underlined text" & ResetColor
```

### 🎭 Theming

Customizable theme system for consistent styling:

```nim
# Creating color theme
let customTheme = newColorTheme(
  hintColor = clrBlue,
  errorColor = clrRed,
  successColor = clrGreen,
  warningColor = clrYellow
)

# Creating icon theme
let customIcons = newIconsTheme(
  hintIcon = "💡",
  errorIcon = "❌",
  successIcon = "✅",
  warningIcon = "⚠️"
)

# Creating display configuration
let config = newDisplayConfig(
  colorTheme = customTheme,
  iconsTheme = customIcons
)
```

### 📝 Text Styling

Simple and intuitive syntax with tags:

```nim
# Simple tags
echo sty"<red>Red text</red>"
echo sty"<green|bold>Bold green</green|bold>"

# Style combination
echo sty"<blue|underline|bg-yellow>Blue underlined on yellow background</blue|underline|bg-yellow>"

# Variable interpolation
let name = "World"
let value = 42
echo sty"Hello, <green>{name}</green>! Value: <yellow|bold>{value}</yellow|bold>"
```

### 🌳 Tree Output

Structured data output with branching support:

```nim
# Creating root branch
let root = newBranch("Project analysis")

# Adding sub-branches
let lex = root.enterBranch("Lexical analysis")
echo lex.formatBranchLine("Tokenization completed")

let syntax = lex.enterBranch("Syntax analysis")
echo syntax.formatBranchLine("Building AST")

# Output tables
echo syntax.formatTableHeader("Results")
echo syntax.formatTableLine("Success: 100%")
echo syntax.formatTableFooter()

# Output code with line numbering
echo syntax.formatTableCodeMultiLine(1, """
proc hello() =
  echo "Hello, World!"
""")
```

### 📊 Logging

Powerful logging system with various output styles:

```nim
# Creating logger
let logger = newLogger(
  creationTime = newLogTime(),
  printableInTerminal = true
)

# Creating component
let component = newComponent(
  fileName = "main.nim",
  funcName = "main",
  dirPath = "/src"
)

# Adding logs
logger.style = loggerStyleTiny
discard logger.addLog("Application started", component, Ok)

logger.style = loggerStyleFull
discard logger.addLog("Database connection error", component, Error)

# Shutdown with file saving
logger.destroyLogger("./app.log", writeToFile = true)
```

## Project Structure

```
prettyterm/
├── prettyterm.nim        # Main module
├── prettyterm.nimble    # Nimble package file
├── src/
│   ├── colors.nim       # ANSI colors and styles
│   ├── commonTypes.nim  # Basic types
│   ├── themeConfig.nim  # Theme configuration
│   ├── stylish.nim      # Text styling
│   ├── treePrinter.nim  # Tree printer
│   └── prettyLogger.nim # Logging system
├── LICENSE              # MIT license
└── README.md           # Documentation
```

## Requirements

- Nim >= 1.6.0
- Modern terminal with ANSI escape-codes support

## License

MIT License - see [LICENSE](LICENSE) file

## Author

CodeLibraty Foundation  
https://codelibraty.tk

## Contributing

We welcome contributions to the project! Please create an issue or pull request for improvement suggestions.
