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

(def (main . args)
  (def filename (car args))
  (def lines (read-file-lines filename))
  (def columns (map split-line lines))
  (let*-values (((lefts rights) (unzip2 columns)))
    (displayln (sum (map distance
                         (strings->sorted-numbers lefts)
                         (strings->sorted-numbers rights))))))
