# Модуль themeConfig.nim

## Описание
Модуль `themeConfig.nim` предоставляет систему конфигурации тем для PrettyTerm. Он позволяет создавать настраиваемые цветовые схемы, наборы иконок и общую конфигурацию отображения для консистентного оформления терминальных интерфейсов.

## Назначение
Модуль предназначен для:
- Создания настраиваемых цветовых тем
- Определения наборов иконок для различных статусов
- Предоставления единой конфигурации отображения
- Обеспечения консистентности визуального оформления

## Основные типы и структуры

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

Перечисление `TerminalColors` предоставляет удобные псевдонимы для ANSI цветов, определенных в модуле `colors.nim`.

### ColorTheme
```nim
type
  ColorTheme* = object
    hintColor*:     TerminalColors
    errorColor*:    TerminalColors
    successColor*:  TerminalColors
    warningColor*:  TerminalColors
```

Объект `ColorTheme` определяет цветовую схему для различных типов сообщений и статусов.

### IconsTheme
```nim
type
  IconsTheme* = object
    hintIcon*:      string
    errorIcon*:     string
    successIcon*:   string
    warningIcon*:   string
```

Объект `IconsTheme` определяет набор иконок для визуального обозначения различных статусов.

### DisplayConfig
```nim
type
  DisplayConfig* = object
    colorTheme*:    ColorTheme
    iconsTheme*:    IconsTheme
    terminalSize*:  tuple[width, height: int]
```

Основной объект конфигурации, объединяющий цветовую тему, иконки и размеры терминала.

## Основные функции

### newColorTheme
```nim
proc newColorTheme*(
    hintColor:    TerminalColors = clrBlue;
    errorColor:   TerminalColors = clrRed;
    successColor: TerminalColors = clrGreen;
    warningColor: TerminalColors = clrYellow
): ColorTheme
```

Создает новую цветовую тему с указанными цветами для различных статусов. Все параметры имеют значения по умолчанию.

### newIconsTheme
```nim
proc newIconsTheme*(
    hintIcon:    string = "🛈";
    errorIcon:   string = "✗";
    successIcon: string = "✓";
    warningIcon: string = "⚠"
): IconsTheme
```

Создает новую тему иконок с указанными символами для различных статусов. По умолчанию используются Unicode символы.

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

Создает полную конфигурацию отображения, объединяя цветовую тему, иконки и размеры терминала. Размеры терминала определяются автоматически.

## Где можно применить

### 1. Консистентное оформление приложений
```nim
# Создание единой темы для всего приложения
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

# Использование в различных частях приложения
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
  # ... другие статусы
```

### 2. Тематизация для разных режимов
```nim
# Темы для разных режимов работы
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

# Выбор конфигурации в зависимости от настроек
proc getConfig(useDarkMode: bool, useMinimalIcons: bool): DisplayConfig =
  let theme = if useDarkMode: darkTheme else: lightTheme
  let icons = if useMinimalIcons: minimalIcons else: detailedIcons
  return newDisplayConfig(theme, icons)
```

### 3. Брендинг и корпоративный стиль
```nim
# Корпоративная цветовая схема
let corporateTheme = newColorTheme(
  hintColor = clrBlue,      # Корпоративный синий
  errorColor = clrRed,      # Стандартный красный для ошибок
  successColor = clrGreen,  # Стандартный зеленый для успеха
  warningColor = clrYellow  # Стандартный желтый для предупреждений
)

let corporateIcons = newIconsTheme(
  hintIcon = "[INFO]",
  errorIcon = "[ERROR]",
  successIcon = "[OK]",
  warningIcon = "[WARN]"
)

let corporateConfig = newDisplayConfig(corporateTheme, corporateIcons)
```

### 4. Адаптивный интерфейс
```nim
# Конфигурация с учетом размера терминала
proc createResponsiveConfig(): DisplayConfig =
  let termWidth = terminalWidth()
  let termHeight = terminalHeight()
  
  # Выбор иконок в зависимости от поддержки Unicode
  let icons = if termWidth > 80:
    newIconsTheme("💡", "❌", "✅", "⚠️")
  else:
    newIconsTheme("i", "X", "V", "!")
  
  # Настройка цветов для разных размеров терминала
  let colors = if termWidth > 120:
    newColorTheme(clrBlue, clrRed, clrGreen, clrYellow)
  else:
    newColorTheme(clrCyan, clrRed, clrGreen, clrYellow)
  
  return newDisplayConfig(colors, icons, (termWidth, termHeight))
```

### 5. Мультиязычные интерфейсы
```nim
# Иконки для разных языков
let russianIcons = newIconsTheme("ℹ️", "ОШИБКА", "ОК", "ВНИМАНИЕ")
let englishIcons = newIconsTheme("ℹ️", "ERROR", "OK", "WARNING")
let emojiIcons = newIconsTheme("💡", "❌", "✅", "⚠️")

# Выбор иконок в зависимости от языка
proc getIconsForLanguage(lang: string): IconsTheme =
  case lang.toLower()
  of "ru", "russian": return russianIcons
  of "en", "english": return englishIcons
  else: return emojiIcons
```

## Интеграция с другими модулями

Модуль `themeConfig.nim` тесно интегрирован с другими модулями PrettyTerm:

### С colors.nim
Использует константы ANSI цветов из модуля `colors.nim` для определения цветовых схем.

### С commonTypes.nim
Типы статусов из `commonTypes.nim` используются для выбора соответствующих цветов и иконок.

### С prettyLogger.nim
Конфигурация тем может использоваться для стилизации вывода логгера.

### С stylish.nim
Цветовые темы могут применяться для стилизации текста с тегами.

## Преимущества использования

### 1. Консистентность
Единая система тем обеспечивает консистентное оформление всего приложения.

### 2. Гибкость
Легко настраивать цвета и иконки под разные нужды и предпочтения.

### 3. Масштабируемость
Просто добавлять новые темы и наборы иконок без изменения кода приложения.

### 4. Интеграция
Тесная интеграция с другими модулями PrettyTerm обеспечивает единый подход к стилизации.

## Зависимости
Модуль зависит от:
- Стандартной библиотеки Nim (модуль `terminal`)
- Модуля `colors.nim` из PrettyTerm

Модуль `themeConfig.nim` является ключевым компонентом для создания консистентных и настраиваемых терминальных интерфейсов в PrettyTerm.
