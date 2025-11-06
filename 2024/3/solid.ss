#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-string)
 (only-in :std/srfi/115
          regexp-match-submatch
          regexp-fold))

(def (main . args)
  (def (parse-match m n)
    (string->number (regexp-match-submatch m n)))
  (def (fold-proc _i match _s acc)
    (+ acc
       (* (parse-match match 1)
          (parse-match match 2))))
  (def regex '(: "mul(" ($ (** 1 3 numeric)) "," ($ (** 1 3 numeric)) ")"))
  (def filename (car args))
  (def input (read-file-string filename))
  (pp (regexp-fold regex fold-proc 0 input)))
