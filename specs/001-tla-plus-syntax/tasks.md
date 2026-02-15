# Tasks: TLA+ Syntax Support for Zed

**Input**: Design documents from `/specs/001-tla-plus-syntax/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- Pure declarative extension: `extension.toml` at root, `languages/tlaplus/` for config and queries

---

## Phase 1: Setup

**Purpose**: Create the extension manifest and directory structure

- [x] T001 Create extension manifest at extension.toml with id, name, description, version, schema_version, authors, repository, and [grammars.tlaplus] section pointing to https://github.com/tlaplus-community/tree-sitter-tlaplus with pinned commit SHA per contracts/extension-manifest.md
- [x] T002 Create directory structure: languages/tlaplus/

**Checkpoint**: Extension skeleton exists with grammar reference

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Language registration that ALL user stories depend on

- [x] T003 Create language configuration at languages/tlaplus/config.toml with name, grammar, path_suffixes, line_comments, block_comments, autoclose_before, brackets (all 6 pairs including << >> and (* *)), and word_characters per contracts/language-config.md

**Checkpoint**: Zed recognizes .tla files as TLA+ and shows "TLA+" in status bar. Bracket auto-close and comment toggling work. User Stories 1 and 2 file recognition is functional.

---

## Phase 3: User Story 1 - Syntax Highlighting (Priority: P1) + User Story 2 - File Recognition (Priority: P1)

**Goal**: Opening a .tla file shows full syntax highlighting with keywords, operators, comments, literals, and module delimiters visually distinct. File is auto-detected as TLA+.

**Independent Test**: Open any valid .tla file in Zed with the dev extension loaded. Verify keywords, operators, comments, strings, numbers, and module delimiters each receive distinct highlighting. Verify "TLA+" appears in the status bar.

**Note**: US2 (file recognition) is fully delivered by T003 (config.toml). This phase focuses on US1 (highlighting) which also completes the US2 experience.

### Implementation

- [x] T004 [US1] Write TLA+ keyword highlighting rules in languages/tlaplus/highlights.scm — cover all module-level keywords (MODULE, EXTENDS, INSTANCE, WITH, CONSTANT, CONSTANTS, VARIABLE, VARIABLES, ASSUME, ASSUMPTION, AXIOM, THEOREM, LEMMA, PROPOSITION, COROLLARY, PROOF, PROVE, QED, BY, OBVIOUS, OMITTED, DEF, HIDE, ONLY, SUFFICES, PICK, HAVE, TAKE, WITNESS, NEW, RECURSIVE, LOCAL) using @keyword capture per data-model.md Keywords table
- [x] T005 [US1] Write expression keyword highlighting in languages/tlaplus/highlights.scm — cover IF, THEN, ELSE, CASE, OTHER, LET, IN, CHOOSE, LAMBDA, DOMAIN, EXCEPT, UNCHANGED, ENABLED, WF_, SF_, SUBSET, UNION using @keyword capture
- [x] T006 [US1] Write comment highlighting in languages/tlaplus/highlights.scm — match (comment) and (block_comment_text) nodes with @comment capture. Nested block comments are handled by the grammar's parser automatically
- [x] T007 [US1] Write literal highlighting in languages/tlaplus/highlights.scm — match nat_number, real_number, binary_number, hex_number, octal_number with @number; string with @string; escape_char with @string.special; boolean with @constant.builtin
- [x] T008 [US1] Write operator highlighting in languages/tlaplus/highlights.scm — match infix_op_symbol, prefix_op_symbol, postfix_op_symbol with @operator; match ==, |->, [], <>, ~> literal tokens with @operator per data-model.md Operators table
- [x] T009 [US1] Write identifier highlighting in languages/tlaplus/highlights.scm — match constant_declaration>identifier with @constant; variable_declaration>identifier with @variable; operator_definition>name and function_definition>name with @function; operator parameters, choose/lambda/quantifier_bound identifiers with @variable.parameter; extends/instance identifier_ref with @module; module name with @module; general identifier_ref with @variable per data-model.md Identifiers table
- [x] T010 [US1] Write type highlighting in languages/tlaplus/highlights.scm — match boolean_set, nat_number_set, int_number_set, real_number_set, string_set with @type
- [x] T011 [US1] Write punctuation highlighting in languages/tlaplus/highlights.scm — match ( ) [ ] { } << >> with @punctuation.bracket; match , : . ! with @punctuation.delimiter
- [x] T012 [US1] Write proof structure highlighting in languages/tlaplus/highlights.scm — match proof_step_id>level with @tag; theorem>name identifier with @constant
- [x] T013 [US1] Write module delimiter highlighting in languages/tlaplus/highlights.scm — match the ---- MODULE header line and ==== footer with @punctuation.special or appropriate structural capture

**Checkpoint**: All TLA+ constructs are syntax-highlighted. Opening any .tla file shows distinct colors for keywords, operators, comments, strings, numbers, identifiers, and module delimiters.

---

## Phase 4: User Story 3 - Bracket Matching and Auto-Closing (Priority: P2)

**Goal**: All bracket types match and auto-close, including TLA+-specific << >> and (* *) delimiters.

**Independent Test**: Open a .tla file, type each opening bracket type and verify the corresponding close bracket is auto-inserted. Place cursor on brackets and verify matching highlighting.

**Note**: Auto-closing is already configured in T003 (config.toml brackets field). This phase adds Tree-sitter-aware bracket matching via brackets.scm.

### Implementation

- [x] T014 [US3] Create bracket matching queries in languages/tlaplus/brackets.scm — define bracket pairs for ( ), [ ], { }, << >>, and " " using @open/@close captures per data-model.md Bracket Pairs table

**Checkpoint**: Bracket matching and auto-closing work for all 5 bracket pair types with zero false matches.

---

## Phase 5: User Story 4 - Code Folding (Priority: P2)

**Goal**: Multi-line operator definitions, block comments, proof blocks, and module bodies can be collapsed.

**Independent Test**: Open a .tla file with multi-line definitions and block comments. Verify fold indicators appear in the gutter and clicking them collapses the content.

### Implementation

- [x] T015 [US4] Create indentation rules in languages/tlaplus/indents.scm — define @indent.begin for module body, operator_definition, function_definition, block_comment, non_terminal_proof, let_in, if_then_else, case, pcal_algorithm_body, pcal_process, pcal_procedure, pcal_if, pcal_while, pcal_either, pcal_with nodes. Define corresponding @indent.end where applicable. Mark comment and string nodes with @indent.ignore

**Checkpoint**: Fold indicators appear for multi-line constructs. Folding and unfolding works without visual artifacts.

---

## Phase 6: User Story 5 - PlusCal Syntax Highlighting (Priority: P3)

**Goal**: PlusCal keywords, labels, and control structures within algorithm blocks are highlighted distinctly from surrounding TLA+ code.

**Independent Test**: Open a .tla file containing a PlusCal algorithm block. Verify that PlusCal keywords (algorithm, process, begin, end, while, if, either, await, skip, goto, call, return, print, assert) are highlighted and labels are visually distinct.

### Implementation

- [x] T016 [US5] Add PlusCal keyword highlighting rules to languages/tlaplus/highlights.scm — match all PlusCal keywords (algorithm, fair, process, procedure, macro, begin, end, define, variable, variables, if, then, else, elsif, while, do, either, or, with, await, when, skip, goto, call, return, print, assert) with @keyword capture per data-model.md PlusCal Keywords table
- [x] T017 [US5] Add PlusCal structure highlighting to languages/tlaplus/highlights.scm — match pcal_macro_decl>name and pcal_proc_decl>name with @function; match pcal_var_decl>identifier with @variable; match PlusCal labels with @label capture
- [x] T018 [US5] Add PlusCal operator highlighting to languages/tlaplus/highlights.scm — match := (assignment), || and other PlusCal-specific operators with @operator

**Checkpoint**: PlusCal algorithm blocks show distinct keyword highlighting. Labels are visually identifiable.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Code outline, validation against real-world TLA+ files, and final cleanup

- [x] T019 Create code outline queries in languages/tlaplus/outline.scm — define @item/@name/@context captures for module declarations, operator_definition, function_definition, theorem, constant_declaration, variable_declaration, and pcal_algorithm to enable symbol navigation in Zed's outline panel
- [ ] T020 (MANUAL) Validate extension against TLA+ example files from https://github.com/tlaplus/Examples — open at least 3 representative specs (one simple, one with proofs, one with PlusCal) and verify correct highlighting with no parse errors on valid constructs
- [ ] T021 (MANUAL) Run quickstart.md validation checklist in Zed dev extension mode — verify all items pass per specs/001-tla-plus-syntax/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (extension.toml must exist before config.toml)
- **US1+US2 (Phase 3)**: Depends on Phase 2 (config.toml must register grammar before highlights.scm is used)
- **US3 (Phase 4)**: Depends on Phase 2 (bracket auto-close from config.toml). brackets.scm is independent of highlights.scm
- **US4 (Phase 5)**: Depends on Phase 2. indents.scm is independent of highlights.scm and brackets.scm
- **US5 (Phase 6)**: Depends on Phase 3 (PlusCal rules extend the highlights.scm file written in Phase 3)
- **Polish (Phase 7)**: Depends on all user story phases

### User Story Dependencies

- **US1+US2 (P1)**: Depends only on Foundational — no other story dependencies
- **US3 (P2)**: Depends only on Foundational — independent of US1
- **US4 (P2)**: Depends only on Foundational — independent of US1 and US3
- **US5 (P3)**: Depends on US1 (adds rules to the same highlights.scm file)

### Parallel Opportunities

- T004 through T013 all write to the same file (highlights.scm) and MUST be done sequentially within Phase 3, but they are logically independent sections
- T014 (brackets.scm), T015 (indents.scm), and T019 (outline.scm) each write to different files and CAN run in parallel after Phase 2 completes
- Phases 4 and 5 can run in parallel with each other (different files)

---

## Implementation Strategy

### MVP First (User Stories 1 + 2 Only)

1. Complete Phase 1: Setup (T001-T002)
2. Complete Phase 2: Foundational (T003)
3. Complete Phase 3: US1+US2 Highlighting (T004-T013)
4. **STOP and VALIDATE**: Open .tla files, verify highlighting
5. This is a shippable MVP — users get syntax highlighting

### Incremental Delivery

1. Setup + Foundational → Extension skeleton
2. US1+US2 → Syntax highlighting (MVP)
3. US3 → Bracket matching (enhanced editing)
4. US4 → Code folding (navigation)
5. US5 → PlusCal support (full language coverage)
6. Polish → Outline, validation, cleanup

### Parallel Execution After Phase 2

Once Foundational (Phase 2) is done:
- Writer A: Phase 3 (highlights.scm)
- Writer B: Phase 4 (brackets.scm) + Phase 5 (indents.scm) + T019 (outline.scm)

Phase 6 (PlusCal) must wait for Phase 3 to complete since it extends highlights.scm.

---

## Notes

- No tests were explicitly requested in the specification — test tasks are omitted
- US6 (.cfg file support) is deferred per research decision 5 — no tasks generated
- All tasks write to files under the repository root (extension.toml, languages/tlaplus/)
- T004-T013 logically partition highlights.scm into sections but write to the same file
- Commit after each completed phase for clean incremental delivery
