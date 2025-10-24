#lang racket
(provide skip-whitespace parse-number parse-history-ref)

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

(define (parse-history-ref chars history)
  (define chars-after-dollar (skip-whitespace (cdr chars)))
  (if (null? chars-after-dollar)
      (values #f #f chars-after-dollar)
      (let loop ([cs chars-after-dollar] [digits '()])
        (cond
          [(null? cs)
           (if (null? digits)
               (values #f #f cs)
               (let ([id (string->number (list->string (reverse digits)))])
                 (if (and id (positive? id) (<= id (length history)))
                     (let ([history-reversed (reverse history)])
                       (values #t (list-ref history-reversed (- id 1)) cs))
                     (values #f #f cs))))]
          [(char-numeric? (car cs))
           (loop (cdr cs) (cons (car cs) digits))]
          [else
           (if (null? digits)
               (values #f #f cs)
               (let ([id (string->number (list->string (reverse digits)))])
                 (if (and id (positive? id) (<= id (length history)))
                     (let ([history-reversed (reverse history)])
                       (values #t (list-ref history-reversed (- id 1)) cs))
                     (values #f #f cs))))]))))
