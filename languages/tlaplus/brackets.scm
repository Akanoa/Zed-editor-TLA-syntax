; TLA+ bracket matching for Zed

("(" @open ")" @close)
("[" @open "]" @close)
("{" @open "}" @close)
((langle_bracket) @open (rangle_bracket) @close)
("\"" @open "\"" @close)
