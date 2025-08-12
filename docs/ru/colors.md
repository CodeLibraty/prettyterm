# Модуль colors.nim

## Описание
Модуль `colors.nim` предоставляет константы для ANSI escape-кодов, которые используются для цветового оформления и стилизации текста в терминале. Это фундаментальный модуль, на котором строится вся визуальная часть библиотеки PrettyTerm.

## Назначение
Модуль предназначен для:
- Предоставления стандартных ANSI цветов для текста
- Предоставления ANSI цветов для фона
- Предоставления стилей форматирования текста
- Упрощения работы с цветовым оформлением терминала

## Основные константы

### Цвета текста
```nim
FgBlack*    = "\e[30m"    # Черный текст
FgRed*      = "\e[31m"    # Красный текст
FgGreen*    = "\e[32m"    # Зеленый текст
FgYellow*   = "\e[33m"    # Желтый текст
FgBlue*     = "\e[34m"    # Синий текст
FgMagenta*  = "\e[35m"    # Пурпурный текст
FgCyan*     = "\e[36m"    # Бирюзовый текст
FgWhite*    = "\e[37m"    # Белый текст
```

### Цвета фона
```nim
BgBlack*    = "\e[40m"    # Черный фон
BgRed*      = "\e[41m"    # Красный фон
BgGreen*    = "\e[42m"    # Зеленый фон
BgYellow*   = "\e[43m"    # Желтый фон
BgBlue*     = "\e[44m"    # Синий фон
BgMagenta*  = "\e[45m"    # Пурпурный фон
BgCyan*     = "\e[46m"    # Бирюзовый фон
BgWhite*    = "\e[47m"    # Белый фон
```

### Стили текста
```nim
styleBold*        = "\e[1m"   # Жирный текст
styleFaded*       = "\e[2m"   # Тусклый текст
styleItalic*      = "\e[3m"   # Курсивный текст
styleUnderline*   = "\e[4m"   # Подчеркнутый текст
styleBlinking*    = "\e[5m"   # Мигающий текст
styleCrossedOut*  = "\e[9m"   # Зачеркнутый текст

ResetColor*       = "\e[0m"   # Сброс всех цветов и стилей
```

## Где можно применить

### 1. Простое окрашивание текста
```nim
# Вывод цветного текста
echo FgRed & "Ошибка: " & ResetColor & "что-то пошло не так"
echo FgGreen & "Успех: " & ResetColor & "операция завершена"
echo BgYellow & FgBlack & "Предупреждение" & ResetColor
```

### 2. Комбинирование стилей
```nim
# Жирный красный текст
echo styleBold & FgRed & "Важное сообщение" & ResetColor

# Подчеркнутый синий текст
echo styleUnderline & FgBlue & "Ссылка" & ResetColor
```

### 3. Создание цветовых схем
```nim
# Определение цветовой схемы для приложения
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

### 4. Интерфейсы командной строки
```nim
# Создание цветного меню
echo FgCyan & "=== Главное меню ===" & ResetColor
echo FgGreen & "1. Начать работу" & ResetColor
echo FgYellow & "2. Настройки" & ResetColor
echo FgRed & "3. Выход" & ResetColor
```

### 5. Отладка и логирование
```nim
# Цветной вывод для отладки
echo FgMagenta & "[DEBUG] " & ResetColor & "Переменная x = " & $x
echo FgBlue & "[INFO] " & ResetColor & "Подключение к базе данных"
```

## Особенности использования

1. **Всегда сбрасывайте цвета** - после использования цветовых кодов обязательно используйте `ResetColor`, чтобы избежать "залипания" цветов в терминале.

2. **Комбинируйте стили** - можно комбинировать несколько стилей, просто объединяя строки с escape-кодами.

3. **Проверяйте поддержку** - убедитесь, что терминал пользователя поддерживает ANSI escape-коды.

4. **Используйте для акцентов** - цвета лучше использовать для выделения важной информации, а не для всего текста.

## Зависимости
Модуль не имеет внешних зависимостей и использует только стандартные возможности Nim.

## Примеры использования

```nim
# Простой пример
echo FgRed & "Это красный текст" & ResetColor
echo BgBlue & FgWhite & "Белый текст на синем фоне" & ResetColor
echo styleBold & FgGreen & "Жирный зеленый текст" & ResetColor

# Комплексный пример
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

printStatus("success", "Операция выполнена успешно")
printStatus("error", "Произошла ошибка")
printStatus("warning", "Внимание: возможны проблемы")
```

Этот модуль является основой для всех остальных компонентов библиотеки PrettyTerm и предоставляет низкоуровневый доступ к ANSI escape-кодам для терминала.
