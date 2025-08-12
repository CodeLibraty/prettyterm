# Модуль treePrinter.nim

## Описание
Модуль `treePrinter.nim` предоставляет мощную систему для создания структурированного древовидного вывода в терминале. Этот модуль позволяет создавать иерархические структуры данных с визуальным представлением ветвления, поддержкой таблиц, кода и многострочного текста.

## Назначение
Модуль предназначен для:
- Создания иерархических структур вывода с визуальным ветвлением
- Форматирования таблиц с автоматической адаптацией под ширину терминала
- Вывода кода с нумерацией строк и подсветкой
- Обработки многострочного текста с переносом по словам
- Предоставления двух стилей ветвления: Unicode и отступы

## Основные типы и структуры

### BranchStyle
```nim
type
  BranchStyle* = enum
    unicodeStyle = "│  "    # стандартный: веточный
    indentStyle  = "   "     # с отступами вместо веток
```

Перечисление `BranchStyle` определяет стиль визуализации ветвления в древовидной структуре.

### Branch
```nim
type
  Branch* = ref object
    branchName*:          string
    branchMessage*:       string
    branchIndentLevel*:   int
    branchDisplayConfig*: DisplayConfig
    branchStyle*:         BranchStyle
```

Основной объект `Branch` представляет собой ветку в древовидной структуре с именем, сообщением, уровнем отступа, конфигурацией отображения и стилем ветвления.

## Основные функции

### newBranch
```nim
proc newBranch*(
    name:           string        = "",
    displayConfig:  DisplayConfig = newDisplayConfig(),
    style:          BranchStyle   = unicodeStyle
): Branch
```

Создает новую корневую ветку с указанными параметрами. Выводит имя ветки в терминал. 
Для root ветки

### enterBranch
```nim
proc enterBranch*(
    parent: Branch,
    name:   string
): Branch
```

Создает дочернюю ветку с увеличенным уровнем отступа. Выводит визуальное представление ветвления.

### leaveBranch
```nim
proc leaveBranch*(
    parent: Branch,
    text:   string, 
    status: Status = Ok
): string
```

Форматирует строку для завершения ветки с указанным текстом и статусом.

### formatBranchLine
```nim
proc formatBranchLine*(
    parent: Branch,
    text:   string,
    prefix: string = "├─"
): string
```

Форматирует строку с отступами и префиксом для отображения в ветке.

### formatTableLine
```nim
proc formatTableLine*(
    parent: Branch,
    line:   string
): string
```

Форматирует строку как часть таблицы с вертикальными линиями и автоматической адаптацией под ширину терминала.

### formatTableMultiLine
```nim
proc formatTableMultiLine*(
    parent: Branch,
    lines:  string
): string
```

Обрабатывает многострочный текст, разбивая его на строки заданной ширины и форматируя как таблицу.

### formatCodeLine
```nim
proc formatCodeLine*(
    parent:        Branch,
    lineNum:       int,
    codeLine:      string,
    lineNumIndent: int
): string
```

Форматирует строку кода с нумерацией строк и выравниванием.

### formatTableCodeMultiLine
```nim
proc formatTableCodeMultiLine*(
    parent:        Branch,
    lineNumFirst:  int,
    codeSnippet:   string
): string
```

Форматирует многострочный код с нумерацией строк и адаптацией под ширину терминала.

### formatTableHeader
```nim
proc formatTableHeader*(
    parent: Branch, 
    text:   string
): string
```

Создает заголовок таблицы с декоративными линиями.

### formatTableFooter
```nim
proc formatTableFooter*(parent: Branch): string
```

Создает нижнюю границу таблицы.

## Вспомогательные функции

### formatIndent
```nim
proc formatIndent*(
    indent:      int, 
    branchStyle: BranchStyle = unicodeStyle
): string
```

Форматирует отступы в зависимости от уровня вложенности и стиля ветвления.

### visualLen
```nim
proc visualLen*(s: string): int
```

Вычисляет визуальную длину строки, игнорируя ANSI escape-коды.

## Где можно применить

### 1. Анализ компиляторов и интерпретаторов
```nim
# Вывод структуры компиляции
proc showCompilationProcess() =
  let root = newBranch("Project compilation")

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

# Использование
showCompilationProcess()
```

### 2. Системы сборки и CI/CD
```nim
# Вывод процесса сборки
proc showBuildPipeline() =
  let root = newBranch("Сборка проекта")
  
  let checkout = root.enterBranch("Checkout")
  echo checkout.formatBranchLine("Клонирование репозитория")
  echo checkout.formatBranchLine("Переключение на ветку develop")
  
  let install = root.enterBranch("Install dependencies")
  echo install.formatBranchLine("Установка Nim")
  echo install.formatBranchLine("Установка зависимостей проекта")
  
  let test = root.enterBranch("Test")
  echo test.formatBranchLine("Запуск unit-тестов")
  echo test.formatBranchLine("Запуск integration-тестов")
  
  let build = root.enterBranch("Build")
  echo build.formatBranchLine("Компиляция исходного кода")
  echo build.formatBranchLine("Сборка артефактов")

# Использование
showBuildPipeline()
```

### 3. Файловые системы и навигация
```nim
# Вывод структуры директорий
proc showDirectoryStructure(path: string) =
  let root = newBranch("Структура директории: " & path)
  
  for kind, file in walkDir(path):
    if kind == pcDir:
      let dirBranch = root.enterBranch("📁 " & file)
      # Рекурсивный обход поддиректорий
      for subKind, subFile in walkDir(path / file):
        if subKind == pcFile:
          echo dirBranch.formatBranchLine("📄 " & subFile)
    else:
      echo root.formatBranchLine("📄 " & file)

# Использование
showDirectoryStructure("/src")
```

### 4. Отладка и профилирование
```nim
# Вывод результатов профилирования
proc showProfilingResults(results: seq[tuple[name: string, time: float, calls: int]]) =
  let root = newBranch("Результаты профилирования")
  
  for result in results:
    let branch = root.enterBranch(result.name)
    echo branch.formatBranchLine("Время выполнения: " & $result.time & " мс")
    echo branch.formatBranchLine("Количество вызовов: " & $result.calls)
    echo branch.formatBranchLine("Среднее время: " & $(result.time / result.calls) & " мс")

# Использование
let profilingData = @[
  ("parseInput", 15.2, 1000),
  ("processData", 45.7, 500),
  ("generateOutput", 8.3, 1000)
]
showProfilingResults(profilingData)
```

### 5. Базы данных и запросы
```nim
# Вывод структуры базы данных
proc showDatabaseSchema() =
  let root = newBranch("Структура базы данных")
  
  let users = root.enterBranch("Таблица: users")
  echo users.formatTableHeader("Поля")
  echo users.formatTableLine("id: INTEGER PRIMARY KEY")
  echo users.formatTableLine("name: VARCHAR(255) NOT NULL")
  echo users.formatTableLine("email: VARCHAR(255) UNIQUE")
  echo users.formatTableLine("created_at: TIMESTAMP")
  echo users.formatTableFooter()
  
  let orders = root.enterBranch("Таблица: orders")
  echo orders.formatTableHeader("Поля")
  echo orders.formatTableLine("id: INTEGER PRIMARY KEY")
  echo orders.formatTableLine("user_id: INTEGER REFERENCES users(id)")
  echo orders.formatTableLine("total: DECIMAL(10,2)")
  echo orders.formatTableLine("status: VARCHAR(50)")
  echo orders.formatTableFooter()

# Использование
showDatabaseSchema()
```

### 6. Вывод кода с подсветкой
```nim
# Демонстрация кода с нумерацией строк
proc showCodeExample() =
  let root = newBranch("Пример кода")
  
  let example = root.enterBranch("Функция сортировки")
  echo example.formatTableHeader("Исходный код")
  echo example.formatTableCodeMultiLine(1, """
proc bubbleSort(arr: var seq[int]) =
  let n = arr.len
  for i in 0..<n:
    for j in 0..<n-i-1:
      if arr[j] > arr[j+1]:
        swap(arr[j], arr[j+1])

proc main() =
  var data = @[64, 34, 25, 12, 22, 11, 90]
  echo "До сортировки: ", data
  bubbleSort(data)
  echo "После сортировки: ", data
""")
  echo example.formatTableFooter()

# Использование
showCodeExample()
```

### 7. Логирование событий
```nim
# Структурированное логирование событий
proc showEventLog() =
  let root = newBranch("Журнал событий")
  
  let session = root.enterBranch("Сессия пользователя")
  echo session.formatBranchLine("Начало сессии: 2025-01-15 10:30:00")
  echo session.formatBranchLine("Пользователь: admin@example.com")
  
  let actions = session.enterBranch("Действия")
  echo actions.formatBranchLine("Вход в систему")
  echo actions.formatBranchLine("Открытие документа 'report.pdf'")
  echo actions.formatBranchLine("Редактирование документа")
  echo actions.formatBranchLine("Сохранение изменений")
  
  let errors = session.enterBranch("Ошибки")
  echo errors.formatBranchLine("Ошибка сохранения: недостаточно прав")
  echo errors.formatBranchLine("Предупреждение: документ заблокирован")

# Использование
showEventLog()
```

### 8. Сетевые запросы и API
```nim
# Вывод цепочки сетевых запросов
proc showApiRequestChain() =
  let root = newBranch("Цепочка API запросов")
  
  let auth = root.enterBranch("Аутентификация")
  echo auth.formatBranchLine("POST /api/auth/login")
  echo auth.formatBranchLine("Status: 200 OK")
  echo auth.formatBranchLine("Token: eyJhbGciOiJIUzI1NiIs...")
  
  let profile = auth.enterBranch("Получение профиля")
  echo profile.formatBranchLine("GET /api/user/profile")
  echo profile.formatBranchLine("Status: 200 OK")
  echo profile.formatBranchLine("User: John Doe")
  
  let data = profile.enterBranch("Загрузка данных")
  echo data.formatBranchLine("GET /api/data/list")
  echo data.formatBranchLine("Status: 200 OK")
  echo data.formatBranchLine("Items: 42")

# Использование
showApiRequestChain()
```

## Продвинутые техники

### Адаптивный вывод в зависимости от размера терминала
```nim
proc createResponsiveTree() =
  let termWidth = terminalWidth()
  let style = if termWidth > 80: unicodeStyle else: indentStyle
  
  let config = newDisplayConfig()
  config.terminalSize = (termWidth, terminalHeight())
  
  let root = newBranch("Адаптивное дерево", config, style)
  # Добавление веток с учетом размера терминала
```

### Комбинирование с цветовой темой
```nim
proc createThemedTree() =
  let theme = newColorTheme(
    hintColor = clrBlue,
    errorColor = clrRed,
    successColor = clrGreen,
    warningColor = clrYellow
  )
  
  let config = newDisplayConfig(theme)
  let root = newBranch("Тематизированное дерево", config)
  
  let successBranch = root.enterBranch("Успешная операция")
  echo successBranch.formatBranchLine(config.colorTheme.successColor & "✓ Операция завершена" & ResetColor)
  
  let errorBranch = root.enterBranch("Ошибка")
  echo errorBranch.formatBranchLine(config.colorTheme.errorColor & "✗ Произошла ошибка" & ResetColor)
```

## Интеграция с другими модулями

### С themeConfig.nim
Использует `DisplayConfig` для настройки цветов, иконок и размеров терминала.

### С colors.nim
Использует цветовые константы для дополнительного форматирования вывода.

### С commonTypes.nim
Использует тип `Status` для обозначения состояния операций.

## Преимущества использования

### 1. Визуальная清晰ность
Древовидная структура с визуальным ветвлением делает вывод легко читаемым и интуитивно понятным.

### 2. Гибкость
Два стиля ветвления позволяют адаптировать вывод под разные терминалы и предпочтения.

### 3. Многофункциональность
Поддержка таблиц, кода, многострочного текста делает модуль универсальным инструментом.

### 4. Адаптивность
Автоматическая адаптация под ширину терминала обеспечивает корректное отображение на разных экранах.

### 5. Масштабируемость
Легко создавать сложные иерархические структуры с любым уровнем вложенности.

## Примеры комплексного использования

```nim
# Комплексный пример использования treePrinter
proc demonstrateTreePrinter() =
  # Создаем корневую ветку с настройками
  let config = newDisplayConfig()
  let root = newBranch("Анализ проекта PrettyTerm", config)
  
  # Анализ модулей
  let modules = root.enterBranch("Структура модулей")
  
  let coreModule
