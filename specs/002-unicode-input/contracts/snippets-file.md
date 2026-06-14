# Contract: Snippet File (snippets/tla+.json)

**Branch**: `002-unicode-input` | **Date**: 2026-06-14

## Overview

This document specifies the content and shape of the language-scoped
snippet file that provides Unicode-symbol input. The full
command-to-symbol table is in data-model.md; this contract fixes the
JSON structure and the rules every entry obeys.

## File location and name

- Path: `snippets/<scoped-name>.json`, relative to the repository root.
- `<scoped-name>` is the lowercase TLA+ language name. The expected
  value is `tla+`, giving `snippets/tla+.json`. Confirm in Zed via
  `snippets: configure snippets` from a `.tla` buffer (research.md,
  Decision 4) and use whatever name Zed reports.

## JSON shape

A single JSON object. Each key is a unique snippet name. Each value is
an object with `prefix`, `body`, and `description`.

```json
{
  "set membership": {
    "prefix": "\\in",
    "body": "∈",
    "description": "∈ set membership"
  },
  "logical and": {
    "prefix": "\\land",
    "body": "∧",
    "description": "∧ logical and"
  },
  "subset or equal": {
    "prefix": "\\subseteq",
    "body": "⊆",
    "description": "⊆ subset or equal"
  }
}
```

## Entry rules

- **One entry per backslash command.** Aliases (`\cap` and
  `\intersect`, `\times` and `\X`, etc.) are separate entries that
  share a `body` (FR-008). Zed uses only the first prefix when several
  are given, so each command gets its own entry rather than a prefix
  list. (Source: <https://zed.dev/docs/snippets>, Known Limitations.)
- **Prefix is the literal command**, with the backslash escaped as
  `\\` in JSON. Example: `"prefix": "\\notin"`.
- **Body is the single Unicode symbol.** No tab stops, no `$0`. The
  cursor lands after the symbol on accept.
- **Description begins with the symbol** so the menu shows what will be
  inserted (FR-007). Example: `"≤ less than or equal"`.
- **Names are unique** across the file (JSON object keys).
- **No excluded forms.** The file MUST NOT contain `\b`, `\B`, `\o`,
  `\O`, `\h`, `\H`, the bare `\`, `\AA`, or `\EE` (data-model.md,
  Excluded backslash forms; FR-009).

## Coverage

The file MUST contain one entry for every command in the data-model.md
binding table (55 entries, 49 distinct symbols) plus the two convenience
bindings `\langle` (⟨) and `\rangle` (⟩): 57 entries covering 51
distinct symbols. No symbolic (non-backslash) operator is included
(FR-006); the angle brackets are reached through their LaTeX names
rather than their `<<`/`>>` spellings.

## Validation

- The file MUST be valid JSON (`jq . snippets/tla+.json` exits 0, or an
  equivalent parser check).
- Each `body` MUST be exactly one Unicode scalar value.
- Spot-check that typing a representative prefix offers the entry and
  that Tab inserts the body (quickstart.md).
