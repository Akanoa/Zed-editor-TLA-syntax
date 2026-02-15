# Feature Specification: TLA+ Syntax Support for Zed

**Feature Branch**: `001-tla-plus-syntax`
**Created**: 2025-02-14
**Status**: Draft
**Input**: User description: "Create a Zed editor extension which handle the TLA+ syntax"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Syntax Highlighting for TLA+ Files (Priority: P1)

A developer opens a `.tla` file in Zed and immediately sees
syntax-highlighted code. Keywords like `MODULE`, `VARIABLES`,
`EXTENDS`, and `THEOREM` are visually distinct from operators,
identifiers, comments, and literals. The developer can quickly
scan the structure of a specification because different language
elements are color-coded according to the active editor theme.

**Why this priority**: Syntax highlighting is the foundational
feature of any language extension. Without it, TLA+ files appear
as plain text and the extension provides no value.

**Independent Test**: Open any valid `.tla` file in Zed with
the extension installed. Verify that keywords, operators, comments,
strings, numbers, and module delimiters each receive distinct
highlighting.

**Acceptance Scenarios**:

1. **Given** a `.tla` file containing a TLA+ module, **When** the
   user opens it in Zed, **Then** TLA+ keywords (`MODULE`,
   `VARIABLES`, `CONSTANTS`, `EXTENDS`, `THEOREM`, `ASSUME`,
   `LET`, `IN`, `IF`, `THEN`, `ELSE`, `CASE`, `OTHER`, `CHOOSE`,
   `LAMBDA`, `DOMAIN`, `EXCEPT`, `UNCHANGED`, `ENABLED`,
   `RECURSIVE`, `LOCAL`, `INSTANCE`, `WITH`) are highlighted as
   keywords.

2. **Given** a `.tla` file with comments, **When** the user opens
   it, **Then** single-line comments (`\*`) and block comments
   (`(* ... *)`) including nested block comments are highlighted
   as comments.

3. **Given** a `.tla` file with operators, **When** the user opens
   it, **Then** TLA+ operators (`/\`, `\/`, `~`, `=>`, `<=>`,
   `\in`, `\notin`, `\cup`, `\cap`, `\subseteq`, `\A`, `\E`,
   `[]`, `<>`, `~>`, `'`, `==`, `|->`) are highlighted as
   operators.

4. **Given** a `.tla` file with string and number literals,
   **When** the user opens it, **Then** double-quoted strings and
   integer literals are highlighted as literals.

5. **Given** a `.tla` file with module delimiters, **When** the
   user opens it, **Then** the `---- MODULE Name ----` header and
   `====` footer are highlighted as structural markers.

---

### User Story 2 - TLA+ File Recognition and Registration (Priority: P1)

A developer creates or opens a file with a `.tla` extension and
Zed automatically recognizes it as a TLA+ file, applies the correct
language mode, and uses the TLA+ grammar for parsing. The developer
sees "TLA+" in the editor status bar as the detected language.

**Why this priority**: File type recognition is a prerequisite for
all other features. Without it, no TLA+ specific behavior activates.

**Independent Test**: Create a new file with `.tla` extension in
Zed. Verify the language indicator shows "TLA+" and syntax
highlighting activates without manual language selection.

**Acceptance Scenarios**:

1. **Given** Zed with the TLA+ extension installed, **When** the
   user opens a file named `Spec.tla`, **Then** Zed recognizes it
   as TLA+ and displays "TLA+" as the file language.

2. **Given** Zed with the TLA+ extension installed, **When** the
   user creates a new file and saves it as `MySpec.tla`, **Then**
   Zed applies TLA+ syntax highlighting automatically.

---

### User Story 3 - Bracket Matching and Auto-Closing (Priority: P2)

A developer writes TLA+ code and the editor matches bracket pairs,
including TLA+-specific delimiters like `<< >>` for tuples. When
the developer types an opening bracket, the corresponding closing
bracket is inserted automatically.

**Why this priority**: Bracket matching significantly improves the
editing experience for TLA+ where nested expressions with multiple
bracket types are common.

**Independent Test**: Open a `.tla` file, type various opening
brackets and verify matching/auto-close behavior for all supported
bracket types.

**Acceptance Scenarios**:

1. **Given** a `.tla` file open in the editor, **When** the user
   places the cursor on an opening parenthesis `(`, bracket `[`,
   or brace `{`, **Then** the matching closing delimiter is
   highlighted.

2. **Given** a `.tla` file open in the editor, **When** the user
   types `<<`, **Then** the editor auto-inserts `>>` and places
   the cursor between them.

3. **Given** a `.tla` file open in the editor, **When** the user
   types `(*`, **Then** the editor auto-inserts `*)` for block
   comments.

---

### User Story 4 - Code Folding (Priority: P2)

A developer working with a large TLA+ specification can collapse
sections of the file to focus on specific parts. Module bodies,
block comments, multi-line operator definitions, and proof blocks
can be folded.

**Why this priority**: Code folding is important for navigating
large specifications but not strictly required for basic editing.

**Independent Test**: Open a `.tla` file with multiple operator
definitions and block comments. Verify that fold indicators appear
and clicking them collapses the corresponding sections.

**Acceptance Scenarios**:

1. **Given** a `.tla` file with a multi-line operator definition,
   **When** the user clicks the fold indicator, **Then** the
   definition body collapses to a single line showing the
   operator name.

2. **Given** a `.tla` file with a block comment `(* ... *)`,
   **When** the user folds it, **Then** only the first line of
   the comment remains visible.

3. **Given** a `.tla` file with nested proof structures, **When**
   the user folds a proof block, **Then** the block collapses
   to show only the theorem statement.

---

### User Story 5 - PlusCal Syntax Highlighting (Priority: P3)

A developer writes PlusCal algorithms embedded within TLA+ block
comments. The extension recognizes PlusCal syntax within
`(* --algorithm ... *)` blocks and highlights PlusCal keywords,
control structures, and labels distinctly from surrounding TLA+
code and comments.

**Why this priority**: PlusCal is commonly used alongside TLA+ but
is a secondary syntax embedded in comments. Core TLA+ support is
more important.

**Independent Test**: Open a `.tla` file containing a PlusCal
algorithm block. Verify that PlusCal keywords (`algorithm`,
`process`, `begin`, `end`, `while`, `if`, `either`, `await`,
`skip`, `goto`, `call`, `return`, `print`, `assert`) receive
distinct highlighting within the algorithm block.

**Acceptance Scenarios**:

1. **Given** a `.tla` file containing `(* --algorithm Name ... *)`,
   **When** the user opens it, **Then** PlusCal keywords within
   the algorithm block are highlighted distinctly from TLA+
   comments and TLA+ keywords.

2. **Given** a `.tla` file with PlusCal labels (e.g., `lbl:`),
   **When** the user opens it, **Then** labels are highlighted
   as label identifiers.

---

### User Story 6 - TLC Configuration File Support (Priority: P3)

A developer opens a `.cfg` file associated with a TLA+
specification. The extension recognizes TLC configuration syntax
and highlights configuration directives like `SPECIFICATION`,
`INVARIANT`, `PROPERTY`, `CONSTANT`, and `CHECK_DEADLOCK`.

**Why this priority**: Configuration files are secondary artifacts
used for model checking. Core `.tla` support is the primary need.

**Independent Test**: Open a `.cfg` file with TLC configuration
directives and verify that keywords and values are highlighted.

**Acceptance Scenarios**:

1. **Given** a `.cfg` file with TLC directives, **When** the user
   opens it, **Then** directives (`SPECIFICATION`, `INVARIANT`,
   `PROPERTY`, `CONSTANT`, `CONSTANTS`, `CHECK_DEADLOCK`,
   `SYMMETRY`, `CONSTRAINT`) are highlighted as keywords.

2. **Given** Zed with the extension installed, **When** the user
   opens a file named `Spec.cfg`, **Then** Zed recognizes it as
   a TLA+ configuration file.

---

### Edge Cases

- What happens when a `.tla` file contains syntax errors (e.g.,
  unclosed block comments, missing `====` footer)? The extension
  MUST degrade gracefully, highlighting valid portions and marking
  error regions without crashing.
- How does the extension handle very large TLA+ files (thousands
  of lines)? Parsing and highlighting MUST remain responsive.
- What happens with nested block comments `(* outer (* inner *) *)`?
  The grammar MUST correctly handle arbitrary nesting depth.
- How does the extension handle files that mix TLA+ and PlusCal?
  Each region MUST be highlighted according to its own syntax rules.
- What happens when a `.cfg` file has no corresponding `.tla` file?
  The extension MUST still provide highlighting independently.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The extension MUST register `.tla` files as TLA+
  language files in Zed.
- **FR-002**: The extension MUST provide a Tree-sitter grammar
  capable of parsing TLA+ module structure, declarations,
  definitions, expressions, and proofs.
- **FR-003**: The extension MUST provide syntax highlighting
  queries that distinguish keywords, operators, identifiers,
  comments (line and block), string literals, number literals,
  and module delimiters.
- **FR-004**: The extension MUST support bracket matching for
  `()`, `[]`, `{}`, `<< >>`, and `(* *)`.
- **FR-005**: The extension MUST support code folding for module
  bodies, multi-line definitions, block comments, and proof
  blocks.
- **FR-006**: The extension MUST handle nested block comments
  correctly at arbitrary depth.
- **FR-007**: The extension MUST recognize and highlight PlusCal
  algorithm blocks embedded in TLA+ comments.
- **FR-008**: The extension MUST register `.cfg` files as TLA+
  configuration files and provide basic highlighting for TLC
  directives.
- **FR-009**: The extension MUST provide indentation hints for
  TLA+ constructs (operator definitions, proof steps, nested
  expressions).
- **FR-010**: The extension MUST provide line and block comment
  toggling commands that use `\*` for line comments and
  `(* *)` for block comments.

### Key Entities

- **TLA+ Module**: The top-level unit of a specification, delimited
  by `---- MODULE Name ----` and `====`. Contains declarations,
  definitions, theorems, and proofs.
- **Operator Definition**: A named definition using `==` (e.g.,
  `Init == x = 0`). Can be multi-line.
- **PlusCal Algorithm Block**: An algorithm specification embedded
  within a TLA+ block comment, starting with `--algorithm` or
  `--fair algorithm`.
- **TLC Configuration**: A `.cfg` file containing directives for
  the TLC model checker.

## Assumptions

- The extension uses the existing `tree-sitter-tlaplus` community
  grammar rather than building a grammar from scratch. This grammar
  supports both TLA+ and PlusCal and is the de facto standard for
  TLA+ tooling.
- The extension targets Zed's current stable extension API. No
  unstable or preview APIs are assumed.
- Language server integration (diagnostics, go-to-definition, etc.)
  is out of scope for this feature. It may be added in a future
  iteration per the constitution's Incremental Delivery principle.
- The extension does not bundle or invoke TLC, TLAPS, or any
  external TLA+ tooling. It provides syntax-level support only.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can open any valid `.tla` file and see syntax
  highlighting within 1 second of file open, with no manual
  language selection required.
- **SC-002**: All TLA+ keywords (at least 30 distinct keywords)
  are visually distinguishable from operators, identifiers, and
  literals.
- **SC-003**: The extension correctly highlights 100% of TLA+
  files from the official TLA+ examples repository without
  parsing errors on valid constructs.
- **SC-004**: Bracket matching works for all 5 bracket pair types
  (`()`, `[]`, `{}`, `<< >>`, `(* *)`) with zero false matches.
- **SC-005**: Code folding is available for module bodies, operator
  definitions, block comments, and proof blocks with no visual
  artifacts when folding or unfolding.
- **SC-006**: The extension adds less than 1 second to Zed startup
  time and does not degrade editor responsiveness during editing.
