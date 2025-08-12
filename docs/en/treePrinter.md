# treePrinter.nim Module

## Description
The `treePrinter.nim` module provides a powerful system for creating structured tree output in the terminal. This module allows creating hierarchical data structures with visual branching representation, supporting tables, code, and multiline text.

## Purpose
The module is designed for:
- Creating hierarchical output structures with visual branching
- Formatting tables with automatic terminal width adaptation
- Outputting code with line numbering and highlighting
- Processing multiline text with word wrapping
- Providing two branching styles: Unicode and indents

## Main Types and Structures

### BranchStyle
```nim
type
  BranchStyle* = enum
    unicodeStyle = "│  "    # standard: tree-like
    indentStyle  = "   "     # with indents instead of branches
```

The `BranchStyle` enumeration defines the visualization style of branching in the tree structure.

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

The main `Branch` object represents a branch in the tree structure with a name, message, indent level, display configuration, and branching style.

## Main Functions

### newBranch
```nim
proc newBranch*(
    name:           string        = "",
    displayConfig:  DisplayConfig = newDisplayConfig(),
    style:          BranchStyle   = unicodeStyle
): Branch
```

Creates a new root branch with specified parameters. Outputs the branch name to the terminal.
For root branch

### enterBranch
```nim
proc enterBranch*(
    parent: Branch,
    name:   string
): Branch
```

Creates a child branch with increased indent level. Outputs visual branching representation.

### leaveBranch
```nim
proc leaveBranch*(
    parent: Branch,
    text:   string, 
    status: Status = Ok
): string
```

Formats a string for completing a branch with specified text and status.

### formatBranchLine
```nim
proc formatBranchLine*(
    parent: Branch,
    text:   string,
    prefix: string = "├─"
): string
```

Formats a string with indents and prefix for display in a branch.

### formatTableLine
```nim
proc formatTableLine*(
    parent: Branch,
    line:   string
): string
```

Formats a string as part of a table with vertical lines and automatic terminal width adaptation.

### formatTableMultiLine
```nim
proc formatTableMultiLine*(
    parent: Branch,
    lines:  string
): string
```

Processes multiline text, breaking it into lines of specified width and formatting as a table.

### formatCodeLine
```nim
proc formatCodeLine*(
    parent:        Branch,
    lineNum:       int,
    codeLine:      string,
    lineNumIndent: int
): string
```

Formats a code line with line numbering and alignment.

### formatTableCodeMultiLine
```nim
proc formatTableCodeMultiLine*(
    parent:        Branch,
    lineNumFirst:  int,
    codeSnippet:   string
): string
```

Formats multiline code with line numbering and terminal width adaptation.

### formatTableHeader
```nim
proc formatTableHeader*(
    parent: Branch, 
    text:   string
): string
```

Creates a table header with decorative lines.

### formatTableFooter
```nim
proc formatTableFooter*(parent: Branch): string
```

Creates a table bottom border.

## Helper Functions

### formatIndent
```nim
proc formatIndent*(
    indent:      int, 
    branchStyle: BranchStyle = unicodeStyle
): string
```

Formats indents depending on nesting level and branching style.

### visualLen
```nim
proc visualLen*(s: string): int
```

Calculates the visual length of a string, ignoring ANSI escape codes.

## Where to Apply

### 1. Compiler and Interpreter Analysis
```nim
# Output compilation structure
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

# Usage
showCompilationProcess()
```

### 2. Build Systems and CI/CD
```nim
# Output build process
proc showBuildPipeline() =
  let root = newBranch("Project build")
  
  let checkout = root.enterBranch("Checkout")
  echo checkout.formatBranchLine("Repository cloning")
  echo checkout.formatBranchLine("Switching to develop branch")
  
  let install = root.enterBranch("Install dependencies")
  echo install.formatBranchLine("Installing Nim")
  echo install.formatBranchLine("Installing project dependencies")
  
  let test = root.enterBranch("Test")
  echo test.formatBranchLine("Running unit tests")
  echo test.formatBranchLine("Running integration tests")
  
  let build = root.enterBranch("Build")
  echo build.formatBranchLine("Source code compilation")
  echo build.formatBranchLine("Building artifacts")

# Usage
showBuildPipeline()
```

### 3. File Systems and Navigation
```nim
# Output directory structure
proc showDirectoryStructure(path: string) =
  let root = newBranch("Directory structure: " & path)
  
  for kind, file in walkDir(path):
    if kind == pcDir:
      let dirBranch = root.enterBranch("📁 " & file)
      # Recursive traversal of subdirectories
      for subKind, subFile in walkDir(path / file):
        if subKind == pcFile:
          echo dirBranch.formatBranchLine("📄 " & subFile)
    else:
      echo root.formatBranchLine("📄 " & file)

# Usage
showDirectoryStructure("/src")
```

### 4. Debugging and Profiling
```nim
# Output profiling results
proc showProfilingResults(results: seq[tuple[name: string, time: float, calls: int]]) =
  let root = newBranch("Profiling results")
  
  for result in results:
    let branch = root.enterBranch(result.name)
    echo branch.formatBranchLine("Execution time: " & $result.time & " ms")
    echo branch.formatBranchLine("Number of calls: " & $result.calls)
    echo branch.formatBranchLine("Average time: " & $(result.time / result.calls) & " ms")

# Usage
let profilingData = @[
  ("parseInput", 15.2, 1000),
  ("processData", 45.7, 500),
  ("generateOutput", 8.3, 1000)
]
showProfilingResults(profilingData)
```

### 5. Databases and Queries
```nim
# Output database structure
proc showDatabaseSchema() =
  let root = newBranch("Database structure")
  
  let users = root.enterBranch("Table: users")
  echo users.formatTableHeader("Fields")
  echo users.formatTableLine("id: INTEGER PRIMARY KEY")
  echo users.formatTableLine("name: VARCHAR(255) NOT NULL")
  echo users.formatTableLine("email: VARCHAR(255) UNIQUE")
  echo users.formatTableLine("created_at: TIMESTAMP")
  echo users.formatTableFooter()
  
  let orders = root.enterBranch("Table: orders")
  echo orders.formatTableHeader("Fields")
  echo orders.formatTableLine("id: INTEGER PRIMARY KEY")
  echo orders.formatTableLine("user_id: INTEGER REFERENCES users(id)")
  echo orders.formatTableLine("total: DECIMAL(10,2)")
  echo orders.formatTableLine("status: VARCHAR(50)")
  echo orders.formatTableFooter()

# Usage
showDatabaseSchema()
```

### 6. Code Output with Highlighting
```nim
# Code demonstration with line numbering
proc showCodeExample() =
  let root = newBranch("Code example")
  
  let example = root.enterBranch("Sorting function")
  echo example.formatTableHeader("Source code")
  echo example.formatTableCodeMultiLine(1, """
proc bubbleSort(arr: var seq[int]) =
  let n = arr.len
  for i in 0..<n:
    for j in 0..<n-i-1:
      if arr[j] > arr[j+1]:
        swap(arr[j], arr[j+1])

proc main() =
  var data = @[64, 34, 25, 12, 22, 11, 90]
  echo "Before sorting: ", data
  bubbleSort(data)
  echo "After sorting: ", data
""")
  echo example.formatTableFooter()

# Usage
showCodeExample()
```

### 7. Event Logging
```nim
# Structured event logging
proc showEventLog() =
  let root = newBranch("Event log")
  
  let session = root.enterBranch("User session")
  echo session.formatBranchLine("Session start: 2025-01-15 10:30:00")
  echo session.formatBranchLine("User: admin@example.com")
  
  let actions = session.enterBranch("Actions")
  echo actions.formatBranchLine("System login")
  echo actions.formatBranchLine("Opening document 'report.pdf'")
  echo actions.formatBranchLine("Document editing")
  echo actions.formatBranchLine("Saving changes")
  
  let errors = session.enterBranch("Errors")
  echo errors.formatBranchLine("Save error: insufficient rights")
  echo errors.formatBranchLine("Warning: document locked")

# Usage
showEventLog()
```

### 8. Network Requests and APIs
```nim
# Output network request chain
proc showApiRequestChain() =
  let root = newBranch("API request chain")
  
  let auth = root.enterBranch("Authentication")
  echo auth.formatBranchLine("POST /api/auth/login")
  echo auth.formatBranchLine("Status: 200 OK")
  echo auth.formatBranchLine("Token: eyJhbGciOiJIUzI1NiIs...")
  
  let profile = auth.enterBranch("Getting profile")
  echo profile.formatBranchLine("GET /api/user/profile")
  echo profile.formatBranchLine("Status: 200 OK")
  echo profile.formatBranchLine("User: John Doe")
  
  let data = profile.enterBranch("Loading data")
  echo data.formatBranchLine("GET /api/data/list")
  echo data.formatBranchLine("Status: 200 OK")
  echo data.formatBranchLine("Items: 42")

# Usage
showApiRequestChain()
```

## Advanced Techniques

### Adaptive Output Depending on Terminal Size
```nim
proc createResponsiveTree() =
  let termWidth = terminalWidth()
  let style = if termWidth > 80: unicodeStyle else: indentStyle
  
  let config = newDisplayConfig()
  config.terminalSize = (termWidth, terminalHeight())
  
  let root = newBranch("Adaptive tree", config, style)
  # Adding branches considering terminal size
```

### Combining with Color Theme
```nim
proc createThemedTree() =
  let theme = newColorTheme(
    hintColor = clrBlue,
    errorColor = clrRed,
    successColor = clrGreen,
    warningColor = clrYellow
  )
  
  let config = newDisplayConfig(theme)
  let root = newBranch("Themed tree", config)
  
  let successBranch = root.enterBranch("Successful operation")
  echo successBranch.formatBranchLine(config.colorTheme.successColor & "✓ Operation completed" & ResetColor)
  
  let errorBranch = root.enterBranch("Error")
  echo errorBranch.formatBranchLine(config.colorTheme.errorColor & "✗ An error occurred" & ResetColor)
```

## Integration with Other Modules

### With themeConfig.nim
Uses `DisplayConfig` for configuring colors, icons, and terminal sizes.

### With colors.nim
Uses color constants for additional output formatting.

### With commonTypes.nim
Uses `Status` type for denoting operation states.

## Advantages of Usage

### 1. Visual Clarity
Tree structure with visual branching makes output easily readable and intuitive.

### 2. Flexibility
Two branching styles allow adapting output for different terminals and preferences.

### 3. Multifunctionality
Support for tables, code, multiline text makes the module a universal tool.

### 4. Adaptivity
Automatic terminal width adaptation ensures correct display on different screens.

### 5. Scalability
Easy to create complex hierarchical structures with any nesting level.

## Complex Usage Examples

```nim
# Complex example of treePrinter usage
proc demonstrateTreePrinter() =
  # Create root branch with settings
  let config = newDisplayConfig()
  let root = newBranch("PrettyTerm project analysis", config)
  
  # Module analysis
  let modules = root.enterBranch("Module structure")
  
  let coreModule
