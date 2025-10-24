#lang racket
(require "mode.rkt" "io.rkt" "evaluation.rkt")

(define interactive? prompt?)

(define (repl-loop history)
  (when interactive? (display "> ") (flush-output))
  (define line (read-line))
  (cond
    [(eof-object? line) (void)]
    [(string=? line "quit") (void)]
    [else
     (call-with-values
       (lambda () (eval-line-basic line history))
       (lambda (ok val)
         (if ok
             (let ([next-id (add1 (length history))])
               (print-success next-id val)
               (repl-loop (cons val history)))
             (begin
               (print-error)
               (repl-loop history)))))]))

(module+ main
  (repl-loop '()))
