# Data Model: TLA+ Syntax Support for Zed

**Branch**: `001-tla-plus-syntax` | **Date**: 2025-02-14

## Overview

This feature has no persistent data model. The extension is a pure
declarative configuration that maps Tree-sitter parse tree nodes to
editor behaviors (highlighting, brackets, indentation). This
document describes the Tree-sitter node taxonomy and how it maps
to Zed editor features.

## Entity: Tree-sitter Node → Highlight Capture Mapping

Each Tree-sitter node type produced by `tree-sitter-tlaplus` maps
to a Zed highlight capture name. This mapping is the core "data
model" of the extension.

### Keywords → `@keyword`

| Node / Pattern | TLA+ Construct |
|----------------|----------------|
| `"MODULE"`, `"EXTENDS"`, `"INSTANCE"`, `"WITH"` | Module structure |
| `"CONSTANT"`, `"CONSTANTS"`, `"VARIABLE"`, `"VARIABLES"` | Declarations |
| `"ASSUME"`, `"ASSUMPTION"`, `"AXIOM"` | Assumptions |
| `"THEOREM"`, `"LEMMA"`, `"PROPOSITION"`, `"COROLLARY"` | Theorems |
| `"PROOF"`, `"PROVE"`, `"QED"`, `"BY"`, `"OBVIOUS"`, `"OMITTED"` | Proofs |
| `"IF"`, `"THEN"`, `"ELSE"`, `"CASE"`, `"OTHER"` | Conditionals |
| `"LET"`, `"IN"`, `"CHOOSE"`, `"LAMBDA"` | Expressions |
| `"DOMAIN"`, `"EXCEPT"`, `"UNCHANGED"`, `"ENABLED"` | Operators |
| `"RECURSIVE"`, `"LOCAL"` | Modifiers |
| `"WF_"`, `"SF_"` | Fairness |
| `"SUBSET"`, `"UNION"` | Set operators (keyword form) |

### PlusCal Keywords → `@keyword`

| Node / Pattern | PlusCal Construct |
|----------------|-------------------|
| `"algorithm"`, `"fair"` | Algorithm declaration |
| `"process"`, `"procedure"`, `"macro"` | Structure |
| `"begin"`, `"end"`, `"define"` | Blocks |
| `"variable"`, `"variables"` | Declarations |
| `"if"`, `"then"`, `"else"`, `"elsif"` | Conditionals |
| `"while"`, `"do"`, `"either"`, `"or"` | Control flow |
| `"with"`, `"await"`, `"when"` | Synchronization |
| `"skip"`, `"goto"`, `"call"`, `"return"` | Jumps |
| `"print"`, `"assert"` | Debugging |

### Identifiers → Various captures

| Node Type | Capture | Context |
|-----------|---------|---------|
| `constant_declaration > identifier` | `@constant` | CONSTANT declarations |
| `variable_declaration > identifier` | `@variable` | VARIABLE declarations |
| `operator_definition > name` | `@function` | Operator definitions |
| `function_definition > name` | `@function` | Function definitions |
| `operator_definition > parameter` | `@variable.parameter` | Op parameters |
| `choose > identifier` | `@variable.parameter` | CHOOSE bindings |
| `lambda > identifier` | `@variable.parameter` | Lambda parameters |
| `quantifier_bound > identifier` | `@variable.parameter` | Quantifier bounds |
| `extends > identifier_ref` | `@module` | EXTENDS references |
| `instance > identifier_ref` | `@module` | INSTANCE references |
| `module > name` | `@module` | Module name |
| `identifier_ref` | `@variable` | General references |

### Literals → Type-specific captures

| Node Type | Capture |
|-----------|---------|
| `nat_number` | `@number` |
| `real_number` | `@number` |
| `binary_number` | `@number` |
| `hex_number` | `@number` |
| `octal_number` | `@number` |
| `boolean` | `@constant.builtin` |
| `string` | `@string` |
| `escape_char` | `@string.special` |

### Built-in Sets → `@type`

| Node Type | TLA+ Set |
|-----------|----------|
| `boolean_set` | BOOLEAN |
| `nat_number_set` | Nat |
| `int_number_set` | Int |
| `real_number_set` | Real |
| `string_set` | STRING |

### Operators → `@operator`

| Node Type | Examples |
|-----------|----------|
| `infix_op_symbol` | `/\`, `\/`, `=>`, `<=>`, `\in`, etc. |
| `prefix_op_symbol` | `~`, `ENABLED`, `UNCHANGED`, etc. |
| `postfix_op_symbol` | `'` (prime) |
| `"=="` | Definition operator |
| `"|->"` | Maps-to |
| `"[]"`, `"<>"`, `"~>"` | Temporal operators |

### Structure → `@punctuation.*`

| Pattern | Capture |
|---------|---------|
| `"("`, `")"`, `"["`, `"]"`, `"{"`, `"}"` | `@punctuation.bracket` |
| `"<<"`, `">>"` | `@punctuation.bracket` |
| `","`, `":"`, `"."`, `"!"` | `@punctuation.delimiter` |

### Comments → `@comment`

| Node Type | Comment Style |
|-----------|---------------|
| `comment` | Line comments (`\*`) |
| `block_comment_text` | Block comments (`(* ... *)`) |

### Proofs → `@tag`

| Node Type | Context |
|-----------|---------|
| `proof_step_id > level` | Proof step level markers |
| `theorem > name` | Named theorems |

## Entity: Bracket Pairs

| Open | Close | Auto-close | Newline | Exclude contexts |
|------|-------|------------|---------|-----------------|
| `(` | `)` | yes | yes | — |
| `[` | `]` | yes | yes | — |
| `{` | `}` | yes | yes | — |
| `<<` | `>>` | yes | no | — |
| `(*` | `*)` | yes | yes | — |
| `"` | `"` | yes | no | string, comment |
