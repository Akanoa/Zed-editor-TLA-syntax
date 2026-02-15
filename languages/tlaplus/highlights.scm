; TLA+ and PlusCal highlights for Zed
; Adapted from tree-sitter-tlaplus upstream queries
; In this file, captures defined earlier take precedence over later ones.

; ──────────────────────────────────────────────
; TLA+ Keywords
; ──────────────────────────────────────────────

[
  "ACTION"
  "ASSUME"
  "ASSUMPTION"
  "AXIOM"
  "BY"
  "CASE"
  "CHOOSE"
  "CONSTANT"
  "CONSTANTS"
  "COROLLARY"
  "DEF"
  "DEFINE"
  "DEFS"
  "ELSE"
  "EXCEPT"
  "EXTENDS"
  "HAVE"
  "HIDE"
  "IF"
  "IN"
  "INSTANCE"
  "LAMBDA"
  "LEMMA"
  "LET"
  "LOCAL"
  "MODULE"
  "NEW"
  "OBVIOUS"
  "OMITTED"
  "ONLY"
  "OTHER"
  "PICK"
  "PROOF"
  "PROPOSITION"
  "PROVE"
  "QED"
  "RECURSIVE"
  "SF_"
  "STATE"
  "SUFFICES"
  "TAKE"
  "TEMPORAL"
  "THEN"
  "THEOREM"
  "USE"
  "VARIABLE"
  "VARIABLES"
  "WF_"
  "WITH"
  "WITNESS"
  (address)
  (all_map_to)
  (assign)
  (case_arrow)
  (case_box)
  (def_eq)
  (exists)
  (forall)
  (gets)
  (label_as)
  (maps_to)
  (set_in)
  (temporal_exists)
  (temporal_forall)
] @keyword

; ──────────────────────────────────────────────
; PlusCal Keywords
; ──────────────────────────────────────────────

[
  "algorithm"
  "assert"
  "await"
  "begin"
  "call"
  "define"
  "either"
  "else"
  "elsif"
  "end"
  "fair"
  "goto"
  "if"
  "macro"
  "or"
  "print"
  "procedure"
  "process"
  "variable"
  "variables"
  "when"
  "with"
  "then"
  (pcal_algorithm_start)
  (pcal_end_either)
  (pcal_end_if)
  (pcal_return)
  (pcal_skip)
  (pcal_process ("="))
  (pcal_with ("="))
] @keyword

; ──────────────────────────────────────────────
; Literals
; ──────────────────────────────────────────────

(binary_number (format) @keyword)
(binary_number (value) @number)
(boolean) @constant.builtin
(hex_number (format) @keyword)
(hex_number (value) @number)
(nat_number) @number
(octal_number (format) @keyword)
(octal_number (value) @number)
(real_number) @number
(string) @string
(escape_char) @string.special

; ──────────────────────────────────────────────
; Built-in Sets (Types)
; ──────────────────────────────────────────────

(boolean_set) @type
(int_number_set) @type
(nat_number_set) @type
(real_number_set) @type
(string_set) @type

; ──────────────────────────────────────────────
; Namespaces and Modules
; ──────────────────────────────────────────────

(extends (identifier_ref) @module)
(instance (identifier_ref) @module)
(module name: (_) @module)
(pcal_algorithm name: (identifier) @module)

; ──────────────────────────────────────────────
; Constants and Variables
; ──────────────────────────────────────────────

(constant_declaration (identifier) @constant)
(constant_declaration (operator_declaration name: (_) @constant))
(variable_declaration (identifier) @variable)
(pcal_var_decl (identifier) @variable)
(pcal_with (identifier) @variable.parameter)
((".") . (identifier) @property)
(record_literal (identifier) @property)
(set_of_records (identifier) @property)

; ──────────────────────────────────────────────
; Parameters
; ──────────────────────────────────────────────

(choose (identifier) @variable.parameter)
(choose (tuple_of_identifiers (identifier) @variable.parameter))
(lambda (identifier) @variable.parameter)
(module_definition (operator_declaration name: (_) @variable.parameter))
(module_definition parameter: (identifier) @variable.parameter)
(operator_definition (operator_declaration name: (_) @variable.parameter))
(operator_definition parameter: (identifier) @variable.parameter)
(pcal_macro_decl parameter: (identifier) @variable.parameter)
(pcal_proc_var_decl (identifier) @variable.parameter)
(quantifier_bound (identifier) @variable.parameter)
(quantifier_bound (tuple_of_identifiers (identifier) @variable.parameter))
(unbounded_quantification (identifier) @variable.parameter)

; ──────────────────────────────────────────────
; Operators, Functions, and Macros
; ──────────────────────────────────────────────

(function_definition name: (identifier) @function)
(module_definition name: (_) @module)
(operator_definition name: (_) @function)
(pcal_macro_decl name: (identifier) @function)
(pcal_macro_call name: (identifier) @function)
(pcal_proc_decl name: (identifier) @function)
(pcal_process name: (identifier) @function)
(recursive_declaration (identifier) @function)
(recursive_declaration (operator_declaration name: (_) @function))

; ──────────────────────────────────────────────
; Punctuation — Brackets
; ──────────────────────────────────────────────

[
  (langle_bracket)
  (rangle_bracket)
  (rangle_bracket_sub)
  "{"
  "}"
  "["
  "]"
  "]_"
  "("
  ")"
] @punctuation.bracket

; ──────────────────────────────────────────────
; Punctuation — Delimiters
; ──────────────────────────────────────────────

[
  ","
  ":"
  "."
  "!"
  ";"
  (bullet_conj)
  (bullet_disj)
  (prev_func_val)
  (placeholder)
] @punctuation.delimiter

; ──────────────────────────────────────────────
; Module Delimiters
; ──────────────────────────────────────────────

(header_line) @punctuation.special
(double_line) @punctuation.special
(single_line) @punctuation.special

; ──────────────────────────────────────────────
; Proofs
; ──────────────────────────────────────────────

(assume_prove (new (identifier) @variable.parameter))
(assume_prove (new (operator_declaration name: (_) @variable.parameter)))
(assumption name: (identifier) @constant)
(pick_proof_step (identifier) @variable.parameter)
(proof_step_id "<" @punctuation.bracket)
(proof_step_id (level) @tag)
(proof_step_id (name) @tag)
(proof_step_id ">" @punctuation.bracket)
(proof_step_ref "<" @punctuation.bracket)
(proof_step_ref (level) @tag)
(proof_step_ref (name) @tag)
(proof_step_ref ">" @punctuation.bracket)
(take_proof_step (identifier) @variable.parameter)
(theorem name: (identifier) @constant)

; ──────────────────────────────────────────────
; Comments
; ──────────────────────────────────────────────

(block_comment "(*" @comment)
(block_comment "*)" @comment)
(block_comment_text) @comment
(comment) @comment

; ──────────────────────────────────────────────
; Labels
; ──────────────────────────────────────────────

(_ label: (identifier) @label)
(label name: (_) @label)
(pcal_goto statement: (identifier) @label)

; ──────────────────────────────────────────────
; Operators (lowest precedence — overridden by above)
; ──────────────────────────────────────────────

(bound_infix_op symbol: (_) @operator)
(bound_nonfix_op symbol: (_) @operator)
(bound_postfix_op symbol: (_) @operator)
(bound_prefix_op symbol: (_) @operator)
((prefix_op_symbol) @operator)
((infix_op_symbol) @operator)
((postfix_op_symbol) @operator)

; Fallback identifier references
(identifier_ref) @variable
