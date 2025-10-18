#!/usr/bin/env gxi
; Gerbil v0.18.1-171-g7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
  (only-in :std/coroutine
           continue
           coroutine
           yield)
  (only-in :std/sugar
           chain)
  (only-in :std/misc/rbtree
           make-rbtree
           rbtree-foldr
           rbtree-update)
  (only-in :std/pregexp
           pregexp-split))

(def (generate-input-lines filename)
  (coroutine
    (lambda ()
      (call-with-input-file filename
        (lambda (p)
          (let loop ((line (read-line p)))
            (if (eof-object? line)
              'end
              (begin
                (yield line)
                (loop (read-line p))))))))))

(def (split-line line)
  (pregexp-split "[[:space:]]+" line))

(def (generate-pairs coro)
  (coroutine
    (lambda ()
      (let loop ((s (continue coro)))
        (if (eq? 'end s)
          'end
          (begin
            (yield (split-line s))
            (loop (continue coro))))))))

(def (rbtree-expand rbtree)
  (letrec ((expand
            (lambda (k v a)
               (if (= v 1)
                   (cons k a)
                   (expand k (1- v) (cons k a))))))
    (rbtree-foldr expand '() rbtree)))

(def (generate-number-pairs coro)
  (coroutine
    (lambda ()
      (let loop ((xs (continue coro)))
        (if (eq? 'end xs)
          'end
          (begin
            (yield (map string->number xs))
            (loop (continue coro))))))))

(def (distance x y)
  (abs (- x y)))

(def (main . args)
  (def coro (chain (car args)
                   generate-input-lines
                   generate-pairs
                   generate-number-pairs))
  (let loop ((xs (continue coro))
             (lefts (make-rbtree -))
             (rights (make-rbtree -)))
    (match xs
      ([a b]
       (loop (continue coro)
             (rbtree-update lefts a 1+ 0)
             (rbtree-update rights b 1+ 0)))
      ('end
       (pp
        (foldl + 0 (map distance
                        (rbtree-expand lefts)
                        (rbtree-expand rights))))))))
