#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/srfi/113
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

(def (invalid-position? (rules : :list) (preceding : :list) (n : :integer)) => :boolean
  (ormap
   (lambda (rule)
     (and (= n (cdr rule))
          (not (memf (cut = <> (car rule)) preceding))))
   rules))

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
  (let lp ((seen [])
           (rest update))
    (cond
      ((null? rest)
       #t)
      ((invalid-position? relevant-rules seen (car rest))
       #f)
      (else
       (lp (cons (car rest) seen)
           (cdr rest))))))

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
