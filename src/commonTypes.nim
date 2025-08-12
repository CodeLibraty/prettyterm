#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/commonTypes.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
#

type
  # Статусы, показывают результат выполнения
  Status* = enum
    Ok      = "Ok"
    Error   = "Error"
    Fatal   = "Fatal"
    Info    = "Info"
    Warn    = "Warning"
