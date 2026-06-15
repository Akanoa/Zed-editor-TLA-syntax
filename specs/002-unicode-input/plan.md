# Implementation Plan: Unicode Symbol Recognition and Input for TLA+

**Branch**: `002-unicode-input` | **Date**: 2026-06-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-unicode-input/spec.md`

## Summary

Confirm that the extension highlights the Unicode spellings of TLA+
operators, close the one known recognition gap (the `〈 〉` angle
brackets), and add Tab-driven input of Unicode symbols. Input is
provided by a bundled snippet file: each backslash command (such as
`\in` or `\land`) is a snippet whose body is the Unicode symbol it
denotes. The feature covers backslash commands only. It adds no Rust
code; the extension stays purely declarative.

## Technical Context

**Language/Version**: Tree-sitter Query Language (S-expressions) + TOML
+ JSON (snippets)
**Primary Dependencies**: tree-sitter-tlaplus (grammar, already pinned
in `extension.toml`)
**Storage**: N/A
**Testing**: Manual validation in Zed dev extension mode
**Target Platform**: Zed editor (cross-platform)
**Project Type**: single
**Performance Goals**: Completion menu appears without perceptible delay
**Constraints**: Pure declarative extension (no Rust, no Cargo.toml)
**Scale/Scope**: 55 snippet entries; one bracket-pair parity fix

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Correctness First | PASS | Bindings derived directly from the grammar's operator rules. Inserted symbols are the same parse nodes as their ASCII spellings, so parsing stays valid. |
| II. Minimal Footprint | PASS | One JSON snippet file plus a manifest line. No Rust, no WASM, no new crates. |
| III. Upstream Alignment | PASS | Uses Zed's documented `snippets` extension field and language-scoped snippet files. Grammar unchanged. |
| IV. Incremental Delivery | PASS | This is delivery phase 5 (Advanced features → snippets) and is shippable on its own, independent of any LSP work. |

No violations. Complexity Tracking section not applicable.

## Project Structure

### Documentation (this feature)

```text
specs/002-unicode-input/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── snippets-file.md
│   └── extension-manifest.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
extension.toml                     # Add a `snippets` array
languages/
└── tlaplus/
    ├── config.toml                # Add 〈 〉 bracket pair; optionally add \ to word_characters
    └── highlights.scm             # Add 〈 〉 to the bracket punctuation group
snippets/
└── tla+.json                      # Backslash-command → Unicode entries (exact name verified in Zed)
```

**Structure Decision**: Keep the pure declarative layout. Introduce a
top-level `snippets/` directory holding one language-scoped JSON file,
referenced from `extension.toml`. The recognition fix touches only the
existing `config.toml` and `highlights.scm`.

## Phases

### Phase 0 — Research (complete)

See research.md. Key findings: recognition is grammar-provided;
snippets are the right input mechanism; the scope file name and the
backslash completion query must be verified in Zed.

### Phase 1 — Design (complete)

See data-model.md (the full binding table and the bracket gap) and the
two contracts (`snippets-file.md`, `extension-manifest.md`).

### Phase 2 — Implementation

Carried out by tasks.md. Order:

1. Close the recognition gap (`config.toml`, `highlights.scm`).
2. Author `snippets/<scoped-name>.json` from the binding table.
3. Reference the snippet file in `extension.toml`.
4. Validate in Zed; if completion does not match on the leading
   backslash, add `\` to `word_characters` and re-validate.

## Risks and Mitigations

| Risk | Mitigation |
|------|-----------|
| The scope file name for "TLA+" is not `tla+.json`. | Run `snippets: configure snippets` in a `.tla` buffer to learn the exact name; mirror it (research.md, Decision 4). |
| Leading backslash prevents completion matching. | Add `\` to `word_characters`; sound because TLA+ identifiers exclude `\` (research.md, Decision 5). |
| Tab is captured by edit predictions instead of accepting the completion. | Document the exact keystroke and the `ctrl-space` fallback in quickstart.md and the README. |
