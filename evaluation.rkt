#lang racket
(provide eval-line-basic)
(require "util.rkt")

;; Helper: skip leading whitespace
(define (skip-whitespace chars)
  (cond
    [(null? chars) '()]
    [(char-whitespace? (car chars)) (skip-whitespace (cdr chars))]
    [else chars]))

;; Parse a number from the character list
;; Returns (ok? value remaining-chars)
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
           ;; Could be start of negative number
           (loop (cdr cs) (cons (car cs) digits))]
          [(and (= (length digits) 1) (char=? (car digits) #\-) (char-numeric? (car cs)))
           ;; We have a minus sign, now seeing a digit
           (loop (cdr cs) (cons (car cs) digits))]
          [else
           ;; Hit a non-numeric character
           (if (null? digits)
               (values #f #f cs)
               (let ([num (string->number (list->string (reverse digits)))])
                 (if num
                     (values #t num cs)
                     (values #f #f cs))))]))))

;; Parse unary minus operator
;; Returns (ok? value remaining-chars)
(define (parse-unary-minus chars history)
  (define chars-after-minus (skip-whitespace (cdr chars))) ; skip the '-'
  (define-values (ok? val remaining) (eval-expr chars-after-minus history))
  (if ok?
      (values #t (- val) remaining)
      (values #f #f remaining)))

;; Parse binary operator (+, *, /)
;; Returns (ok? value remaining-chars)
(define (parse-binary-op chars history operation op-char)
  (define chars-after-op (skip-whitespace (cdr chars))) ; skip the operator
  ;; Parse first operand
  (define-values (ok1? val1 remaining1) (eval-expr chars-after-op history))
  (if (not ok1?)
      (values #f #f remaining1)
      ;; Parse second operand
      (let ()
        (define-values (ok2? val2 remaining2) (eval-expr remaining1 history))
        (if (not ok2?)
            (values #f #f remaining2)
            ;; Check for division by zero
            (if (and (char=? op-char #\/) (zero? val2))
                (values #f #f remaining2)
                (values #t (operation val1 val2) remaining2))))))

;; Main evaluation function
;; Returns (ok? value remaining-chars) as three values
(define (eval-expr chars history)
  (define chars-trimmed (skip-whitespace chars))
  (cond
    [(null? chars-trimmed) (values #f #f chars-trimmed)]
    ;; Check for binary operators
    [(char=? (car chars-trimmed) #\+)
     (parse-binary-op chars-trimmed history + #\+)]
    [(char=? (car chars-trimmed) #\*)
     (parse-binary-op chars-trimmed history * #\*)]
    [(char=? (car chars-trimmed) #\/)
     (parse-binary-op chars-trimmed history quotient #\/)]
    ;; Check for unary minus operator
    ;; It's a unary minus if after '-' and whitespace, we don't see a digit immediately
    [(char=? (car chars-trimmed) #\-)
     (let ([chars-after-minus (cdr chars-trimmed)])
       (if (and (not (null? chars-after-minus))
                (char-numeric? (car chars-after-minus)))
           ;; It's a negative number like -5
           (parse-number chars-trimmed)
           ;; It's a unary operator like "- 5"
           (parse-unary-minus chars-trimmed history)))]
    ;; Otherwise try to parse a number
    [else (parse-number chars-trimmed)]))

;; Entry point: evaluates a line of input
;; Returns (ok? value) as two values
(define (eval-line-basic s history)
  (define chars (string->list s))
  (define-values (ok? val remaining) (eval-expr chars history))
  (if ok?
      ;; Check if there are leftover characters (error condition)
      (let ([remaining-trimmed (skip-whitespace remaining)])
        (if (null? remaining-trimmed)
            (values #t val)
            (values #f #f))) ; Leftover characters = error
      (values #f #f)))
