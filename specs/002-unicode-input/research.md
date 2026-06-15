# Research: Unicode Symbol Recognition and Input for TLA+

**Branch**: `002-unicode-input` | **Date**: 2026-06-14

## Decision 1: Recognition is already provided by the grammar

**Decision**: Treat Unicode recognition as a verification task, not a
grammar task. Close gaps only in the query and config files.

**Rationale**: The `tree-sitter-tlaplus` grammar defines each operator
as a `choice` over its ASCII and Unicode spellings, producing one parse
node for both. Examples from `grammar.js`:

```js
set_in: $ => choice('\\in', '∈'),
land:   $ => choice('/\\', '\\land', '∧'),
lor:    $ => choice('\\/', '\\lor', '∨'),
forall: $ => choice('\\A', '\\forall', '∀'),
exists: $ => choice('\\E', '\\exists', '∃'),
```

The extension's `highlights.scm` captures these by node name —
`(set_in) @keyword`, `(bound_infix_op symbol: (_) @operator)`, and so
on — so both spellings are already highlighted. No grammar change and
no new highlight rule for each symbol are required.

**Source**: tree-sitter-tlaplus `grammar.js`,
<https://github.com/tlaplus-community/tree-sitter-tlaplus>.

**Alternatives considered**:
- Add a separate highlight rule per Unicode symbol — redundant, since
  the node name already covers both spellings.

## Decision 2: One known recognition gap — the `〈 〉` angle brackets

**Decision**: Add the CJK angle brackets `〈` (U+3008) and `〉`
(U+3009) to `config.toml` and `highlights.scm`, alongside the existing
`⟨` (U+27E8) and `⟩` (U+27E9).

**Rationale**: The grammar accepts three spellings of the angle
brackets:

```js
langle_bracket: $ => choice('<<', '〈', '⟨'),
rangle_bracket: $ => choice('>>', '〉', '⟩'),
```

The current `config.toml` and `highlights.scm` list `⟨`/`⟩` but not
`〈`/`〉`. For full parity, the second pair should be added to the
bracket list and the punctuation highlight group. The bracket *node*
(`langle_bracket`) is already captured, so highlighting works through
the node; the literal-string additions matter for auto-close and
bracket matching.

**Alternatives considered**:
- Ignore `〈`/`〉` — they are rarely typed, but parity is cheap and
  removes a surprise.

## Decision 3: Provide input through extension-bundled snippets

**Decision**: Ship a snippet file via the `snippets` field of
`extension.toml`. Each backslash command is one snippet whose `prefix`
is the command and whose `body` is the Unicode symbol.

**Rationale**: Zed extensions can bundle snippets. The manifest lists
snippet files in a `snippets` array of paths relative to
`extension.toml`, and Zed scopes each file by the lowercase language
name. Snippets appear in the completion menu; the selected entry is
confirmed with Tab. This satisfies the "type `\in`, press Tab → `∈`"
requirement with no Rust code, keeping the extension purely
declarative (Constitution Principle II).

**Source**: Zed extension snippets documentation,
<https://zed.dev/docs/extensions/snippets>; Zed snippets documentation,
<https://zed.dev/docs/snippets>; Zed completions documentation,
<https://zed.dev/docs/completions>.

**Alternatives considered**:
- A language server that returns completions — requires Rust and a WASM
  binary; out of scope and contrary to Minimal Footprint.
- User-level snippets in `~/.config/zed/snippets` — not shippable with
  the extension; each user would configure them by hand.

## Decision 4: Scope file name and the `+` in "TLA+"

**Decision**: Name the snippet file for the lowercase language name and
verify the exact name in Zed before publishing.

**Rationale**: Zed matches a snippet file to a language by the
language's lowercase name (e.g. `rust.json` for Rust). The language
here is named `TLA+`, so the expected file name is `tla+.json`. A `+`
in a file name is legal, but the lowercasing-and-matching behavior for
a name containing `+` should be confirmed rather than assumed.

**Verification step**: With a `.tla` buffer focused, run the
`snippets: configure snippets` action. Zed creates (or opens) the
language-scoped snippet file with the exact name it expects. Mirror
that name under the extension's `snippets/` directory.

**Source**: Zed snippets documentation, scope table,
<https://zed.dev/docs/snippets>.

**Alternatives considered**:
- Use the global `snippets.json` — it would expose the Unicode
  completions in every language, violating FR-005. Rejected.

## Decision 5: Backslash and the completion query

**Decision**: Test completion matching first. If the leading backslash
prevents a match, add `\` to `word_characters` in `config.toml`.

**Rationale**: `config.toml` sets `word_characters = ["_", "'"]`.
Backslash is not a word character, so when the user types `\in` the
completion engine may compute the query as `in` and may not match a
snippet whose prefix is `\in`. TLA+ identifiers cannot contain a
backslash, and its backslash operators are lexically `\` followed by
letters, so adding `\` to `word_characters` is sound and would let the
engine treat `\in` as one word for matching. The change is small and
reversible, so it is held as a contingency pending the matching test.

**Alternatives considered**:
- Drop the leading backslash from snippet prefixes (prefix `in` → `∈`)
  — collides with the keyword `IN` and with identifiers; rejected.
- Rely on manual completion (`ctrl-space`) — acceptable fallback but a
  worse experience; documented in quickstart.md.

## Decision 6: Which commands to bind

**Decision**: Bind every operator that has at least one backslash
spelling and a Unicode target in the grammar. Provide one snippet per
spelling. Exclude number-format escapes and the bare `\` operator.

**Rationale**: The request is "backslash commands only." The grammar's
operator rules name the eligible commands directly. Number formats
(`\b`, `\B`, `\o`, `\O`, `\h`, `\H`) are excluded because they are not
operators and because `\o`/`\O` would collide with composition (`∘`)
and octal literals. The set-difference operator is the bare token `\`
with no Unicode form, so it is excluded. The complete binding list is
in data-model.md.

**Alternatives considered**:
- Include symbolic operators (`->`, `=>`, `<<`) — out of scope per the
  user's "backslash commands only" instruction and FR-006.
