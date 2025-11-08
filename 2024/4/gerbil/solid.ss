#!/usr/bin/env gxi
; Gerbil 7a453ba4 on Gambit v4.9.7-6-g64f4d369

(import
 (only-in :std/misc/ports
          read-file-lines)
 (only-in :std/srfi/1
          count)
 (only-in :std/iter
          in-range
          for*))

(def (dim (m : :list)) => :pair
  (cons (length m)
        (string-length (car m))))

(def (at (m : :list) (p : :pair)) => :string
  (with-exception-handler
    false
    (lambda ()
      (with ([x . y] p)
        (string-ref (list-ref m y) x)))))

(def (add (pa : :pair) (pb : :pair)) => :pair
  (with (([pax . pay] pa)
         ([pbx . pby] pb))
    (cons (+ pax pbx)
          (+ pay pby))))

(def (mult (p : :pair) (n : :number)) => :pair
  (with (([px . py] p))
    (cons (* n px) (* n py))))

(def (is-xmas? (m : :list) (p : :pair) (v : :pair)) => :boolean
  (and
   (eq? #\X (at m (add p (mult v 0))))
   (eq? #\M (at m (add p (mult v 1))))
   (eq? #\A (at m (add p (mult v 2))))
   (eq? #\S (at m (add p (mult v 3))))))

(def (count-xmas (m : :list) (p : :pair)) => :integer
  (if (not (eq? #\X (at m p)))
    0
    (count (cut is-xmas? m p <>)
           '((-1 . -1)
             (-1 . 0)
             (-1 . 1)
             (0 . -1)
             (0 . 1)
             (1 . -1)
             (1 . 0)
             (1 . 1)))))

(def (part-one input)
  (with ([r . c] (dim input))
    (let (sum 0)
      (for* ((x (in-range r)) (y (in-range c)))
        (set! sum (+ sum (count-xmas input (cons x y)))))
      sum)))

(def (main . args)
  (pp
   (match args
      (["part-one" file-path]
       (part-one (read-file-lines file-path)))
      (else
       (error "part-one {{file-path}}")))))
