# Tasks: Unicode Symbol Recognition and Input for TLA+

**Input**: Design documents from `/specs/002-unicode-input/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- Pure declarative extension: `extension.toml` at root,
  `languages/tlaplus/` for config and queries, `snippets/` for the
  snippet file

---

## Phase 1: Recognition (User Story 1, Priority P1)

**Purpose**: Confirm Unicode operators are highlighted and close the
known bracket gap.

**Independent Test**: Open the coverage fixture (quickstart.md). Every
Unicode operator highlights like its ASCII spelling; both `⟨ ⟩` and
`〈 〉` highlight as brackets; no valid construct shows a parse error.

- [x] T001 [P] [US1] Create the coverage fixture file at `specs/002-unicode-input/fixtures/UnicodeCoverage.tla` using the listing in quickstart.md (logic, quantifiers, relations, sets, arithmetic, and both angle-bracket pairs)
- [x] T002 [US1] Add the `〈 〉` (U+3008/U+3009) bracket pair to `languages/tlaplus/config.toml` `brackets`, beside the existing `⟨ ⟩` entry: `{ start = "〈", end = "〉", close = true, newline = false }`
- [x] T003 [US1] Add `"〈"` and `"〉"` to the `@punctuation.bracket` group in `languages/tlaplus/highlights.scm`, beside the existing `"⟨"`/`"⟩"`
- [ ] T004 (MANUAL) [US1] Open `UnicodeCoverage.tla` in Zed dev mode and verify FR-001 and FR-002: every Unicode operator highlights like its ASCII spelling and both angle-bracket pairs highlight as brackets, with no parse errors

**Checkpoint**: Unicode recognition is confirmed and the bracket gap is closed.

---

## Phase 2: Input via snippets (User Story 2, Priority P1)

**Purpose**: Let users type a backslash command and insert the Unicode
symbol with Tab.

**Independent Test**: In a `.tla` file, type `\in`, accept with Tab,
and confirm `∈` replaces `\in`. Confirm the entries do not appear in
other languages.

- [ ] T005 (MANUAL) [US2] Confirm the language-scoped snippet file name: open a `.tla` buffer, run `snippets: configure snippets`, and record the exact file name Zed expects (research.md, Decision 4). NOTE: the file was created as `snippets/tla+.json` on the assumption that the lowercase language name is `tla+`; rename both the file and the `extension.toml` path if Zed reports a different name
- [x] T006 [US2] Create `snippets/<scoped-name>.json` containing one entry per command in data-model.md (55 entries, 49 symbols). Follow contracts/snippets-file.md: `prefix` is the backslash command (escaped `\\`), `body` is the single Unicode symbol, `description` begins with the symbol. Exclude all forms listed under "Excluded backslash forms"
- [x] T007 [US2] Add `snippets = ["./snippets/<scoped-name>.json"]` to `extension.toml` and bump `version` to `0.3.0` per contracts/extension-manifest.md
- [x] T008 [US2] Validate the JSON: run `jq . snippets/<scoped-name>.json` (or equivalent) and confirm it parses; confirm every `body` is exactly one Unicode scalar value
- [ ] T009 (MANUAL) [US2] Reinstall the dev extension. Type `\land` and accept with Tab; confirm `∧` is inserted (FR-003, FR-004). Type `\sub`; confirm `\subset` and `\subseteq` both appear (edge case). Type `\intersect`; confirm `∩` is offered (FR-008)
- [ ] T010 (MANUAL) [US2] Open a non-TLA+ file (e.g. Rust) and confirm the Unicode-symbol completions do NOT appear (FR-005, SC-003)
- [ ] T011 (MANUAL) [US2] If completions do not appear while typing the leading backslash, add `"\\"` to `word_characters` in `languages/tlaplus/config.toml`, reload, and re-test (research.md, Decision 5)

**Checkpoint**: Tab input works for all backslash commands and is scoped to TLA+.

---

## Phase 3: Polish & Documentation

**Purpose**: Document the feature and run the full validation pass.

- [x] T012 [P] Update `README.md` Features section: note Unicode operator highlighting and the backslash-command-to-Unicode Tab input, including the exact accept keystroke and the `ctrl-space` fallback
- [ ] T013 (MANUAL) Run the full quickstart.md validation checklist in Zed dev extension mode and confirm all items pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Recognition)**: Independent of Phase 2. T002 and T003 touch
  different files and may run in parallel; T004 depends on both
- **Phase 2 (Input)**: T006 depends on T005 (file name). T007 depends on
  T006. T008 depends on T006. T009/T010 depend on T007. T011 is a
  contingency after T009
- **Phase 3 (Polish)**: Depends on Phases 1 and 2

### Parallel Opportunities

- T001 (fixture) is independent and can be written first
- T002 (config.toml) and T003 (highlights.scm) write different files —
  parallel
- T012 (README) is independent of code tasks once behavior is known

---

## Implementation Strategy

### MVP (User Story 2 only)

The requested capability is Tab input. If recognition is already
correct in practice, Phase 2 alone delivers user value:

1. T005 → T006 → T007 → T008 → T009 → T010
2. STOP and VALIDATE: backslash commands convert to Unicode on Tab

### Full delivery

1. Phase 1 → recognition confirmed, bracket gap closed
2. Phase 2 → Tab input (MVP)
3. Phase 3 → docs and full validation

---

## Notes

- No automated tests are added; validation is manual in Zed, matching
  feature 001's approach
- This feature corresponds to Constitution delivery phase 5 (Advanced
  features → snippets) and ships independently of any LSP work
- The two MANUAL "confirm" tasks (T005, T011) verify Zed environment
  facts; treat their outcomes as inputs to T006 and T002, not as spec
  changes
- Commit after each completed phase for clean incremental delivery
