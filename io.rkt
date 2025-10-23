#lang racket
(provide print-success print-error)

;; success format: "id: <real->double-flonum>"
(define (print-success id value)
  (display id)
  (display ": ")
  (display (real->double-flonum value))
  (displayln ""))

;; generic error per spec
(define (print-error)
  (displayln "Error: Invalid Expression"))
