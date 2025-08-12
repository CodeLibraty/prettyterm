#
#  PrettyTerm - Pretty Terminal Printers 
#  =================================
#  Module:      src/stylish.nim
#  Repository:  https://github.com/CodeLibraty/PrettyTerm
#
#  Make your terminal interfaces prettier!
#
#  MIT © 2025 CodeLibraty Foundation | https://codelibraty.vercel.app
# 

import std/[
  macros, strutils
]

import ./[
  colors
]

# Функция для обработки стилевых тегов
proc processStyleTags*(text: string): string =
  var i = 0
  var styleStack: seq[string] = @[]
  
  while i < text.len:
    if text[i] == '<':
      # Начало тега
      var isClosing = false
      inc(i) # Пропускаем <
      
      if i < text.len - 1 and text[i] == '/':
        isClosing = true
        inc(i) # Пропускаем /
      
      var tag = ""
      while i < text.len and text[i] != '>':
        tag.add(text[i])
        inc(i)
      
      if i < text.len: inc(i) # Пропускаем >
      
      if isClosing:
        # Закрывающий тег - восстанавливаем предыдущий стиль
        if styleStack.len > 0:
          discard styleStack.pop()
          result.add("\e[0m")
          # Восстанавливаем все активные стили
          for style in styleStack:
            let styles = style.split('|')
            for s in styles:
              case s.toLowerAscii()
              of "red":           result.add(FgRed)
              of "green":         result.add(FgGreen)
              of "blue":          result.add(FgBlue)
              of "yellow":        result.add(FgYellow)
              of "magenta":       result.add(FgMagenta)
              of "cyan":          result.add(FgCyan)
              of "white":         result.add(FgWhite)
              of "black":         result.add(FgBlack)
              of "bold":          result.add(styleBold)
              of "italic":        result.add(styleItalic)
              of "underline":     result.add(styleUnderline)
              of "faded":         result.add(styleFaded)
              of "blinking":      result.add(styleBlinking)
              of "сrossedOut":    result.add(styleCrossedOut)
              of "bg-red":        result.add(BgRed)
              of "bg-green":      result.add(BgGreen)
              of "bg-blue":       result.add(BgBlue)
              of "bg-yellow":     result.add(BgYellow)
              of "bg-magenta":    result.add(BgMagenta)
              of "bg-cyan":       result.add(BgCyan)
              of "bg-white":      result.add(BgWhite)
              of "bg-black":      result.add(BgBlack)
              else: discard
      else:
        # Открывающий тег - применяем стиль
        styleStack.add(tag)
        let styles = tag.split('|')
        for s in styles:
          case s.toLowerAscii()
          of "red":           result.add(FgRed)
          of "green":         result.add(FgGreen)
          of "blue":          result.add(FgBlue)
          of "yellow":        result.add(FgYellow)
          of "magenta":       result.add(FgMagenta)
          of "cyan":          result.add(FgCyan)
          of "white":         result.add(FgWhite)
          of "black":         result.add(FgBlack)
          of "bold":          result.add(styleBold)
          of "italic":        result.add(styleItalic)
          of "underline":     result.add(styleUnderline)
          of "faded":         result.add(styleFaded)
          of "blinking":      result.add(styleBlinking)
          of "сrossedOut":    result.add(styleCrossedOut)
          of "bg-red":        result.add(BgRed)
          of "bg-green":      result.add(BgGreen)
          of "bg-blue":       result.add(BgBlue)
          of "bg-yellow":     result.add(BgYellow)
          of "bg-magenta":    result.add(BgMagenta)
          of "bg-cyan":       result.add(BgCyan)
          of "bg-white":      result.add(BgWhite)
          of "bg-black":      result.add(BgBlack)
          else: discard
    else:
      # Обычный символ
      result.add(text[i])
      inc(i)
  
  # Сбрасываем все стили в конце
  if styleStack.len > 0:
    result.add(ResetColor)
  
  return result # Макрос для f-строк с поддержкой тегов и интерполяции

macro sty*(text: static string): string =
  var resultStr = ""
  var i = 0
  
  while i < text.len:
    if text[i] == '{':
      # Начало выражения
      inc(i) # Пропускаем {
      var expr = ""
      
      # Собираем выражение до закрывающей скобки
      while i < text.len - 1 and text[i] != '}':
        expr.add(text[i])
        inc(i)
      
      # Пропускаем закрывающую скобку
      if i < text.len: inc(i)
      
      # Добавляем выражение в результат
      resultStr.add("\" & $(" & expr & ") & \"")
    else:
      # Обычный символ или тег
      if text[i] == '"': resultStr.add("\\\"")
      elif text[i] == '\\': resultStr.add("\\\\")
      else: resultStr.add(text[i])
      inc(i)
  
  # Обрабатываем теги в результате
  let processedStr = "processStyleTags(\"" & resultStr & "\")"
  result = parseExpr(processedStr)

# Пример использования
when isMainModule:
  var name = "Максим"
  let value = 42
  
  echo sty"Привет, <red>{name}</red>! Значение: <green|bold>{value}</green|bold>"
  echo sty"<blue|underline|bg-green>Подчеркнутый синий</blue|underline|bg-green> и <yellow|italic>курсивный желтый</yellow|italic>"
  echo sty"<red|bold|underline>Комбинированные стили</red|bold|underline>"
  echo sty"<blue|faded>Комбинированные стили</blue|faded>"
  echo sty"<green|blinking>Комбинированные стили</green|blinking>"
  echo sty"<cyan|сrossedOut>Комбинированные стили</cyan|сrossedOut>"
