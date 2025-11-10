#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-string)
 (only-in :std/sugar
          hash)
 (only-in :std/srfi/115
          regexp-match-submatch
          regexp-fold))

(def (parse-match m (n : :integer))
  (string->number (regexp-match-submatch m n)))

(def (part-one-fold _i match _s (acc : :number))
  (+ acc
     (* (parse-match match 1)
        (parse-match match 2))))

(def part-one-regex '(: "mul(" ($ (** 1 3 numeric)) "," ($ (** 1 3 numeric)) ")"))

(def part-two-regex '(or "do()"
                         "don't()"
                         (: "mul(" ($ (** 1 3 numeric)) "," ($ (** 1 3 numeric)) ")")))

(def (part-two-fold _i match _s acc)
  (case (regexp-match-submatch match 0)
    (("do()") (hash-merge (hash (do: #t)) acc))
    (("don't()") (hash-merge (hash (do: #f)) acc))
    (else (if (not (hash-ref acc do: #t))
            acc
            (hash-merge
             (hash (sum: (+ (hash-ref acc sum: 0)
                            (* (parse-match match 1)
                               (parse-match match 2)))))
             acc)))))

(def (main . args)
  (def filename (second args))
  (def input (read-file-string filename))
  (pp (case (first args)
        (("part-one") (regexp-fold part-one-regex part-one-fold 0 input))
        (("part-two") (hash-get (regexp-fold part-two-regex part-two-fold (hash) input) sum:))
        (else (error "Invalid invocation")))))
