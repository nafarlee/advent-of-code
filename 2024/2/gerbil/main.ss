#!/usr/bin/env gxi
; Gerbil v0.18.1-171-g7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/srfi/1
          count)
 (only-in :std/misc/ports
          read-file-lines))

(def (mildly-increasing? (x : :number) (y : :number)) => :boolean
  (< x y (+ x 4)))

(def (mildly-decreasing? (x : :number) (y : :number)) => :boolean
  (< (- x 4) y x))

(def (safe? (line : :string)) => :boolean
  (let* ((strings (string-split line #\space))
         (numbers (map string->number strings))
         (offset-numbers (cdr numbers)))
    (or (every mildly-increasing? numbers offset-numbers)
        (every mildly-decreasing? numbers offset-numbers))))
         
(def (main . args)
  (def filename (car args))
  (def lines (read-file-lines filename))
  (displayln (count safe? lines)))
