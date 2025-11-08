#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-lines))

(def (dim (m : :list)) => :pair
  (cons (length m)
        (string-length (car m))))

(def (at (m : :list) (p : :pair)) => :string
  (with ([x . y] p)
    (string-ref (list-ref m y) x)))

(def (main . args)
  (def filename (car args))
  (def input (read-file-lines filename))
  (pp input)
  (pp (dim input))
  (pp (at input (cons 0 0))))
