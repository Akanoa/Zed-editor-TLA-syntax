# Feature Specification: Unicode Symbol Recognition and Input for TLA+

**Feature Branch**: `002-unicode-input`
**Created**: 2026-06-14
**Status**: Draft
**Input**: User description: "Support using Unicode identifiers so that
\in and \land and the remaining symbols are recognized. Support
autocompleting the Unicode identifiers with TAB. Backslash commands only."

## Background

TLA+ may be written with ASCII operator names or with the Unicode
mathematical symbols they denote. For example, set membership is
written `\in` in ASCII and `∈` in Unicode; logical conjunction is
written `\land` (or `/\`) in ASCII and `∧` in Unicode. The two forms
are interchangeable in a specification.

The `tree-sitter-tlaplus` grammar already accepts both forms. Each
operator is defined as a choice over its ASCII and Unicode spellings
that produces a single parse node — for instance, the grammar defines
`set_in` as `choice('\\in', '∈')` and `land` as
`choice('/\\', '\\land', '∧')`. The extension's `highlights.scm`
matches these nodes by name, so both spellings are already eligible for
highlighting.

This feature has two goals. First, it confirms that the Unicode forms
are recognized and highlighted, and closes any gaps. Second, it lets a
user type an ASCII *backslash command* (such as `\in` or `\land`) and
press Tab to insert the Unicode symbol. A backslash command is an
operator name that begins with a backslash, in the style of LaTeX.
Symbolic operators that have no backslash spelling (such as `=>`, `->`,
or `<<`) are out of scope for input and are addressed only by
recognition.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Unicode Operators Are Recognized (Priority: P1)

A developer opens a `.tla` file that uses Unicode mathematical symbols
(`∈`, `∧`, `∨`, `¬`, `∀`, `∃`, `≤`, `⊆`, `∪`, `∩`, …) instead of their
ASCII spellings. The symbols receive the same highlighting as their
ASCII equivalents, and the file parses without spurious errors.

**Why this priority**: Recognition is the foundation. A user cannot
benefit from Unicode input if the inserted symbols are not understood
and highlighted.

**Independent Test**: Open the Unicode coverage fixture (see
quickstart.md). Verify that every Unicode operator is highlighted and
that no valid construct is flagged as a parse error.

**Acceptance Scenarios**:

1. **Given** a `.tla` file containing `∈`, `∉`, `∧`, `∨`, `¬`, `∀`,
   `∃`, **When** the user opens it, **Then** each symbol is highlighted
   identically to its ASCII spelling (`\in`, `\notin`, `\land`, `\lor`,
   `\neg`, `\A`, `\E`).
2. **Given** a `.tla` file containing the Unicode angle brackets `⟨`
   and `⟩` (U+27E8/U+27E9) **or** `〈` and `〉` (U+3008/U+3009), **When**
   the user opens it, **Then** both pairs are highlighted as brackets.
3. **Given** a `.tla` file that mixes ASCII and Unicode operators in
   the same expression, **When** the user opens it, **Then** all
   operators are highlighted and the expression parses correctly.

---

### User Story 2 - Backslash Command Converts to Unicode on Tab (Priority: P1)

A developer types a backslash command such as `\land`. A completion
entry offers the Unicode symbol `∧`. The developer presses Tab and the
typed text is replaced by `∧`.

**Why this priority**: This is the primary new capability requested. It
lets users write Unicode TLA+ without memorizing code points or using
an external input method.

**Independent Test**: In a `.tla` file, type `\in`, accept the offered
completion with Tab, and verify that `\in` is replaced by `∈`.

**Acceptance Scenarios**:

1. **Given** a `.tla` file open in Zed, **When** the user types `\land`
   and accepts the completion with Tab, **Then** the buffer contains
   `∧` in place of `\land`.
2. **Given** a `.tla` file open in Zed, **When** the user types `\sub`,
   **Then** the completion menu offers the backslash commands whose
   names begin with `sub` (`\subset`, `\subseteq`), each labelled with
   its Unicode symbol.
3. **Given** an operator with more than one backslash spelling (e.g.
   `\cap` and `\intersect`), **When** the user types either spelling,
   **Then** a completion offering the same Unicode symbol (`∩`) is
   available.
4. **Given** a `.tla` file, **When** the user types ordinary identifier
   text that contains no leading backslash, **Then** no Unicode-symbol
   completion is offered for that text.

---

### Edge Cases

- A backslash command is a prefix of another (`\sub` of `\subset`,
  `\subset` of `\subseteq`). The completion menu MUST offer all
  matching commands and let the user choose.
- Some operators share a backslash spelling with a number format. For
  example `\o` denotes function composition (`∘`) but `\O` introduces an
  octal literal. The snippet set MUST NOT bind `\o`; it uses the
  unambiguous `\circ` instead.
- Backslash is not a word character in the language configuration. The
  completion engine may compute the query without the leading
  backslash. The feature MUST still match the intended command (see
  research.md, Decision 3).
- Inserting a Unicode symbol MUST leave the surrounding parse valid;
  the symbol is the same parse node as its ASCII spelling, so this
  holds by construction.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The extension MUST highlight the Unicode spelling of every
  TLA+ operator that the grammar accepts, matching the highlight of its
  ASCII spelling.
- **FR-002**: The extension MUST recognize both Unicode angle-bracket
  pairs accepted by the grammar: `⟨ ⟩` (U+27E8/U+27E9) and `〈 〉`
  (U+3008/U+3009), highlighting them as brackets.
- **FR-003**: The extension MUST provide completion entries that insert
  a Unicode symbol when the user types the corresponding backslash
  command.
- **FR-004**: The completion entries MUST be accepted with Tab.
- **FR-005**: The completion entries MUST be scoped to the TLA+
  language, and MUST NOT appear in unrelated languages.
- **FR-006**: The feature MUST cover only backslash commands. Symbolic
  operators with no backslash spelling (`=>`, `->`, `|->`, `<-`, `~>`,
  `<<`, `>>`, `[]`, `<>`, `..`, `...`) are out of scope for input.
- **FR-007**: Each completion entry MUST display the Unicode symbol it
  inserts, so the user can confirm the choice before accepting.
- **FR-008**: Where an operator has several backslash spellings, the
  extension MUST offer a completion for each spelling, all inserting
  the same Unicode symbol.
- **FR-009**: The extension MUST NOT bind any backslash command that is
  ambiguous with a number-literal format (`\b`, `\B`, `\o`, `\O`, `\h`,
  `\H`).
- **FR-010**: The feature MUST remain a pure declarative extension — no
  Rust code and no WASM binary are added.

### Key Entities

- **Backslash command**: An ASCII operator name beginning with `\`,
  such as `\in`, `\land`, `\subseteq`. The trigger a user types.
- **Unicode symbol**: The single mathematical character a backslash
  command denotes, such as `∈`, `∧`, `⊆`. The text inserted.
- **Snippet entry**: A Zed snippet with a `prefix` (the backslash
  command) and a `body` (the Unicode symbol), scoped to TLA+.

## Assumptions

- The grammar pinned in `extension.toml` accepts the Unicode spellings
  documented in its `grammar.js`. This feature does not change the
  grammar.
- Zed extensions may ship snippets through the `snippets` field of
  `extension.toml`, scoped by the lowercase language name. (Source:
  Zed extension snippets documentation,
  <https://zed.dev/docs/extensions/snippets>; Zed snippets
  documentation, <https://zed.dev/docs/snippets>.)
- Completion in Zed is confirmed with Tab (or Enter) on the selected
  entry. (Source: Zed completions documentation,
  <https://zed.dev/docs/completions>.)
- The feature provides symbol *input* only. It does not convert an
  existing file between ASCII and Unicode, and it does not convert
  Unicode back to ASCII.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: For every backslash-spelled operator in the grammar, a
  Unicode coverage fixture shows the Unicode form highlighted the same
  as the ASCII form, with no parse errors.
- **SC-002**: A user can type each of at least 40 backslash commands and
  obtain the corresponding Unicode symbol with a single Tab.
- **SC-003**: No Unicode-symbol completion appears when editing a file
  in any language other than TLA+.
- **SC-004**: The extension adds no Rust code, no `Cargo.toml`, and no
  WASM binary; the only additions are one snippet file and the
  `snippets` reference in `extension.toml`, plus any query or config
  edits needed for recognition.
