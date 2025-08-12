# Модуль stylish.nim

## Описание
Модуль `stylish.nim` предоставляет мощную систему стилизации текста с использованием HTML-подобных тегов и макроса `sty` для интерполяции переменных. Это один из самых удобных и интуитивных модулей PrettyTerm для создания стилизованного текста.

## Назначение
Модуль предназначен для:
- Упрощения стилизации текста с использованием тегов вместо ANSI кодов
- Предоставления удобного синтаксиса для интерполяции переменных
- Поддержки комбинации множественных стилей
- Автоматической обработки ANSI escape-кодов и сброса стилей

## Основные функции

### processStyleTags
```nim
proc processStyleTags*(text: string): string
```

Основная функция, которая обрабатывает текст с тегами стилизации и преобразует их в ANSI escape-коды. Функция поддерживает:
- Открытие и закрытие тегов (`<tag>...</tag>`)
- Комбинацию нескольких стилей (`<red|bold>...</red|bold>`)
- Автоматический сброс стилей при закрытии тегов
- Вложенные теги и правильное управление стеком стилей

### sty
```nim
macro sty*(text: static string): string
```

Макрос, который предоставляет удобный синтаксис для стилизации текста с поддержкой интерполяции переменных. Поддерживает:
- Интерполяцию переменных в фигурных скобках: `{variable}`
- Автоматическую обработку тегов стилизации
- Компиляционную проверку синтаксиса

## Поддерживаемые теги и стили

### Цвета текста
- `<red>` - Красный текст
- `<green>` - Зеленый текст
- `<blue>` - Синий текст
- `<yellow>` - Желтый текст
- `<magenta>` - Пурпурный текст
- `<cyan>` - Бирюзовый текст
- `<white>` - Белый текст
- `<black>` - Черный текст

### Цвета фона
- `<bg-red>` - Красный фон
- `<bg-green>` - Зеленый фон
- `<bg-blue>` - Синий фон
- `<bg-yellow>` - Желтый фон
- `<bg-magenta>` - Пурпурный фон
- `<bg-cyan>` - Бирюзовый фон
- `<bg-white>` - Белый фон
- `<bg-black>` - Черный фон

### Стили текста
- `<bold>` - Жирный текст
- `<italic>` - Курсивный текст
- `<underline>` - Подчеркнутый текст
- `<faded>` - Тусклый текст
- `<blinking>` - Мигающий текст
- `<crossedOut>` - Зачеркнутый текст

## Где можно применить

### 1. Интерактивные консольные приложения
```nim
# Создание интерактивных меню и интерфейсов
proc showMainMenu() =
  echo sty"<cyan|bold>=== Главное меню ===</cyan|bold>"
  echo sty"<green>1. Начать работу</green>"
  echo sty"<yellow>2. Настройки</yellow>"
  echo sty"<red>3. Выход</red>"
  echo sty"<blue>Выберите пункт: </blue>"

# Использование
showMainMenu()
```

### 2. Логирование с цветовым выделением
```nim
# Цветное логирование с уровнями важности
proc log(level, message: string) =
  case level.toLower()
  of "error":
    echo sty"<red|bold>[ERROR]</red|bold> {message}"
  of "warn":
    echo sty"<yellow|bold>[WARN]</yellow|bold> {message}"
  of "info":
    echo sty"<blue|bold>[INFO]</blue|bold> {message}"
  of "success":
    echo sty"<green|bold>[SUCCESS]</green|bold> {message}"
  else:
    echo sty"[{level}] {message}"

# Использование
log("error", "Ошибка подключения к базе данных")
log("success", "Операция завершена успешно")
```

### 3. Отчеты и таблицы
```nim
# Создание цветных отчетов
proc printReport(data: seq[tuple[name: string, value: int, status: string]]) =
  echo sty"<cyan|bold>=== Отчет о выполнении ===</cyan|bold>"
  for item in data:
    let statusColor = if item.status == "ok": "green" else: "red"
    echo sty"• {item.name}: <{statusColor}>{item.value}</{statusColor}> [{item.status}]"

# Использование
let reportData = @[
  ("Задача 1", 100, "ok"),
  ("Задача 2", 75, "error"),
  ("Задача 3", 90, "ok")
]
printReport(reportData)
```

### 4. Прогресс-бары и индикаторы
```nim
# Создание прогресс-баров
proc showProgress(current, total: int) =
  let percentage = (current * 100) div total
  let filledLength = (current * 20) div total
  let bar = "█".repeat(filledLength) & " ".repeat(20 - filledLength)
  
  echo sty"\r<yellow>Прогресс: [{bar}]</yellow> <cyan|bold>{percentage}%</cyan|bold> <green>({current}/{total})</green>"
  stdout.flushFile()

# Использование
for i in 0..100:
  showProgress(i, 100)
  sleep(50)
echo ""
```

### 5. Валидация и формы
```nim
# Валидация пользовательского ввода с подсветкой ошибок
proc validateInput(input: string): bool =
  if input.len == 0:
    echo sty"<red|bold>Ошибка: Поле не может быть пустым</red|bold>"
    return false
  if input.len < 3:
    echo sty"<yellow>Предупреждение: Слишком короткое значение</yellow>"
    return false
  echo sty"<green>✓ Ввод корректен</green>"
  return true

# Использование
while true:
  stdout.write sty"<blue>Введите значение (минимум 3 символа): </blue>"
  let input = stdin.readLine()
  if validateInput(input):
    break
```

### 6. Игровые и развлекательные приложения
```nim
# Текстовые игры с цветовым оформлением
proc showGameStats(player: tuple[name: string, hp: int, mp: int]) =
  echo sty"<magenta|bold>=== {player.name} ===</magenta|bold>"
  echo sty"<red>❤️ HP: {player.hp}</red>"
  echo sty"<blue>💧 MP: {player.mp}</blue>"

proc battleMessage(attacker, target: string, damage: int) =
  echo sty"<yellow>{attacker}</yellow> наносит <red|bold>{damage}</red|bold> урона <cyan>{target}</cyan>"

# Использование
let player = (name: "Герой", hp: 100, mp: 50)
showGameStats(player)
battleMessage("Герой", "Дракон", 25)
```

### 7. Системы помощи и документация
```nim
# Создание цветной справки
proc showHelp() =
  echo sty"<cyan|bold>=== Доступные команды ===</cyan|bold>"
  echo sty"<green>help</green>     - показать эту справку"
  echo sty"<blue>start</blue>    - начать работу"
  echo sty"<yellow>config</yellow>  - открыть настройки"
  echo sty"<red>exit</red>     - выйти из программы"

# Использование
showHelp()
```

### 8. Динамические сообщения с переменными
```nim
# Персонализированные сообщения
proc greetUser(name: string, isAdmin: bool) =
  if isAdmin:
    echo sty"<green|bold>Добро пожаловать, {name}!</green|bold> <red|italic>(Администратор)</red|italic>"
  else:
    echo sty"<blue>Привет, {name}!</blue>"

proc showSystemInfo(os: string, version: string, uptime: int) =
  echo sty"<cyan>Система: <bold>{os}</bold></cyan>"
  echo sty"<yellow>Версия: <italic>{version}</italic></yellow>"
  echo sty"<green>Аптайм: {uptime} часов</green>"

# Использование
greetUser("Александр", true)
showSystemInfo("Linux", "5.4.0", 72)
```

## Комбинирование стилей

### Множественные стили
```nim
# Комбинация цветов и стилей
echo sty"<red|bold|underline>Жирный подчеркнутый красный текст</red|bold|underline>"
echo sty"<blue|italic|bg-yellow>Курсивный синий на желтом фоне</blue|italic|bg-yellow>"
echo sty"<green|bold|underline|italic>Все стили сразу</green|bold|underline|italic>"
```

### Сложные комбинации
```nim
# Комплексное форматирование
proc formatComplexMessage(title: string, content: string, status: string) =
  let statusColors = {"ok": "green", "error": "red", "warning": "yellow"}.toTable
  let color = statusColors.getOrDefault(status.toLower, "white")
  
  echo sty"<cyan|bold>[{status.upper()}]</cyan|bold> <{color}|underline>{title}</{color}|underline>"
  echo sty"  <italic>{content}</italic>"

# Использование
formatComplexMessage("Успешное подключение", "Соединение с сервером установлено", "ok")
formatComplexMessage("Ошибка сети", "Не удалось подключиться к удаленному серверу", "error")
```

## Продвинутые техники

### Создание шаблонов
```nim
# Создание переиспользуемых шаблонов
proc createHeader(title: string): string =
  result = sty"<cyan|bold>=== {title} ===</cyan|bold>"

proc createFooter(): string =
  result = sty"<yellow>--- Конец отчета ---</yellow>"

proc generateReport(title: string, data: seq[string]) =
  echo createHeader(title)
  for item in data:
    echo sty"• {item}"
  echo createFooter()

# Использование
let tasks = @["Завершить проект", "Написать тесты", "Обновить документацию"]
generateReport("Задачи на неделю", tasks)
```

## Преимущества использования

### 1. Читаемость
Синтаксис с тегами гораздо более читаем, чем прямое использование ANSI escape-кодов.

### 2. Безопасность
Автоматическая обработка сброса стилей предотвращает "залипание" цветов в терминале.

### 3. Гибкость
Легко комбинировать множественные стили и создавать сложные визуальные эффекты.

### 4. Интерполяция
Поддержка интерполяции переменных делает код более чистым и понятным.

### 5. Расширяемость
Просто добавлять новые теги и стили по мере необходимости.
