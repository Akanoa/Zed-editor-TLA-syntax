---- MODULE UnicodeCoverage ----
EXTENDS Naturals

\* This fixture exercises the Unicode spellings of TLA+ operators.
\* Open it in Zed and confirm each symbol highlights like its ASCII form,
\* that no valid construct is flagged as a parse error, and that
\* angle-bracket pairs highlight as brackets.

\* logic:        ∧ ∨ ¬ ⇒ ≡
\* quantifiers:  ∀ ∃
\* relations:    ≤ ≥ ≈ ≅ ≺ ≻ ⪯ ⪰ ∼ ≃ ≪ ≫ ≍ ≐ ∝
\* sets:         ∈ ∉ ⊂ ⊃ ⊆ ⊇ ∩ ∪ ⊓ ⊔ ⊎ ⊏ ⊐ ⊑ ⊒
\* arithmetic:   × ÷ ⋅ ∘ ⋆ ● ◯ ⊕ ⊖ ⊗ ⊙ ⊘ ≀
\* brackets:     ⟨ 1, 2 ⟩

Pos        == { x ∈ Nat : x > 0 }
AndOr(a, b) == a ∧ b ∨ ¬ a
AllPos     == ∀ n ∈ Pos : n ≥ 1
SomePos    == ∃ n ∈ Pos : n ≤ 3
Tuple1     == ⟨1, 2, 3⟩
Tuple1     == (1, 2, 3)
Cup        == Pos ∪ {0}
Cap        == Pos ∩ Nat
====
