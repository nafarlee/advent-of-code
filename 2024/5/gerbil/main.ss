#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
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
  (filter (lambda (r)
            (and (member (car r) update)
                 (member (cdr r) update)))
          rules))

(def (middle (xs : :list))
  (list-ref xs (/ (1- (length xs)) 2)))

(def (valid-update? (rules : :list) (update : :list)) => :boolean
  (def relevant-rules (filter-relevant-rules rules update))
  (let lp ((rest update)
           (forbidden []))
    (cond
      ((null? rest)
       #t)
      ((member (car rest) forbidden)
       #f)
      (else
       (lp (cdr rest)
           (foldl (lambda (r acc)
                    (if (= (car rest) (cdr r))
                        (cons (car r) acc)
                        acc))
                  forbidden
                  relevant-rules))))))

(def (find-options (relevant-rules : :list) (queued : :list) (available : :list))
  (foldl (lambda (rule remaining)
           (with ([before . after] rule)
             (if (not (member after queued))
                 (remove1 before remaining)
                 remaining)))
         available
         relevant-rules))

(def (fix-order (rules : :list) (update : :list)) => :list
  (def relevant-rules (filter-relevant-rules rules update))
  (let lp ((queue [])
           (available update))
    (if (null? available)
      queue
      (ormap (lambda (opt)
               (lp (cons opt queue)
                   (remove1 opt available)))
             (find-options relevant-rules queue available)))))

(def (main . args)
  (def filepath (second args))
  (def lines (read-file-lines filepath))
  (def rules (map (cut apply cons <>) (parse-lines #\| lines)))
  (def updates (parse-lines #\, lines))
  (with ((values valid-updates invalid-updates)
         (partition (cut valid-update? rules <>) updates))
    (pp (case (first args)
          (("part-one") (foldl + 0 (map middle valid-updates)))
          (("part-two") (foldl + 0 (map (chain <>
                                          (fix-order rules <>)
                                          (middle <>))
                                        invalid-updates)))
          (else (error "Invalid invocation"))))))
