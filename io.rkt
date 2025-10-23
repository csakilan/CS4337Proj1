#lang racket
(provide print-success print-error)

(define (print-success id value)
  (display id)
  (display ": ")
  (display (real->double-flonum value))
  (displayln ""))

(define (print-error)
  (displayln "Error: Invalid Expression"))
