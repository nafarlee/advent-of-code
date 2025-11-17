#!/usr/bin/env janet

(def line-peg
  '(* (number (some :d))
      (some :s)
      (number (some :d))))

(defn line->row
  [line]
  (peg/match line-peg line))

(defn unzip2
  [xs]
  (var lefts @[])
  (var rights @[])
  (each [left right] xs
    (array/push lefts left)
    (array/push rights right))
  [lefts rights])

(defn distance
  [x y]
  (math/abs (- x y)))

(defn main
  [_ filename]
  (def contents (string/trim (slurp filename)))
  (def lines (string/split "\n" contents))
  (def rows (map line->row lines))
  (def [lefts rights] (unzip2 rows))
  (sort lefts)
  (sort rights)
  (def distances (map distance lefts rights))
  (pp (reduce + 0 distances)))
