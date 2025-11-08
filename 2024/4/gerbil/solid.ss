#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-lines))

(def (dim (m : :list))
  (values (length m)
          (string-length (car m))))

(def (at (m : :list) (x : :integer) (y : :integer)) => :string
  (string-ref (list-ref m y) x))

(def (main . args)
  (def filename (car args))
  (def input (read-file-lines filename))
  (pp input)
