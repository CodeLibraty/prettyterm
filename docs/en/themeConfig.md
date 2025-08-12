# themeConfig.nim Module

## Description
The `themeConfig.nim` module provides a theme configuration system for PrettyTerm. It allows creating customizable color schemes, icon sets, and general display configuration for consistent terminal interface styling.

## Purpose
The module is designed for:
- Creating customizable color themes
- Defining icon sets for different statuses
- Providing unified display configuration
- Ensuring visual styling consistency

## Main Types and Structures

### TerminalColors
```nim
type
  TerminalColors* = enum
    clrBlack    = FgBlack
    clrRed      = FgRed
    clrGreen    = FgGreen
    clrYellow   = FgYellow
    clrBlue     = FgBlue
    clrMagenta  = FgMagenta
    clrCyan     = FgCyan
    clrWhite    = FgWhite
```

The `TerminalColors` enumeration provides convenient aliases for ANSI colors defined in the `colors.nim` module.

### ColorTheme
```nim
type
  ColorTheme* = object
    hintColor*:     TerminalColors
    errorColor*:    TerminalColors
    successColor*:  TerminalColors
    warningColor*:  TerminalColors
```

The `ColorTheme` object defines a color scheme for different types of messages and statuses.

### IconsTheme
```nim
type
  IconsTheme* = object
    hintIcon*:      string
    errorIcon*:     string
    successIcon*:   string
    warningIcon*:   string
```

The `IconsTheme` object defines a set of icons for visual indication of different statuses.

### DisplayConfig
```nim
type
  DisplayConfig* = object
    colorTheme*:    ColorTheme
    iconsTheme*:    IconsTheme
    terminalSize*:  tuple[width, height: int]
```

The main configuration object that combines color theme, icons, and terminal sizes.

## Main Functions

### newColorTheme
```nim
proc newColorTheme*(
    hintColor:    TerminalColors = clrBlue;
    errorColor:   TerminalColors = clrRed;
    successColor: TerminalColors = clrGreen;
    warningColor: TerminalColors = clrYellow
): ColorTheme
```

Creates a new color theme with specified colors for different statuses. All parameters have default values.

### newIconsTheme
```nim
proc newIconsTheme*(
    hintIcon:    string = "🛈";
    errorIcon:   string = "✗";
    successIcon: string = "✓";
    warningIcon: string = "⚠"
): IconsTheme
```

Creates a new icon theme with specified symbols for different statuses. Unicode symbols are used by default.

### newDisplayConfig
```nim
proc newDisplayConfig*(
    colorTheme: ColorTheme = newColorTheme(),
    iconsTheme: IconsTheme = newIconsTheme(),
    terminalSize:
      tuple[width, height: int] = (
        width:  terminalWidth(), 
        height: terminalHeight()
      )
): DisplayConfig
```

Creates a complete display configuration, combining color theme, icons, and terminal sizes. Terminal sizes are determined automatically.

## Where to Apply

### 1. Consistent Application Styling
```nim
# Creating a unified theme for the entire application
let appTheme = newColorTheme(
  hintColor = clrBlue,
  errorColor = clrRed,
  successColor = clrGreen,
  warningColor = clrYellow
)

let appIcons = newIconsTheme(
  hintIcon = "💡",
  errorIcon = "❌",
  successIcon = "✅",
  warningIcon = "⚠️"
)

let appConfig = newDisplayConfig(appTheme, appIcons)

# Usage in different parts of the application
proc printMessage(message: string, status: Status) =
  case status
  of Ok:
    echo appConfig.colorTheme.successColor & 
         appConfig.iconsTheme.successIcon & " " & 
         message & ResetColor
  of Error:
    echo appConfig.colorTheme.errorColor & 
         appConfig.iconsTheme.errorIcon & " " & 
         message & ResetColor
  # ... other statuses
```

### 2. Theming for Different Modes
```nim
# Themes for different operating modes
let lightTheme = newColorTheme(
  hintColor = clrBlue,
  errorColor = clrRed,
  successColor = clrGreen,
  warningColor = clrYellow
)

let darkTheme = newColorTheme(
  hintColor = clrCyan,
  errorColor = clrMagenta,
  successColor = clrGreen,
  warningColor = clrYellow
)

let minimalIcons = newIconsTheme("i", "X", "✓", "!")
let detailedIcons = newIconsTheme("ℹ️", "❌", "✅", "⚠️")

# Configuration selection based on settings
proc getConfig(useDarkMode: bool, useMinimalIcons: bool): DisplayConfig =
  let theme = if useDarkMode: darkTheme else: lightTheme
  let icons = if useMinimalIcons: minimalIcons else: detailedIcons
  return newDisplayConfig(theme, icons)
```

### 3. Branding and Corporate Style
```nim
# Corporate color scheme
let corporateTheme = newColorTheme(
  hintColor = clrBlue,      # Corporate blue
  errorColor = clrRed,      # Standard red for errors
  successColor = clrGreen,  # Standard green for success
  warningColor = clrYellow  # Standard yellow for warnings
)

let corporateIcons = newIconsTheme(
  hintIcon = "[INFO]",
  errorIcon = "[ERROR]",
  successIcon = "[OK]",
  warningIcon = "[WARN]"
)

let corporateConfig = newDisplayConfig(corporateTheme, corporateIcons)
```

### 4. Adaptive Interface
```nim
# Configuration considering terminal size
proc createResponsiveConfig(): DisplayConfig =
  let termWidth = terminalWidth()
  let termHeight = terminalHeight()
  
  # Icon selection based on Unicode support
  let icons = if termWidth > 80:
    newIconsTheme("💡", "❌", "✅", "⚠️")
  else:
    newIconsTheme("i", "X", "V", "!")
  
  # Color configuration for different terminal sizes
  let colors = if termWidth > 120:
    newColorTheme(clrBlue, clrRed, clrGreen, clrYellow)
  else:
    newColorTheme(clrCyan, clrRed, clrGreen, clrYellow)
  
  return newDisplayConfig(colors, icons, (termWidth, termHeight))
```

### 5. Multilingual Interfaces
```nim
# Icons for different languages
let russianIcons = newIconsTheme("ℹ️", "ERROR", "OK", "WARNING")
let englishIcons = newIconsTheme("ℹ️", "ERROR", "OK", "WARNING")
let emojiIcons = newIconsTheme("💡", "❌", "✅", "⚠️")

# Icon selection based on language
proc getIconsForLanguage(lang: string): IconsTheme =
  case lang.toLower()
  of "ru", "russian": return russianIcons
  of "en", "english": return englishIcons
  else: return emojiIcons
```

## Integration with Other Modules

The `themeConfig.nim` module is closely integrated with other PrettyTerm modules:

### With colors.nim
Uses ANSI color constants from the `colors.nim` module for defining color schemes.

### With commonTypes.nim
Status types from `commonTypes.nim` are used for selecting appropriate colors and icons.

### With prettyLogger.nim
Theme configuration can be used for styling logger output.

### With stylish.nim
Color themes can be applied for styling text with tags.

## Advantages of Usage

### 1. Consistency
A unified theme system ensures consistent styling throughout the application.

### 2. Flexibility
Easy to customize colors and icons for different needs and preferences.

### 3. Scalability
Easy to add new themes and icon sets without changing application code.

### 4. Integration
Close integration with other PrettyTerm modules provides a unified approach to styling.

## Dependencies
The module depends on:
- Nim standard library (`terminal` module)
- `colors.nim` module from PrettyTerm

The `themeConfig.nim` module is a key component for creating consistent and customizable terminal interfaces in PrettyTerm.
