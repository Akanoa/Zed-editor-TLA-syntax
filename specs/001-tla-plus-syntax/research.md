# Research: TLA+ Syntax Support for Zed

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14

## Decision 1: Extension Architecture

**Decision**: Pure declarative extension (no Rust code).

**Rationale**: Zed supports syntax-only extensions that consist
entirely of configuration files and Tree-sitter query files. Since
this feature scope is limited to syntax highlighting, bracket
matching, code folding, and indentation (no LSP, no custom logic),
no Rust code is needed. This eliminates the WASM compilation step
and keeps the extension as small as possible.

**Alternatives considered**:
- Full Rust extension with `src/lib.rs` — unnecessary overhead for
  syntax-only features; would require `Cargo.toml`, WASM build
  pipeline, and `zed_extension_api` dependency for zero benefit.
- Rust extension with LSP — out of scope per spec assumptions;
  reserved for future incremental delivery.

**Reference**: The Zed TOML extension
(https://github.com/zed-extensions/toml) follows this exact
pattern: `extension.toml` + `languages/` directory only.

## Decision 2: Tree-sitter Grammar Source

**Decision**: Use the `tree-sitter-tlaplus` community grammar from
https://github.com/tlaplus-community/tree-sitter-tlaplus via Git
reference in `extension.toml`.

**Rationale**: This is the only actively maintained Tree-sitter
grammar for TLA+. It is at version 1.5.0, supports both TLA+ and
PlusCal, is published on crates.io, and is used by Neovim and
GitHub for syntax highlighting. It produces comprehensive node
types for all TLA+ constructs.

**Alternatives considered**:
- Writing a custom grammar — massive effort, would duplicate
  existing community work, violates Constitution Principle III
  (Upstream Alignment).
- Forking the grammar — unnecessary; upstream is well-maintained
  and accepts contributions.

**Key details**:
- Repository: `https://github.com/tlaplus-community/tree-sitter-tlaplus`
- Latest release: v1.5.0 (October 2024)
- Requires custom C scanner (`src/scanner.c`) for context-sensitive
  parsing of conjunction lists, proof steps, and PlusCal blocks
- Includes `queries/highlights.scm` and `queries/locals.scm`

## Decision 3: Grammar Reference Mechanism

**Decision**: Reference the grammar via Git URL and commit SHA in
`extension.toml` under `[grammars.tlaplus]`.

**Rationale**: This is the standard Zed convention. Zed downloads
and compiles the grammar automatically during extension
installation. No local grammar files needed.

**Format**:
```toml
[grammars.tlaplus]
repository = "https://github.com/tlaplus-community/tree-sitter-tlaplus"
commit = "<latest-commit-sha>"
```

**Alternatives considered**:
- Local `file://` path — only useful during development, not for
  distribution.
- Bundling pre-compiled WASM — not supported by Zed's extension
  format.

## Decision 4: Highlight Query Strategy

**Decision**: Write custom `highlights.scm` for Zed, using the
upstream grammar's existing queries as a starting reference but
adapting capture names to Zed's conventions.

**Rationale**: The upstream grammar includes `queries/highlights.scm`
but uses Neovim-specific capture names and predicates. Zed uses
standard Tree-sitter capture names (`@keyword`, `@operator`,
`@comment`, `@string`, `@number`, `@punctuation.bracket`,
`@punctuation.delimiter`, `@variable`, `@constant`, `@function`,
`@type`). The Neovim queries are a valuable reference but need
adaptation.

**Key Zed capture names to use**:
- `@keyword` — TLA+ and PlusCal keywords
- `@operator` — infix, prefix, postfix operators
- `@comment` — line and block comments
- `@string` — string literals
- `@string.special` — escape characters
- `@number` — numeric literals
- `@constant` — declared constants
- `@variable` — declared variables
- `@variable.parameter` — operator parameters, quantifier bounds
- `@function` — operator definitions, PlusCal procedures/macros
- `@type` — built-in sets (BOOLEAN, Nat, Int, Real)
- `@punctuation.bracket` — `()`, `[]`, `{}`, `<<`, `>>`
- `@punctuation.delimiter` — `,`, `:`, `.`, `!`
- `@module` — module names in EXTENDS and INSTANCE

## Decision 5: TLC Configuration File Handling

**Decision**: Register `.cfg` files as a separate language
("TLA+ Configuration") with its own simple grammar or use
plain-text with keyword highlighting.

**Rationale**: The `tree-sitter-tlaplus` grammar does not parse
`.cfg` files. TLC configuration files have a simple
keyword-value syntax. Options:

1. Reference a dedicated `tree-sitter-tlc-cfg` grammar (does not
   exist).
2. Write a minimal Tree-sitter grammar for `.cfg` files.
3. Use Zed's plain text with no syntax highlighting for `.cfg`.

**Decision**: Defer `.cfg` support to a follow-up task. The primary
feature delivers `.tla` file support. If `.cfg` highlighting is
desired, a minimal grammar can be written later. This aligns with
Constitution Principle IV (Incremental Delivery).

**Alternatives considered**:
- Bundling `.cfg` in the same grammar — not feasible, different
  syntax entirely.
- Using regex-based highlighting — Zed requires Tree-sitter for
  syntax highlighting.

## Decision 6: Code Folding Mechanism

**Decision**: Use Tree-sitter-based indentation queries
(`indents.scm`) for folding behavior, since Zed does not yet
support `folds.scm`.

**Rationale**: As of early 2025, Zed uses indentation-based folding
and does not process `folds.scm` files (see Zed issue #22703).
Folding is driven by indentation rules and the Tree-sitter parse
tree structure. Writing proper `indents.scm` queries will give
us folding for multi-line constructs.

**Alternatives considered**:
- Writing `folds.scm` anyway — would be ignored by Zed; could be
  added proactively for when support lands.

## Decision 7: PlusCal Handling

**Decision**: PlusCal highlighting is handled natively by the
`tree-sitter-tlaplus` grammar, which produces distinct `pcal_*`
node types. The `highlights.scm` queries will include patterns
for PlusCal nodes.

**Rationale**: The grammar already parses PlusCal blocks embedded
in TLA+ comments and produces separate node types (`pcal_algorithm`,
`pcal_process`, `pcal_if`, `pcal_while`, etc.). No language
injection or separate grammar is needed.

**Key PlusCal node types**: `pcal_algorithm`, `pcal_algorithm_body`,
`pcal_process`, `pcal_procedure`, `pcal_macro`, `pcal_assign`,
`pcal_assert`, `pcal_await`, `pcal_if`, `pcal_while`, `pcal_either`,
`pcal_with`, `pcal_goto`, `pcal_skip`, `pcal_return`, `pcal_print`,
`pcal_macro_call`, `pcal_proc_call`.
