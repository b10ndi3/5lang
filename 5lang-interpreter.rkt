#lang eopl
; 5lang-interpreter.rkt - Interpreter for the 5lang language
; Designed by Lucas Willison <willisonl1@udayton.edu> and Charles Pope <popec4@udayton.edu>

(require "5lang-grammar.rkt")
(display "5lang Interpreter - Designed by Lucas Willison and Charles Pope\n")

; environment
(define-datatype environment environment?
  (empty-env)
  (extend-env
   (bvars (list-of symbol?))
   (bvals (list-of scheme-value?))
   (saved-env environment?)))

(define scheme-value?
  (lambda (s) #t))

(define apply-env
  (lambda (env search-sym)
    (cases environment env
      (empty-env ()
                 (eopl:error 'apply-env "Unbound variable: ~s" search-sym))
      (extend-env (bvars bvals saved-env)
                  (cond
                    ((location search-sym bvars)
                     => (lambda (n) (list-ref bvals n)))
                    (else (apply-env saved-env search-sym)))))))

(define location
  (lambda (sym syms)
    (cond
      ((null? syms) #f)
      ((eqv? sym (car syms)) 0)
      ((location sym (cdr syms))
       => (lambda (n) (+ n 1)))
      (else #f))))

; closure
(define-datatype proc proc?
  (procedure
   (vars (list-of symbol?))
   (body myexpression?)
   (saved-env environment?)))

(define apply-procedure
  (lambda (proc1 args)
    (cases proc proc1
      (procedure (vars body saved-env)
                 (eval-expression body (extend-env vars args saved-env))))))

; parser
(define myparser
  (sllgen:make-string-parser the-lexical-spec the-grammar))

; interpreter logic
(define eval-program
  (lambda (prog-ast)
    (cases program prog-ast
      (a-program (expr)
                 (eval-expression expr (empty-env))))))

; helper: truthiness for conditionals
(define truthy?
  (lambda (v)
    (if (number? v)
        (not (zero? v))
        (eopl:error 'given "Conditional requires a numeric value, got ~s" v))))

; helper: ensure arithmetic operands are numbers
(define num-check
  (lambda (v)
    (cond
      ((number? v) v)
      ((proc? v)
       (eopl:error 'apply-primitive
                   "Expected a number, but got a function"))
      (else
       (eopl:error 'apply-primitive
                   "Expected a number, got ~s" v)))))

(define eval-expression
  (lambda (expr env)
    (cases myexpression expr
      ; numbers
      (lit-exp (datum) datum)
      
      ; identifiers
      (id-exp (id)
              (apply-env env id))
      
      ; binary operations
      (binary-exp (left-exp op right-exp)
                  (let ((val1 (eval-expression left-exp env))
                        (val2 (eval-expression right-exp env)))
                    (apply-primitive op val1 val2)))
      
      ; hold - local binding
      (hold-exp (id rhs-exp body-exp)
                (let ((val (eval-expression rhs-exp env)))
                  (eval-expression body-exp
                                   (extend-env (list id) (list val) env))))
      
      ; given - conditional statements
      (given-exp (cond-exp then-exp else-exp)
                 (if (truthy? (eval-expression cond-exp env))
                     (eval-expression then-exp env)
                     (eval-expression else-exp env)))
      
      ; task - define functions
      (function-def-exp (vars body)
                        (procedure vars body env))
      
      ; call - calls a function
      (function-call-exp (fid args)
                         (let* ((func (apply-env env fid))
                                (arg-vals (map (lambda (exp)
                                                 (eval-expression exp env))
                                               args)))
                           (if (proc? func)
                               (apply-procedure func arg-vals)
                               (eopl:error 'function-call-exp
                                           "Cannot call ~s because it is not a function. Actual value: ~s"
                                           fid func))))
      
      ; print - prints output and returns value
      (print-exp (exp)
                 (let ((val (eval-expression exp env)))
                   (cond
                     ((proc? val) (display "<function>"))
                     (else (display val)))
                   (newline)
                   val)))))

; primitive operations
(define apply-primitive
  (lambda (prim val1 val2)
    (let ((v1 (num-check val1))
          (v2 (num-check val2)))
      (cases primitive prim
        (add-prim () (+ v1 v2))
        (subtract-prim () (- v1 v2))
        (multiply-prim () (* v1 v2))
        (divide-prim ()
                     (if (zero? v2)
                         (eopl:error 'apply-primitive "Division by zero")
                         (/ v1 v2)))
        (greater-prim () (if (> v1 v2) 1 0))
        (less-prim () (if (< v1 v2) 1 0))))))

; run - runs code in a quote "", use (run "...")
(define run
  (lambda (string)
    (eval-program (myparser string))
    (values)))
