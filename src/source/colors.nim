#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/colors.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
#

# Цвета текста
const
  FgBlack*    = "\e[30m"
  FgRed*      = "\e[31m"
  FgGreen*    = "\e[32m"
  FgYellow*   = "\e[33m"
  FgBlue*     = "\e[34m"
  FgMagenta*  = "\e[35m"
  FgCyan*     = "\e[36m"
  FgWhite*    = "\e[37m"

# Цвета фона
const
  BgBlack*    = "\e[40m"
  BgRed*      = "\e[41m"
  BgGreen*    = "\e[42m"
  BgYellow*   = "\e[43m"
  BgBlue*     = "\e[44m"
  BgMagenta*  = "\e[45m"
  BgCyan*     = "\e[46m"
  BgWhite*    = "\e[47m"

# Стили текста 
const
  styleBold*        = "\e[1m"
  styleFaded*       = "\e[2m"
  styleItalic*      = "\e[3m"
  styleUnderline*   = "\e[4m"
  styleBlinking*    = "\e[5m"
  styleCrossedOut*  = "\e[9m"

  ResetColor*       = "\e[0m" # Сбрасывает все цвета и стили
