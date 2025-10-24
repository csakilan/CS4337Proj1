#lang racket
(provide eval-line-basic)
(require "util.rkt")

(define (skip-whitespace chars)
  (cond
    [(null? chars) '()]
    [(char-whitespace? (car chars)) (skip-whitespace (cdr chars))]
    [else chars]))

(define (parse-number chars)
  (define chars-trimmed (skip-whitespace chars))
  (if (null? chars-trimmed)
      (values #f #f chars-trimmed)
      (let loop ([cs chars-trimmed] [digits '()])
        (cond
          [(null? cs)
           (if (null? digits)
               (values #f #f cs)
               (let ([num (string->number (list->string (reverse digits)))])
                 (if num
                     (values #t num cs)
                     (values #f #f cs))))]
          [(char-numeric? (car cs))
           (loop (cdr cs) (cons (car cs) digits))]
          [(and (null? digits) (char=? (car cs) #\-))
           (loop (cdr cs) (cons (car cs) digits))]
          [(and (= (length digits) 1) (char=? (car digits) #\-) (char-numeric? (car cs)))
           (loop (cdr cs) (cons (car cs) digits))]
          [else
           (if (null? digits)
               (values #f #f cs)
               (let ([num (string->number (list->string (reverse digits)))])
                 (if num
                     (values #t num cs)
                     (values #f #f cs))))]))))

(define (parse-unary-minus chars history)
  (define chars-after-minus (skip-whitespace (cdr chars)))
  (define-values (ok? val remaining) (eval-expr chars-after-minus history))
  (if ok?
      (values #t (- val) remaining)
      (values #f #f remaining)))

(define (parse-binary-op chars history operation op-char)
  (define chars-after-op (skip-whitespace (cdr chars)))
  (define-values (ok1? val1 remaining1) (eval-expr chars-after-op history))
  (if (not ok1?)
      (values #f #f remaining1)
      (let ()
        (define-values (ok2? val2 remaining2) (eval-expr remaining1 history))
        (if (not ok2?)
            (values #f #f remaining2)
            (if (and (char=? op-char #\/) (zero? val2))
                (values #f #f remaining2)
                (values #t (operation val1 val2) remaining2))))))

(define (eval-expr chars history)
  (define chars-trimmed (skip-whitespace chars))
  (cond
    [(null? chars-trimmed) (values #f #f chars-trimmed)]
    [(char=? (car chars-trimmed) #\+)
     (parse-binary-op chars-trimmed history + #\+)]
    [(char=? (car chars-trimmed) #\*)
     (parse-binary-op chars-trimmed history * #\*)]
    [(char=? (car chars-trimmed) #\/)
     (parse-binary-op chars-trimmed history quotient #\/)]
    [(char=? (car chars-trimmed) #\-)
     (let ([chars-after-minus (cdr chars-trimmed)])
       (if (and (not (null? chars-after-minus))
                (char-numeric? (car chars-after-minus)))
           (parse-number chars-trimmed)
           (parse-unary-minus chars-trimmed history)))]
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
