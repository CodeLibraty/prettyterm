#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/treePrinter.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
# 

import std/[
  strutils, strformat
]

import themeConfig, commonTypes

type
  BranchStyle* = enum
    unicodeStyle = "│  ",    # стандартный: веточный
    indentStyle  = "   "     # с отступами вместо веток

  Branch* = ref object
    branchName*:          string
    branchMessage*:       string
    branchIndentLevel*:   int

    branchDisplayConfig*: DisplayConfig
    branchStyle*:         BranchStyle

proc formatIndent*(
    indent:      int, 
    branchStyle: BranchStyle = unicodeStyle
): string =
  fmt"{($branchStyle).repeat(indent)}"

proc visualLen*(s: string): int =
  ## Возвращает визуальную ширину строки в терминале
  var i = 0
  result = 0
  while i < s.len:
    # Проверяем на ANSI escape-коды
    if s[i] == '\e' and i + 1 < s.len and s[i + 1] == '[':
      i += 2
      while i < s.len and s[i] != 'm': inc(i)
      inc(i) # Пропускаем 'm'
    else:
      inc(result)
      inc(i)
  
proc newBranch*(
    displayConfig:  DisplayConfig = newDisplayConfig(),
    style:          BranchStyle   = unicodeStyle
): Branch = 
  result = Branch(
    branchName:           "",
    branchIndentLevel:    0,
    branchDisplayConfig:  displayConfig,
    branchStyle:          style
  )

proc enterBranch*(
    parent: Branch,
    name:   string
): Branch = 
  result = Branch(
    branchName:           name,
    branchIndentLevel:    parent.branchIndentLevel + 1,
    branchDisplayConfig:  parent.branchDisplayConfig,
    branchStyle:          parent.branchStyle
  )

  var symbol = "├"
  if parent.branchStyle == indentStyle: symbol = "╰"
  echo fmt"{formatIndent(parent.branchIndentLevel)}{symbol}─ {name}"

proc leaveBranch*(
    parent: Branch,
    text:   string, 
    status: Status = Ok
): string =
  fmt"{formatIndent(parent.branchIndentLevel)}╰─ {text}"

proc formatBranchLine*(
    parent: Branch,
    text:   string,
    prefix: string = "├─ "
): string =
  fmt"{formatIndent(parent.branchIndentLevel)}{prefix}{text}"

proc formatTableLine*(
    parent: Branch,
    line:   string
): string =
  result = fmt"""{parent.formatBranchLine(line, "│")} {" ".repeat(
    parent.branchDisplayConfig.terminalSize.width - (line.visualLen() + 4) - parent.branchIndentLevel * 3
  )}│"""

proc formatTableMultiLine*(
    parent: Branch,
    lines:  string
): string =
  let maxLineWidth = parent.branchDisplayConfig.terminalSize.width - 3 - parent.branchIndentLevel * 3
  let lineList = lines.splitLines()
  var isFirstLine = true

  for origLine in lineList:
    var line = origLine.strip()  # можно убрать, если не нужно

    # Разбиваем строку на строки длины <= maxLineWidth
    var pos = 0
    let len = line.len

    while pos < len:
      let End = min(pos + maxLineWidth - 1, len - 1)

      # Ищем последний пробел в текущем диапазоне
      var breakPos = -1
      for i in countdown(End, pos):
        if line[i] == ' ':
          breakPos = i
          break

      var chunk: string
      var nextPos: int

      if breakPos >= 0:
        # Разрезаем по пробелу
        chunk = line[pos..<breakPos]
        nextPos = breakPos + 1
      else:
        # Нет пробелов — режем по границе
        chunk = line[pos..End]
        nextPos = End + 1

      # Добавляем отформатированную строку
      if not isFirstLine: result &= "\n"
      result &= parent.formatTableLine(chunk)
      isFirstLine = false

      pos = nextPos

proc formatCodeLine*(
    parent:        Branch,
    lineNum:       int,
    codeLine:      string,
    lineNumIndent: int
): string =
  let lineNumLen = len($lineNum)
  let lineNumIndent = " ".repeat(lineNumIndent - lineNumLen)
  result = fmt"{lineNumIndent}{lineNum}| {codeLine}"

proc formatTableCodeMultiLine*(
    parent:        Branch,
    lineNumFirst:  int,
    codeSnippet:   string
): string =
  var lineNum = lineNumFirst
  var resultCode: seq[string]
  let codeLines = codeSnippet.splitLines()
  let lineNumIndent = len( $(lineNumFirst + codeLines.len) )

  for codeLine in codeLines:
    resultCode.add(
      formatIndent(
        parent.branchIndentLevel
      ) & "│ " & 
      parent.formatCodeLine(
        lineNum, codeLine, lineNumIndent
      ) & " ".repeat(
        parent.branchDisplayConfig.terminalSize.width - (
          (parent.branchIndentLevel * 3) + (
            len( $(lineNumIndent + lineNum) ) + codeLine.visualLen()
          ) + 6
        )
      ) & " │"
    )
    inc(lineNum)

  return resultCode.join("\n")

proc formatTableHeader*(
    parent: Branch, 
    text:   string
): string =
  result = fmt"""{parent.formatBranchLine(text)} {"─".repeat(
    parent.branchDisplayConfig.terminalSize.width - (text.visualLen() + 5) - parent.branchIndentLevel * 3
  )}╮"""

proc formatTableFooter*(parent: Branch): string =
  result = parent.formatBranchLine("", "├─") & "─".repeat(
    parent.branchDisplayConfig.terminalSize.width - 3 - parent.branchIndentLevel * 3
  ) & "╯"

when isMainModule:
  let root = newBranch()
  echo "Compilation"

  let lex = root.enterBranch("Lexical analysis")
  echo lex.formatBranchLine("Tokenization of source code")
  echo lex.formatBranchLine("Processing comments and spaces")
    
  let syntax = lex.enterBranch("syntax analysis")
  echo syntax.formatBranchLine("building AST")
  echo syntax.formatBranchLine("Grammar check")
  echo syntax.formatTableHeader("Program code")
  echo syntax.formatTableCodeMultiLine(1, """// Program
func root::Main : None !(enterPoint) {
    @print "Hello, World!"
}""")
  echo syntax.formatTableFooter()
  
  let semantic = syntax.enterBranch("Semantic analysis")
  echo semantic.formatBranchLine("Type checking")
  echo semantic.formatBranchLine("Building a symbol table")

  let codegen = semantic.enterBranch("Code generation")
  echo codegen.formatBranchLine("Optimization")
  echo codegen.formatBranchLine("Machine code generation")

  echo codegen.leaveBranch("Success", Ok)
  echo semantic.leaveBranch("Success", Ok)
  echo syntax.leaveBranch("Success", Ok)
  echo lex.leaveBranch("Success", Ok)
  echo root.leaveBranch("Success", Ok)
