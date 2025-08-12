# PrettyTerm - Pretty Terminal Printers

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Nim Version](https://img.shields.io/badge/nim-%3E%3D1.6.0-blue.svg)](https://nim-lang.org)
[![Version](https://img.shields.io/badge/version-0.2.4-green.svg)](https://github.com/CodeLibraty/PrettyTerm)

Библиотека для создания красивых терминальных интерфейсов на Nim.

## Описание

PrettyTerm - это мощная Nim библиотека, которая предоставляет инструменты для создания стилизованных и красивых терминальных интерфейсов. Библиотека включает в себя:

- 🎨 Поддержку ANSI цветов и стилей
- 🎭 Систему тематизации с настраиваемыми цветами и иконками
- 📝 Систему тегов для простой стилизации текста
- 🌳 Древовидный принтер для структурированного вывода
- 📊 Продвинутую систему логирования

## Установка

```bash
nimble install prettyterm
```

## Быстрый старт

```nim
import prettyterm

# Использование стилизованных строк
echo sty"<red>Красный текст</red> и <green|bold>жирный зеленый</green|bold>"

# Настройка тем
let config = newDisplayConfig()
# ... использование конфигурации

# Логирование
let logger = newLogger(newLogTime())
let component = newComponent("myfile.nim", "myFunction", "/path")
discard logger.addLog("Тестовое сообщение", component, Ok)
```

## Основные возможности

### 🎨 Цвета и стили

Библиотека предоставляет полный набор ANSI цветов и стилей:

```nim
# Цвета текста
echo FgRed & "Красный текст" & ResetColor
echo FgGreen & "Зеленый текст" & ResetColor
echo FgBlue & "Синий текст" & ResetColor

# Цвета фона
echo BgYellow & "Текст на желтом фоне" & ResetColor

# Стили текста
echo styleBold & "Жирный текст" & ResetColor
echo styleItalic & "Курсивный текст" & ResetColor
echo styleUnderline & "Подчеркнутый текст" & ResetColor
```

### 🎭 Тематизация

Настраиваемая система тем для консистентного оформления:

```nim
# Создание цветовой темы
let customTheme = newColorTheme(
  hintColor = clrBlue,
  errorColor = clrRed,
  successColor = clrGreen,
  warningColor = clrYellow
)

# Создание темы иконок
let customIcons = newIconsTheme(
  hintIcon = "💡",
  errorIcon = "❌",
  successIcon = "✅",
  warningIcon = "⚠️"
)

# Создание конфигурации отображения
let config = newDisplayConfig(
  colorTheme = customTheme,
  iconsTheme = customIcons
)
```

### 📝 Стилизация текста

Простой и интуитивный синтаксис с тегами:

```nim
# Простые теги
echo sty"<red>Красный текст</red>"
echo sty"<green|bold>Жирный зеленый</green|bold>"

# Комбинация стилей
echo sty"<blue|underline|bg-yellow>Синий подчеркнутый на желтом фоне</blue|underline|bg-yellow>"

# Интерполяция переменных
let name = "Мир"
let value = 42
echo sty"Привет, <green>{name}</green>! Значение: <yellow|bold>{value}</yellow|bold>"
```

### 🌳 Древовидный вывод

Структурированный вывод данных с поддержкой ветвления:

```nim
# Создание корневой ветки
let root = newBranch("Анализ проекта")

# Добавление подветок
let lex = root.enterBranch("Лексический анализ")
echo lex.formatBranchLine("Токенизация завершена")

let syntax = lex.enterBranch("Синтаксический анализ")
echo syntax.formatBranchLine("Построение AST")

# Вывод таблиц
echo syntax.formatTableHeader("Результаты")
echo syntax.formatTableLine("Успешно: 100%")
echo syntax.formatTableFooter()

# Вывод кода с нумерацией строк
echo syntax.formatTableCodeMultiLine(1, """
proc hello() =
  echo "Hello, World!"
""")
```

### 📊 Логирование

Мощная система логирования с различными стилями вывода:

```nim
# Создание логгера
let logger = newLogger(
  creationTime = newLogTime(),
  printableInTerminal = true
)

# Создание компонента
let component = newComponent(
  fileName = "main.nim",
  funcName = "main",
  dirPath = "/src"
)

# Добавление логов
logger.style = loggerStyleTiny
discard logger.addLog("Приложение запущено", component, Ok)

logger.style = loggerStyleFull
discard logger.addLog("Ошибка подключения к базе данных", component, Error)

# Завершение работы с сохранением в файл
logger.destroyLogger("./app.log", writeToFile = true)
```

## Структура проекта

```
prettyterm/
├── prettyterm.nim        # Основной модуль
├── prettyterm.nimble    # Файл пакета Nimble
├── src/
│   ├── colors.nim       # ANSI цвета и стили
│   ├── commonTypes.nim  # Базовые типы
│   ├── themeConfig.nim  # Конфигурация тем
│   ├── stylish.nim      # Стилизация текста
│   ├── treePrinter.nim  # Древовидный принтер
│   └── prettyLogger.nim # Система логирования
├── LICENSE              # MIT лицензия
└── README.md           # Документация
```

## Требования

- Nim >= 1.6.0
- Современный терминал с поддержкой ANSI escape-кодов

## Лицензия

MIT License - см. файл [LICENSE](LICENSE)

## Автор

CodeLibraty Foundation  
https://codelibraty.tk

## Вклад в проект

Мы приветствуем вклад в развитие проекта! Пожалуйста, создайте issue или pull request для предложений по улучшению.
