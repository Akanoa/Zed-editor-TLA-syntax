# Quickstart: Unicode Symbol Recognition and Input for TLA+

**Branch**: `002-unicode-input` | **Date**: 2026-06-14

## Prerequisites

- Zed editor installed (latest stable)
- The TLA+ extension loaded as a dev extension (see
  `specs/001-tla-plus-syntax/quickstart.md`)

## What this feature adds

1. Confirmed highlighting of Unicode operator spellings (`∈`, `∧`, …).
2. Tab input: type a backslash command, accept the completion, get the
   Unicode symbol.

## Confirm the scope file name (do this first)

The snippet file must be named for the lowercase language name.

1. Open any `.tla` file so the buffer language is TLA+.
2. Run `snippets: configure snippets` from the command palette.
3. Note the file name Zed creates or opens (expected: `tla+.json`).
4. Name the extension's file `snippets/<that-name>` and set the same
   path in `extension.toml`'s `snippets` array.

## Project structure after this feature

```text
zed-tla-plus/
├── extension.toml              # now has: snippets = ["./snippets/tla+.json"]
├── languages/
│   └── tlaplus/
│       ├── config.toml         # 〈 〉 added to brackets
│       └── highlights.scm      # 〈 〉 added to bracket group
└── snippets/
    └── tla+.json               # backslash-command → Unicode symbol
```

## Validation Checklist

### Recognition

- [ ] Open the coverage fixture below — every Unicode operator is
      highlighted like its ASCII spelling
- [ ] No valid construct is flagged as a parse error
- [ ] Both `⟨ ⟩` and `〈 〉` highlight as brackets

### Input (Tab)

- [ ] Type `\in` — a completion offering `∈` appears
- [ ] Press Tab — `\in` is replaced by `∈`
- [ ] Type `\sub` — completions for `\subset` and `\subseteq` appear
- [ ] Type `\intersect` — a completion offering `∩` appears
- [ ] Type a plain identifier (no backslash) — no symbol completion
      appears

### Scope

- [ ] Open a file in another language (e.g. Rust) — the Unicode-symbol
      completions do NOT appear

### If completion does not trigger on `\`

- [ ] Trigger completions manually with `ctrl-space` after typing the
      command — entry appears
- [ ] If manual triggering works but typing does not, add `\` to
      `word_characters` in `config.toml`, reload, and re-test
      (research.md, Decision 5)

## Coverage fixture

Open this as a `.tla` file and compare highlighting with the ASCII
spellings in comments.

```tla
---- MODULE UnicodeCoverage ----
EXTENDS Naturals

\* logic:        ∧ ∨ ¬ ⇒ ≡
\* quantifiers:  ∀ ∃
\* relations:    ≤ ≥ ≈ ≅ ≺ ≻ ⪯ ⪰ ∼ ≃ ≪ ≫
\* sets:         ∈ ∉ ⊂ ⊃ ⊆ ⊇ ∩ ∪ ⊓ ⊔ ⊎
\* arithmetic:   × ÷ ⋅ ∘ ⋆ ⊕ ⊖ ⊗ ⊙ ⊘
\* brackets:     ⟨ 1, 2 ⟩   and   〈 3, 4 〉

Pos       == { x ∈ Nat : x > 0 }
AndOr(a,b) == a ∧ b ∨ ¬ a
AllPos    == ∀ n ∈ Pos : n ≥ 1
Tuple     == ⟨ 1, 2, 3 ⟩
====
```

## Rebuilding after changes

After editing `extension.toml`, the snippet JSON, `config.toml`, or
`highlights.scm`:

1. Reload the Zed window (command palette → "workspace: reload"), or
2. Reinstall the dev extension if the manifest changed.

No compilation step is needed — the extension is purely declarative.
