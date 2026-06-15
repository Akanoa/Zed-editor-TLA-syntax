# Contract: Extension Manifest Change (extension.toml)

**Branch**: `002-unicode-input` | **Date**: 2026-06-14

## Overview

This document specifies the change to `extension.toml` that registers
the Unicode-symbol snippet file. The manifest already exists from
feature 001; this feature adds one field and bumps the version.

## Change

Add a top-level `snippets` array listing the snippet file, with a path
relative to `extension.toml`. Bump `version` for the new feature.

```toml
id = "tla-plus"
name = "TLA+"
description = "TLA+ and PlusCal syntax support for Zed."
version = "0.3.0"
schema_version = 1
authors = ["Noa <dev@guern.eu>"]
repository = "https://github.com/Akanoa/Zed-editor-TLA-syntax"

snippets = ["./snippets/tla+.json"]

[grammars.tlaplus]
repository = "https://github.com/tlaplus-community/tree-sitter-tlaplus"
rev = "8d749f9a598b47b7110c7340006c8eb8a9552566"

[grammars.tlaplus_cfg]
repository = "https://github.com/Akanoa/tree-sitter-tlaplus-cfg"
rev = "8d10f7d4a9138d0f75ca490f760dee1ec302c44c"
```

## Fields

| Field | Value | Rationale |
|-------|-------|-----------|
| `snippets` | `["./snippets/tla+.json"]` | One language-scoped snippet file. Path is relative to `extension.toml`. |
| `version` | `0.3.0` | Minor bump: new user-facing feature, no breaking change. |

## Constraints

- The `snippets` array MUST list paths relative to `extension.toml`.
  (Source: <https://zed.dev/docs/extensions/snippets>.)
- The file's *basename* determines the language scope; it MUST be the
  lowercase language name. The language is `TLA+`, so the expected
  basename is `tla+.json`. This MUST be confirmed in Zed (see
  research.md, Decision 4) before publishing; if Zed expects a
  different name, both the file and this path MUST be updated to match.
- The grammar sections MUST remain unchanged. This feature does not
  touch the grammar.
- No `[language_servers]` section is added. No `Cargo.toml` or `src/`
  is added.
