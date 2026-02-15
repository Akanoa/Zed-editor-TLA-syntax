; TLA+ code outline for Zed
; Enables symbol navigation in the outline panel

(module
  name: (_) @name) @item

(operator_definition
  name: (_) @name) @item

(function_definition
  name: (identifier) @name) @item

(module_definition
  name: (_) @name) @item

(theorem
  name: (identifier) @name) @item

(assumption
  name: (identifier) @name) @item

(constant_declaration
  (identifier) @name) @item

(variable_declaration
  (identifier) @name) @item

(recursive_declaration
  (identifier) @name) @item

(pcal_algorithm
  name: (identifier) @name) @item

(pcal_process
  name: (identifier) @name) @item

(pcal_procedure
  (pcal_proc_decl
    name: (identifier) @name)) @item

(pcal_macro_decl
  name: (identifier) @name) @item
