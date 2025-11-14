#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/srfi/113
          set
          set-adjoin
          set-contains?
          list->set)
 (only-in :std/srfi/128
          make-default-comparator)
 (only-in :std/sugar
          chain)
 (only-in :std/misc/ports
          read-file-lines))

(def (parse-lines (separator : :char) (lines : :list)) => :list
  (filter-map
   (lambda (line)
     (if (string-index line separator)
         (chain line
           (string-split <> separator)
           (map string->number <>))
         #f))
   lines))

(def (filter-relevant-rules (rules : :list) (update : :list)) => :list
  (def relevant-numbers (list->set (make-default-comparator) update))
  (filter (lambda (r)
            (and (set-contains? relevant-numbers (car r))
                 (set-contains? relevant-numbers (cdr r))))
          rules))

(def (middle (xs : :list))
  (list-ref xs (/ (1- (length xs)) 2)))

(def (valid-update? (rules : :list) (update : :list)) => :boolean
  (def relevant-rules (filter-relevant-rules rules update))
  (let lp ((rest update)
           (forbidden (set (make-default-comparator))))
    (cond
      ((null? rest)
       #t)
      ((set-contains? forbidden (car rest))
       #f)
      (else
       (lp (cdr rest)
           (foldl (lambda (r acc)
                    (if (= (car rest) (cdr r))
                        (set-adjoin acc (car r))
                        acc))
                  forbidden
                  relevant-rules))))))

(def (main . args)
  (def filepath (first args))
  (def lines (read-file-lines filepath))
  (def rules (map (cut apply cons <>) (parse-lines #\| lines)))
  (def updates (parse-lines #\, lines))
  (pp (foldl
       (lambda (update sum)
          (if (valid-update? rules update)
              (+ sum (middle update))
              sum))
       0
       updates)))
