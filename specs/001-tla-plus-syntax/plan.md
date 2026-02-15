# Implementation Plan: TLA+ Syntax Support for Zed

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-tla-plus-syntax/spec.md`

## Summary

Build a pure declarative Zed editor extension that provides TLA+
and PlusCal syntax support. The extension uses the community
`tree-sitter-tlaplus` grammar (referenced via Git in
`extension.toml`) and provides syntax highlighting, bracket
matching, code folding, indentation hints, and comment toggling
through Tree-sitter query files. No Rust code or WASM compilation
is required.

## Technical Context

**Language/Version**: Tree-sitter Query Language (S-expressions) + TOML configuration
**Primary Dependencies**: tree-sitter-tlaplus v1.5.0 (grammar, via Git reference)
**Storage**: N/A
**Testing**: Manual validation in Zed dev extension mode
**Target Platform**: Zed editor (cross-platform via WASM grammar compilation)
**Project Type**: single
**Performance Goals**: Syntax highlighting within 1 second of file open
**Constraints**: Pure declarative extension (no Rust code, no Cargo.toml)
**Scale/Scope**: Single language extension covering .tla files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Correctness First | PASS | Using community `tree-sitter-tlaplus` grammar which parses all valid TLA+ constructs. Highlight queries map all node types faithfully. |
| II. Minimal Footprint | PASS | Pure declarative extension — no Rust code, no WASM binary, no external crates. Only configuration and query files. |
| III. Upstream Alignment | PASS | Follows Zed extension conventions: `extension.toml` manifest, `languages/` directory, Tree-sitter queries. Grammar tracks canonical `tree-sitter-tlaplus`. |
| IV. Incremental Delivery | PASS | This feature covers phases 1-3 of the constitution delivery order (grammar, highlighting, folding). LSP deferred to future iteration. |

No violations. Complexity Tracking section not applicable.

## Project Structure

### Documentation (this feature)

```text
specs/001-tla-plus-syntax/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── extension-manifest.md
│   └── language-config.md
└── tasks.md
```

### Source Code (repository root)

```text
extension.toml                     # Extension manifest
languages/
└── tlaplus/
    ├── config.toml                # Language registration
    ├── highlights.scm             # Syntax highlighting queries
    ├── brackets.scm               # Bracket pair definitions
    ├── indents.scm                # Indentation rules
    └── outline.scm                # Code outline/navigation
```

**Structure Decision**: Pure declarative Zed extension. No `src/`,
`Cargo.toml`, or Rust code. The extension consists entirely of
`extension.toml` (manifest with grammar Git reference) and
`languages/tlaplus/` (TOML config + Tree-sitter query files).
This is the simplest possible architecture for a syntax-only
extension, following the pattern of Zed's own TOML extension.
