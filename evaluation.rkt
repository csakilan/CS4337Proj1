#lang racket
(provide eval-line-basic)
(require "parsing.rkt" "operators.rkt")

(define (eval-expr chars history)
  (define chars-trimmed (skip-whitespace chars))
  (cond
    [(null? chars-trimmed) (values #f #f chars-trimmed)]
    [(char=? (car chars-trimmed) #\+)
     (parse-binary-op chars-trimmed history + #\+ eval-expr)]
    [(char=? (car chars-trimmed) #\*)
     (parse-binary-op chars-trimmed history * #\* eval-expr)]
    [(char=? (car chars-trimmed) #\/)
     (parse-binary-op chars-trimmed history quotient #\/ eval-expr)]
    [(char=? (car chars-trimmed) #\$)
     (parse-history-ref chars-trimmed history)]
    [(char=? (car chars-trimmed) #\-)
     (let ([chars-after-minus (cdr chars-trimmed)])
       (if (and (not (null? chars-after-minus))
                (char-numeric? (car chars-after-minus)))
           (parse-number chars-trimmed)
           (parse-unary-minus chars-trimmed history eval-expr)))]
    [else (parse-number chars-trimmed)]))

(define (eval-line-basic s history)
  (define chars (string->list s))
  (define-values (ok? val remaining) (eval-expr chars history))
  (if ok?
      (let ([remaining-trimmed (skip-whitespace remaining)])
        (if (null? remaining-trimmed)
            (values #t val)
            (values #f #f)))
      (values #f #f)))
