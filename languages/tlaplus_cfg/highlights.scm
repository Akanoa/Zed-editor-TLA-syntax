; TLC Configuration File highlights for Zed

; ──────────────────────────────────────────────
; Directive Keywords
; ──────────────────────────────────────────────

(keyword) @keyword

; ──────────────────────────────────────────────
; Constants
; ──────────────────────────────────────────────

(constant_assignment
  name: (identifier) @constant)

(constant_substitution
  name: (identifier) @constant)

; ──────────────────────────────────────────────
; Literals
; ──────────────────────────────────────────────

(boolean) @constant.builtin
(number) @number
(string) @string

; ──────────────────────────────────────────────
; Operators
; ──────────────────────────────────────────────

(constant_assignment
  "=" @operator)

(constant_substitution
  "<-" @operator)

; ──────────────────────────────────────────────
; Punctuation
; ──────────────────────────────────────────────

(set_literal
  "{" @punctuation.bracket)
(set_literal
  "}" @punctuation.bracket)
(set_literal
  "," @punctuation.delimiter)

; ──────────────────────────────────────────────
; Comments
; ──────────────────────────────────────────────

(comment) @comment

; ──────────────────────────────────────────────
; Identifiers (lowest precedence)
; ──────────────────────────────────────────────

(identifier) @variable
