<!--
Sync Impact Report
- Version change: N/A → 1.0.0 (initial ratification)
- Added principles:
  - I. Correctness First
  - II. Minimal Footprint
  - III. Upstream Alignment
  - IV. Incremental Delivery
- Added sections:
  - Technology Constraints
  - Development Workflow
  - Governance
- Removed sections: None
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ reviewed (no changes needed;
    Constitution Check section is generic and will be filled per-feature)
  - .specify/templates/spec-template.md — ✅ reviewed (no changes needed;
    structure is principle-agnostic)
  - .specify/templates/tasks-template.md — ✅ reviewed (no changes needed;
    phase structure accommodates incremental delivery)
- Follow-up TODOs: None
-->

# TLA+ for Zed Constitution

## Core Principles

### I. Correctness First

The extension MUST accurately represent TLA+ syntax and semantics.
Tree-sitter grammars MUST parse all valid TLA+ constructs without
false positives or negatives against the TLA+ language reference.
Syntax highlighting MUST distinguish operators, keywords, identifiers,
and proof constructs faithfully. Any LSP integration MUST surface
diagnostics from upstream tools (TLC, TLAPS) without alteration.

**Rationale**: TLA+ is a formal specification language used for
verifying system correctness. Tooling that misrepresents the language
undermines its core purpose.

### II. Minimal Footprint

The extension MUST minimize binary size, startup latency, and runtime
memory consumption. Dependencies MUST be justified; prefer Zed's
built-in APIs over external crates. The WASM binary SHOULD remain
under 1 MB uncompressed. Extension activation MUST NOT block the
editor event loop.

**Rationale**: Zed extensions compile to WASM and run in a sandboxed
environment. Bloated extensions degrade editor performance for all
users.

### III. Upstream Alignment

The extension MUST follow Zed extension API conventions, including
manifest format (`extension.toml`), directory layout (`languages/`,
`grammars/`), and lifecycle hooks. Tree-sitter grammars SHOULD track
the canonical `tree-sitter-tlaplus` grammar. Language server
configuration MUST conform to Zed's LSP adapter patterns.

**Rationale**: Alignment with upstream reduces maintenance burden,
ensures compatibility with Zed updates, and enables contribution
back to the ecosystem.

### IV. Incremental Delivery

Each deliverable MUST be a self-contained, working increment that
provides user value on its own. The delivery order is:

1. Tree-sitter grammar integration (syntax parsing)
2. Syntax highlighting and bracket matching
3. Code folding and indentation rules
4. Language server integration (diagnostics, go-to-definition)
5. Advanced features (snippets, task runners, model checking)

No phase MUST depend on a later phase being complete. Each phase
MUST be shippable independently.

**Rationale**: Incremental delivery enables early feedback, reduces
risk, and lets users benefit from partial implementations.

## Technology Constraints

- **Language**: Rust (latest stable), compiled to WASM via
  `wasm32-wasip1` target
- **Extension Framework**: Zed Extension API (`zed_extension_api`
  crate)
- **Grammar**: Tree-sitter, tracking `tree-sitter-tlaplus`
- **LSP**: TLA+ Language Server (`tlaplus-lsp`) or SANY-based
  tooling, integrated via Zed's LSP adapter
- **File Types**: `.tla` (specifications), `.cfg` (model configs)
- **Platform**: Cross-platform (Windows, macOS, Linux) via WASM
  sandboxing
- **Build**: `cargo build --target wasm32-wasip1 --release`

## Development Workflow

- Feature work follows the SpecKit pipeline: specify, plan, tasks,
  implement
- Commits MUST be atomic and map to a single task or logical change
- Grammar changes MUST include test corpus entries
  (`test/corpus/*.txt`)
- Manual validation against representative TLA+ files (e.g.,
  Lamport's examples) before merging
- Extension MUST be tested by loading it in Zed's dev extension mode

## Governance

This constitution is the authoritative reference for all development
decisions on the TLA+ for Zed extension. When a practice conflicts
with this document, this document prevails.

**Amendment procedure**: Propose changes via pull request. Each
amendment MUST document the rationale, the affected principles, and
any migration steps. Version bumps follow semantic versioning:

- **MAJOR**: Principle removed or fundamentally redefined
- **MINOR**: New principle or section added, or material expansion
- **PATCH**: Clarifications, wording, or non-semantic refinements

**Compliance**: All specifications, plans, and task lists MUST
reference the applicable constitution principles. Reviews SHOULD
verify principle adherence.

**Version**: 1.0.0 | **Ratified**: 2025-02-14 | **Last Amended**: 2025-02-14
