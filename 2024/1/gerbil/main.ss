#!/usr/bin/env gxi
; Gerbil v0.18.1-171-g7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
  (only-in :std/misc/ports
           read-file-lines)
  (only-in :std/srfi/1
           unzip2)
  (only-in :std/sort
           sort)
  (only-in :std/pregexp
           pregexp-split))

(def (split-line (line : :string))
  => :list
  (pregexp-split "[[:space:]]+" line))

(def (distance (x : :number) (y : :number))
  => :number
  (abs (- x y)))

(def (strings->sorted-numbers (ss : :list))
  => :list
  (sort (map string->number ss) <))

(def (sum (xs : :list))
  => :number
  (foldl + 0 xs))

(def (part-one (lefts : :list) (rights : :list))
  (sum (map distance
            (strings->sorted-numbers lefts)
            (strings->sorted-numbers rights))))

(def (frequencies (xs : :list))
  (let ((ht (hash)))
    (for-each (cut hash-update! ht <> 1+ 0) xs)
    ht))

(def (part-two (lefts : :list) (rights : :list))
  => :integer
  (def freqs (frequencies rights))
  (sum
   (map (lambda (n)
          (* (string->number n)
             (hash-ref freqs n 0)))
        lefts)))

(def (main . args)
  (def filename (second args))
  (def proc (case (first args)
              (("part-one") part-one)
              (("part-two") part-two)
              (else (error "Invalid invocation"))))
  (def lines (read-file-lines filename))
  (def columns (map split-line lines))
  (let*-values (((lefts rights) (unzip2 columns)))
    (displayln (proc lefts rights))))
