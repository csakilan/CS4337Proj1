#lang racket
(provide trim-left trim-right trim split-ws)

(define (trim-left cs)
  (cond
    [(null? cs) '()]
    [(char-whitespace? (car cs)) (trim-left (cdr cs))]
    [else cs]))

(define (trim-right cs)
  (let loop ([rev (reverse cs)])
    (cond
      [(null? rev) '()]
      [(char-whitespace? (car rev)) (loop (cdr rev))]
      [else (reverse rev)])))

(define (trim s)
  (list->string (trim-right (trim-left (string->list s)))))

(define (split-ws s)
  (let loop ([cs (string->list s)] [cur '()] [out '()])
    (cond
      [(null? cs)
       (let ([tok (list->string (reverse cur))])
         (reverse (if (zero? (string-length tok)) out (cons tok out))))]
      [(char-whitespace? (car cs))
       (let ([tok (list->string (reverse cur))])
         (if (zero? (string-length tok))
             (loop (cdr cs) '() out)
             (loop (cdr cs) '() (cons tok out))))]
      [else (loop (cdr cs) (cons (car cs) cur) out)])))
