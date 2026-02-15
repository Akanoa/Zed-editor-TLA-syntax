# Contract: Extension Manifest (extension.toml)

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14

## Overview

This document specifies the exact content of `extension.toml`, the
Zed extension manifest file. This is the primary "contract" for a
declarative Zed extension — it declares the extension identity and
its grammar dependencies.

## extension.toml

```toml
id = "tla-plus"
name = "TLA+"
description = "TLA+ and PlusCal syntax support for Zed."
version = "0.1.0"
schema_version = 1
authors = ["<author-name> <author-email>"]
repository = "https://github.com/<owner>/zed-tla-plus"

[grammars.tlaplus]
repository = "https://github.com/tlaplus-community/tree-sitter-tlaplus"
commit = "<pin-to-latest-commit-on-main>"
```

## Fields

| Field | Value | Rationale |
|-------|-------|-----------|
| `id` | `tla-plus` | Kebab-case identifier for the extension |
| `name` | `TLA+` | Human-readable name shown in Zed UI |
| `description` | (see above) | Mentions both TLA+ and PlusCal |
| `version` | `0.1.0` | Initial pre-release version |
| `schema_version` | `1` | Current Zed extension schema |
| `grammars.tlaplus` | Git reference | Points to tree-sitter-tlaplus |

## Constraints

- The grammar name `tlaplus` MUST match the `grammar` field in
  `languages/tlaplus/config.toml`.
- The commit SHA MUST be pinned to a specific commit (not a branch
  or tag) for reproducible builds.
- No `[language_servers]` section — LSP is out of scope.
- No `Cargo.toml` or `src/` — pure declarative extension.
