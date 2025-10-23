#lang racket


(include "mode.rkt")
(require "io.rkt")

(define interactive? prompt?)


(define (repl-loop history)
  (when interactive?
    (display "> ")
    (flush-output))                

  (define line (read-line))
  (cond
    [(eof-object? line) (void)]     
    [(string=? line "quit") (void)] 
    [else
     
     (when interactive?
       (displayln (string-append "echo: " line)))
     (repl-loop history)]))

(module+ main
  (repl-loop '()))    
