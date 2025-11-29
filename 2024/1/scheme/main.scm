(import (scheme base)
        (only (scheme file) with-input-from-file)
        (only (scheme process-context) command-line)
        (only (srfi 1) fold unzip2)
        (only (srfi 13) string-tokenize)
        (only (srfi 95) sort)
        (only (srfi 159) pretty show))

(define (read-file-lines path)
  (with-input-from-file path
    (lambda ()
      (let lp ((lines '())
               (line (read-line)))
        (if (eof-object? line)
            (reverse lines)
            (lp (cons line lines)
                (read-line)))))))

(define (strings->sorted xs)
  (sort (map string->number xs)
        <))

(define (distance x y)
  (abs (- x y)))

(define (part-one lefts rights)
  (fold (lambda (left right sum)
          (+ sum (distance left right)))
        0
        (strings->sorted lefts)
        (strings->sorted rights)))

(begin
  (define args (cdr (command-line)))
  (define proc (cond
                 ((string=? "part-one" (car args))
                  part-one)
                 (else
                  (error "Invalid invocation"))))
  (define filename (cadr args))
  (define lines (read-file-lines filename))
  (define pairs (map string-tokenize lines))
  (define-values (lefts rights) (unzip2 pairs))
  (show #t (proc lefts rights)))
