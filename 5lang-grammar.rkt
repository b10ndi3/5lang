#lang eopl
; 5lang-grammar.rkt - Grammar for 5lang
; Designed by Lucas Willison <willisonl1@udayton.edu> and Charles Pope <popec4@udayton.edu>

(display "5lang Grammar - Designed by Lucas Willison and Charles Pope\n")

(define the-lexical-spec
  '((whitespace (whitespace) skip)
    (comment (";" (arbno (not #\newline))) skip)
    (identifier
      (letter (arbno (or letter digit "_" "-" "?")))
      symbol)
    (number (digit (arbno digit)) number)
    (number (digit (arbno digit) "." (arbno digit)) number)
   )
)

(define the-grammar
  '((program (myexpression) a-program)
    
    ; numbers (literals)
    (myexpression (number) lit-exp)
    
    ; identifiers (vars)
    (myexpression (identifier) id-exp)
    
    ; binary operations (eg. (1 + 2))
    ; format: (left op right)
    (myexpression 
      ("(" myexpression primitive myexpression ")")
      binary-exp)
    
    ; local binding
    ; format: hold x = 5 inside
    (myexpression
      ("hold" identifier "=" myexpression "inside" myexpression)
      hold-exp)
      
    ; conditionals
    ; given x then y otherwise z
    (myexpression
      ("given" myexpression "then" myexpression "otherwise" myexpression)
      given-exp)
      
    ; function definition
    ; format: task (x,y) -> { body }
    (myexpression
     ("task" "(" (separated-list identifier ",") ")" "->" "{" myexpression "}")
     function-def-exp)
     
    ; function calling
    ; format: call f(x,y)
    (myexpression
     ("call" identifier "(" (separated-list myexpression ",") ")")
     function-call-exp)
     
    ; Print
    ; format: print(x), only takes expressions 
    (myexpression
     ("print" "(" myexpression ")")
     print-exp)

    ; primitives
    (primitive ("+") add-prim)
    (primitive ("-") subtract-prim)
    (primitive ("*") multiply-prim)
    (primitive ("/") divide-prim)
    (primitive (">") greater-prim)
    (primitive ("<") less-prim)
   )
)

(sllgen:make-define-datatypes the-lexical-spec the-grammar)

(define show-datatypes
  (lambda () (sllgen:list-define-datatypes the-lexical-spec the-grammar))
  )

; provide all functions and variables to interpreter
(provide (all-defined-out))
