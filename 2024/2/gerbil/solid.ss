#!/usr/bin/env gxi
; Gerbil v0.18.1-171-g7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-lines))

(def (safe? (line : :string))
  (let lp ((previous #f)
           (order #f)
           (strings (string-split line #\space)))
    (if (null? strings)
      #t
      (let* ((current (string->number (car strings))))
        (cond
          ((not previous)
           (lp current #f (cdr strings)))

          ((and (or (not order)
                    (equal? order asc:))
                (< previous current (+ previous 4)))
           (lp current asc: (cdr strings)))
          
          ((and (or (not order)
                    (equal? order desc:))
                (< (- previous 4) current previous))
           (lp current desc: (cdr strings)))

          (else #f))))))

(def (main . args)
  (def filename (car args))
  (def lines (read-file-lines filename))
  (displayln (length (filter safe? lines))))
