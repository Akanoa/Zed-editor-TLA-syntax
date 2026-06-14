# TLA+ for Zed

TLA+ and PlusCal syntax support for the [Zed](https://zed.dev) editor.

## Features

### TLA+ / PlusCal (`.tla`)

- Syntax highlighting for TLA+ keywords, PlusCal constructs, operators, literals, and comments
- Recognition of both ASCII and Unicode operator spellings (e.g. `\in` and `∈`, `\land` and `∧`), including angle-bracket pairs `⟨ ⟩`
- Unicode symbol input: type a backslash command such as `\in` or `\subseteq`, then accept the completion to insert the Unicode symbol (`∈`, `⊆`). Backslash commands only; see note below
- Code outline and symbol navigation (modules, operators, functions, theorems, assumptions, constants, variables, PlusCal algorithms/processes/procedures/macros)
- Bracket matching and auto-closing (`()`, `[]`, `{}`, `<< >>`, `(* *)`, `""`)
- Indentation support and code folding
- Line comments (`\\*`) and block comments (`(* *)`)

### TLC Configuration (`.cfg`)

- Syntax highlighting for all TLC directives, constant definitions, literals, and comments
- Line comments (`\\*`)

## Unicode symbol input

TLA+ operators may be written with their ASCII names or with the Unicode
mathematical symbols they denote; the two forms are interchangeable. To
insert a symbol, type its backslash command and accept the completion:

1. Type a backslash command, for example `\in`, `\land`, or `\subseteq`.
2. Select the offered entry (it shows the symbol it inserts) and press
   `Tab` (or `Enter`) to replace the command with the symbol (`∈`, `∧`,
   `⊆`).

The angle brackets `⟨ ⟩` (TLA+ `<<` / `>>`) have no backslash spelling
in TLA+, so they are reached through the LaTeX names `\langle` and
`\rangle`.

If the menu does not appear while typing, trigger it manually with
`Ctrl+Space`. Only backslash commands are converted; symbolic operators
with no backslash spelling (such as `=>`, `->`, or `<<`) are left as you
type them, and are still highlighted correctly.

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
