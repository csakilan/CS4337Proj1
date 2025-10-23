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

;; Main evaluation function
;; Returns (ok? value remaining-chars) as three values
(define (eval-expr chars history)
  (define chars-trimmed (skip-whitespace chars))
  (if (null? chars-trimmed)
      (values #f #f chars-trimmed)
      ;; For now, just parse numbers
      (parse-number chars-trimmed)))

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
