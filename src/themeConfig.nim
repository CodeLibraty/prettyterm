#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/themeConfig.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
# 

import std/[
  terminal
]

import colors

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

  ColorTheme* = object
    hintColor*:     TerminalColors
    errorColor*:    TerminalColors
    successColor*:  TerminalColors
    warningColor*:  TerminalColors

  IconsTheme* = object
    hintIcon*:      string
    errorIcon*:     string
    successIcon*:   string
    warningIcon*:   string

  DisplayConfig* = object
    colorTheme*:    ColorTheme
    iconsTheme*:    IconsTheme
    terminalSize*:  tuple[width, height: int]

proc newColorTheme*(
    hintColor:    TerminalColors = clrBlue;
    errorColor:   TerminalColors = clrRed;
    successColor: TerminalColors = clrGreen;
    warningColor: TerminalColors = clrYellow
): ColorTheme = 
  result = ColorTheme(
    hintColor:    hintColor,
    errorColor:   errorColor,
    successColor: successColor,
    warningColor: warningColor
  )

proc newIconsTheme*(
    hintIcon:    string = "🛈";
    errorIcon:   string = "✗";
    successIcon: string = "✓";
    warningIcon: string = "⚠"
): IconsTheme =
  result = IconsTheme(
    hintIcon:     hintIcon,
    errorIcon:    errorIcon,
    successIcon:  successIcon,
    warningIcon:  warningIcon
  )

proc newDisplayConfig*(
    colorTheme: ColorTheme = newColorTheme(),
    iconsTheme: IconsTheme = newIconsTheme(),
    terminalSize:
      tuple[width, height: int] = (
        width:  terminalWidth(), 
        height: terminalHeight()
      )
): DisplayConfig =
  result = DisplayConfig(
    colorTheme:   colorTheme,
    iconsTheme:   iconsTheme,
    terminalSize: terminalSize
  )
