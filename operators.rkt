#lang racket
(provide parse-unary-minus parse-binary-op)
(require "parsing.rkt")

(define (parse-unary-minus chars history eval-expr-proc)
  (define chars-after-minus (skip-whitespace (cdr chars)))
  (define-values (ok? val remaining) (eval-expr-proc chars-after-minus history))
  (if ok?
      (values #t (- val) remaining)
      (values #f #f remaining)))

(define (parse-binary-op chars history operation op-char eval-expr-proc)
  (define chars-after-op (skip-whitespace (cdr chars)))
  (define-values (ok1? val1 remaining1) (eval-expr-proc chars-after-op history))
  (if (not ok1?)
      (values #f #f remaining1)
      (let ()
        (define-values (ok2? val2 remaining2) (eval-expr-proc remaining1 history))
        (if (not ok2?)
            (values #f #f remaining2)
            (if (and (char=? op-char #\/) (zero? val2))
                (values #f #f remaining2)
                (values #t (operation val1 val2) remaining2))))))
