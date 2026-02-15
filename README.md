# TLA+ for Zed

TLA+ and PlusCal syntax support for the [Zed](https://zed.dev) editor.

## Features

### TLA+ / PlusCal (`.tla`)

- Syntax highlighting for TLA+ keywords, PlusCal constructs, operators, literals, and comments
- Code outline and symbol navigation (modules, operators, functions, theorems, assumptions, constants, variables, PlusCal algorithms/processes/procedures/macros)
- Bracket matching and auto-closing (`()`, `[]`, `{}`, `<< >>`, `(* *)`, `""`)
- Indentation support and code folding
- Line comments (`\\*`) and block comments (`(* *)`)

### TLC Configuration (`.cfg`)

- Syntax highlighting for all TLC directives, constant definitions, literals, and comments
- Line comments (`\\*`)

## Installation

1. Open Zed
2. Open the extensions panel (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for "TLA+"
4. Click **Install**

## Grammars

This extension uses two tree-sitter grammars:

- [tree-sitter-tlaplus](https://github.com/tlaplus-community/tree-sitter-tlaplus) — TLA+ and PlusCal
- [tree-sitter-tlaplus-cfg](https://github.com/Akanoa/tree-sitter-tlaplus-cfg) — TLC configuration files

## License

BSD 3-Clause
