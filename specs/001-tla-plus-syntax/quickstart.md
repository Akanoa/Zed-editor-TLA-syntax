# Quickstart: TLA+ Syntax Support for Zed

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14

## Prerequisites

- Zed editor installed (latest stable)
- Git (for cloning the extension during development)

## Development Setup

1. Clone the extension repository:

   ```bash
   git clone <repository-url> zed-tla-plus
   cd zed-tla-plus
   ```

2. Open Zed and install the extension in dev mode:
   - Open Zed
   - Open the command palette (Ctrl+Shift+P / Cmd+Shift+P)
   - Run "zed: install dev extension"
   - Select the `zed-tla-plus` directory

3. Open a `.tla` file to verify syntax highlighting works.

## Project Structure

```text
zed-tla-plus/
├── extension.toml              # Extension manifest
└── languages/
    └── tlaplus/
        ├── config.toml         # Language registration
        ├── highlights.scm      # Syntax highlighting queries
        ├── brackets.scm        # Bracket pair definitions
        ├── indents.scm         # Indentation rules
        └── outline.scm         # Code outline/navigation
```

## Validation Checklist

After installing the dev extension, verify each feature:

### File Recognition
- [ ] Open a `.tla` file — status bar shows "TLA+"
- [ ] Create a new file, save as `.tla` — highlighting activates

### Syntax Highlighting
- [ ] Keywords (`MODULE`, `VARIABLES`, etc.) are highlighted
- [ ] Operators (`/\`, `\/`, `\in`, etc.) are highlighted
- [ ] Comments (`\*` and `(* *)`) are highlighted
- [ ] Strings and numbers are highlighted
- [ ] Module delimiters (`----` and `====`) are highlighted

### Bracket Matching
- [ ] Click on `(` — matching `)` highlights
- [ ] Click on `[` — matching `]` highlights
- [ ] Click on `{` — matching `}` highlights
- [ ] Type `<<` — `>>` auto-inserted
- [ ] Type `(*` — `*)` auto-inserted

### Comment Toggling
- [ ] Select lines, toggle line comment — `\*` prefix added
- [ ] Select block, toggle block comment — `(* *)` wraps

### Code Folding
- [ ] Multi-line operator definitions show fold indicators
- [ ] Block comments can be folded
- [ ] Folding/unfolding produces no visual artifacts

### PlusCal (if implemented)
- [ ] PlusCal keywords highlighted within algorithm blocks
- [ ] Labels highlighted as identifiers

## Test Files

Use these representative TLA+ files for validation:

1. **Simple spec** — test basic keywords and operators:

   ```tla
   ---- MODULE SimpleSpec ----
   EXTENDS Naturals
   VARIABLES x, y

   Init == x = 0 /\ y = 0
   Next == x' = x + 1 /\ y' = y + 1
   Spec == Init /\ [][Next]_<<x, y>>
   ====
   ```

2. **Comments and strings** — test comment handling:

   ```tla
   ---- MODULE Comments ----
   \* This is a line comment
   (* This is a block comment
      (* with nesting *)
      still in block *)
   Msg == "Hello, TLA+"
   ====
   ```

3. **Complex spec** — download from official TLA+ examples:
   https://github.com/tlaplus/Examples

## Rebuilding After Changes

After editing `.scm` or `.toml` files:

1. Close and reopen any `.tla` files, or
2. Reload the Zed window (Ctrl+Shift+P → "workspace: reload")

No compilation step is needed — the extension is purely declarative.
