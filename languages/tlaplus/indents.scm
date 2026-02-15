; TLA+ indentation rules for Zed
; Drives code folding via indentation-based folding

[
  (operator_definition)
  (function_definition)
  (module_definition)
  (recursive_declaration)
  (let_in)
  (if_then_else)
  (case)
  (choose)
  (bounded_quantification)
  (unbounded_quantification)
  (set_filter)
  (set_map)
  (function_literal)
  (non_terminal_proof)
  (block_comment)
  (assume_prove)
  (pcal_algorithm)
  (pcal_algorithm_body)
  (pcal_process)
  (pcal_procedure)
  (pcal_macro_decl)
  (pcal_if)
  (pcal_while)
  (pcal_either)
  (pcal_with)
] @indent

[
  ")"
  "]"
  "}"
  (rangle_bracket)
] @outdent
