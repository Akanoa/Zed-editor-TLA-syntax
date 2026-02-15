# Contract: Language Configuration (config.toml)

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14

## Overview

This document specifies the exact content of
`languages/tlaplus/config.toml`, which registers the TLA+ language
in Zed and configures editing behaviors.

## languages/tlaplus/config.toml

```toml
name = "TLA+"
grammar = "tlaplus"
path_suffixes = ["tla"]
line_comments = ["\\* "]
block_comments = ["(* ", " *)"]
autoclose_before = ";:.,=}])|>"
brackets = [
  { start = "(", end = ")", close = true, newline = true },
  { start = "[", end = "]", close = true, newline = true },
  { start = "{", end = "}", close = true, newline = true },
  { start = "<<", end = ">>", close = true, newline = false },
  { start = "(*", end = "*)", close = true, newline = true },
  { start = "\"", end = "\"", close = true, newline = false, not_in = ["string", "comment"] },
]
word_characters = ["_", "'"]
```

## Fields

| Field | Value | Rationale |
|-------|-------|-----------|
| `name` | `TLA+` | Displayed in Zed status bar |
| `grammar` | `tlaplus` | Matches `[grammars.tlaplus]` in extension.toml |
| `path_suffixes` | `["tla"]` | `.tla` file extension |
| `line_comments` | `["\\* "]` | TLA+ line comment prefix |
| `block_comments` | `["(* ", " *)"]` | TLA+ block comment delimiters |
| `autoclose_before` | (see above) | Characters triggering auto-close |
| `brackets` | (see above) | 6 bracket pair types |
| `word_characters` | `["_", "'"]` | Underscore and prime in identifiers |

## Constraints

- The `grammar` field MUST exactly match the grammar name registered
  in `extension.toml`.
- The `name` field MUST be `TLA+` (with plus sign) for proper
  display.
- `word_characters` includes `'` because TLA+ uses prime (`'`) as
  a postfix operator on variable names (e.g., `x'`), and `_` is
  used in identifiers and fairness operators (`WF_`, `SF_`).
- `.cfg` files are NOT registered here — deferred per research
  decision 5.
