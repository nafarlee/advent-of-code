#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/sugar
          chain)
 (only-in :std/misc/ports
          read-file-lines))

(def (parse-lines (separator : :char) (lines : :list)) => :list
  (def (parse-line (s : :string)) => :list
    (chain s
      (string-split <> separator)
      (map string->number <>)))
  (map parse-line
       (filter (cut string-index <> separator)
               lines)))

(def (main . args)
  (def filepath (first args))
  (def lines (read-file-lines filepath))
  (def rules (map (cut apply cons <>) (parse-lines #\| lines)))
  (def updates (parse-lines #\, lines))
  (pp [[rules: . rules]
       [updates: . updates]]))
