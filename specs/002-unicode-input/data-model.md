# Data Model: Unicode Symbol Recognition and Input for TLA+

**Branch**: `002-unicode-input` | **Date**: 2026-06-14

## Overview

This feature has no persistent data model. Its "data" is a fixed table
that maps each backslash command to the Unicode symbol it denotes. The
table is derived directly from the operator rules in the grammar's
`grammar.js`. Each row becomes one snippet entry: `prefix` is the
backslash command, `body` is the Unicode symbol.

A *backslash command* is an operator name that begins with `\`. A
*Unicode symbol* is the single character the command denotes. Several
commands may map to the same symbol; each command is still its own
snippet entry (FR-008).

## Entity: Backslash Command → Unicode Symbol Mapping

### Quantifiers and logic

| Command | Symbol | Code point | Grammar rule |
|---------|--------|-----------|--------------|
| `\A` | ∀ | U+2200 | `forall` |
| `\forall` | ∀ | U+2200 | `forall` |
| `\E` | ∃ | U+2203 | `exists` |
| `\exists` | ∃ | U+2203 | `exists` |
| `\neg` | ¬ | U+00AC | `lnot` |
| `\lnot` | ¬ | U+00AC | `lnot` |
| `\land` | ∧ | U+2227 | `land` |
| `\lor` | ∨ | U+2228 | `lor` |
| `\equiv` | ≡ | U+2261 | `equiv` |

### Relations and comparisons

| Command | Symbol | Code point | Grammar rule |
|---------|--------|-----------|--------------|
| `\leq` | ≤ | U+2264 | `leq` |
| `\geq` | ≥ | U+2265 | `geq` |
| `\approx` | ≈ | U+2248 | `approx` |
| `\asymp` | ≍ | U+224D | `asymp` |
| `\cong` | ≅ | U+2245 | `cong` |
| `\doteq` | ≐ | U+2250 | `doteq` |
| `\gg` | ≫ | U+226B | `gg` |
| `\ll` | ≪ | U+226A | `ll` |
| `\prec` | ≺ | U+227A | `prec` |
| `\succ` | ≻ | U+227B | `succ` |
| `\preceq` | ⪯ | U+2AAF | `preceq` |
| `\succeq` | ⪰ | U+2AB0 | `succeq` |
| `\propto` | ∝ | U+221D | `propto` |
| `\sim` | ∼ | U+223C | `sim` |
| `\simeq` | ≃ | U+2243 | `simeq` |

### Sets and membership

| Command | Symbol | Code point | Grammar rule |
|---------|--------|-----------|--------------|
| `\in` | ∈ | U+2208 | `in` / `set_in` |
| `\notin` | ∉ | U+2209 | `notin` |
| `\subset` | ⊂ | U+2282 | `subset` |
| `\supset` | ⊃ | U+2283 | `supset` |
| `\subseteq` | ⊆ | U+2286 | `subseteq` |
| `\supseteq` | ⊇ | U+2287 | `supseteq` |
| `\sqsubset` | ⊏ | U+228F | `sqsubset` |
| `\sqsupset` | ⊐ | U+2290 | `sqsupset` |
| `\sqsubseteq` | ⊑ | U+2291 | `sqsubseteq` |
| `\sqsupseteq` | ⊒ | U+2292 | `sqsupseteq` |
| `\cap` | ∩ | U+2229 | `cap` |
| `\intersect` | ∩ | U+2229 | `cap` |
| `\cup` | ∪ | U+222A | `cup` |
| `\union` | ∪ | U+222A | `cup` |
| `\sqcap` | ⊓ | U+2293 | `sqcap` |
| `\sqcup` | ⊔ | U+2294 | `sqcup` |
| `\uplus` | ⊎ | U+228E | `uplus` |

### Arithmetic and ring operators

| Command | Symbol | Code point | Grammar rule |
|---------|--------|-----------|--------------|
| `\times` | × | U+00D7 | `times` |
| `\X` | × | U+00D7 | `times` |
| `\div` | ÷ | U+00F7 | `div` |
| `\cdot` | ⋅ | U+22C5 | `cdot` |
| `\circ` | ∘ | U+2218 | `circ` |
| `\star` | ⋆ | U+22C6 | `star` |
| `\bullet` | ● | U+25CF | `bullet` |
| `\bigcirc` | ◯ | U+25EF | `bigcirc` |
| `\oplus` | ⊕ | U+2295 | `oplus` |
| `\ominus` | ⊖ | U+2296 | `ominus` |
| `\otimes` | ⊗ | U+2297 | `otimes` |
| `\odot` | ⊙ | U+2299 | `odot` |
| `\oslash` | ⊘ | U+2298 | `oslash` |
| `\wr` | ≀ | U+2240 | `wr` |

This table holds 55 commands mapping to 49 distinct symbols. The six
aliases — commands that share a symbol with another command — are
`\forall` (∀), `\exists` (∃), `\lnot` (¬), `\intersect` (∩),
`\union` (∪), and `\X` (×).

## Entity: Convenience bindings (not grammar operators)

TLA+ has no backslash spelling for the angle brackets; their ASCII forms
are `<<` and `>>` (the `langle_bracket`/`rangle_bracket` nodes). To let
users insert the Unicode angle brackets in the same backslash-trigger
style, two convenience entries use the standard LaTeX names. These are
triggers only; the inserted characters `⟨`/`⟩` are accepted by the
grammar.

| Command | Symbol | Code point | Note |
|---------|--------|-----------|------|
| `\langle` | ⟨ | U+27E8 | Left angle bracket (sequence/tuple) |
| `\rangle` | ⟩ | U+27E9 | Right angle bracket (sequence/tuple) |

## Entity: Excluded backslash forms

These backslash forms exist in the grammar but are deliberately not
bound (FR-009 and Decision 6).

| Form | Reason for exclusion |
|------|----------------------|
| `\b`, `\B` | Binary number format, not an operator |
| `\o`, `\O` | `\O` is octal format; `\o` is ambiguous with it. Use `\circ` for ∘ |
| `\h`, `\H` | Hexadecimal number format, not an operator |
| `\` | Set difference (bare backslash); has no Unicode form |
| `\AA`, `\EE` | Temporal quantifiers; the grammar gives them no Unicode form |

## Entity: Snippet entry shape

Each row above maps to one JSON entry in the scoped snippet file. The
entry name is unique; the prefix is the backslash command; the body is
the Unicode symbol; the description names the operator.

```json
"set membership": {
  "prefix": "\\in",
  "body": "∈",
  "description": "∈ set membership"
}
```

Notes on the JSON form:
- A backslash in a prefix is written `\\` in JSON.
- The body is a single Unicode character and contains no tab stops, so
  the cursor lands after the symbol once accepted.
- Bodies that contain a literal `$` would need escaping; none of the
  symbols in this feature contain `$`.

## Entity: Recognition gap to close

| Pair | Code points | Action |
|------|-------------|--------|
| `〈` `〉` | U+3008 / U+3009 | Add beside the existing `⟨` `⟩` (U+27E8 / U+27E9) in `config.toml` `brackets`, the `@punctuation.bracket` group in `highlights.scm`, the `@open`/`@close` pairs in `brackets.scm`, and the `@outdent` group in `indents.scm`. The grammar's `langle_bracket`/`rangle_bracket` nodes already cover all three spellings; the literal entries add parity for auto-close, matching, and outdent |
