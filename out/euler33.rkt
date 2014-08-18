#lang racket
(require racket/block)

(define array_init_withenv (lambda (len f env)
  (build-vector len (lambda (i)
    (let ([o ((f i) env)])
      (block
        (set! env (car o))
        (cadr o)
      )
    )))))
(define last-char 0)
(define next-char (lambda () (set! last-char (read-char (current-input-port)))))
(next-char)
(define mread-char (lambda ()
  (let ([ out last-char])
    (block
      (next-char)
      out
    ))))

(define mread-int (lambda ()
  (if (eq? #\- last-char)
  (block
    (next-char) (- 0 (mread-int)))
    (letrec ([w (lambda (out)
      (if (eof-object? last-char)
        out
        (if (and last-char (>= (char->integer last-char) (char->integer #\0)) (<= (char->integer last-char) (char->integer #\9)))
          (let ([out (+ (* 10 out) (- (char->integer last-char) (char->integer #\0)))])
            (block
              (next-char)
              (w out)
          ))
        out
      )))]) (w 0)))))

(define mread-blank (lambda ()
  (if (or (eq? last-char #\NewLine) (eq? last-char #\Space) ) (block (next-char) (mread-blank)) '())
))

(define max2 (lambda (a b) 
               (let ([g (lambda (a b) 
                          '())])
               (if (> a b)
                 a
                 b))))
(define min2 (lambda (a b) 
               (let ([f (lambda (a b) 
                          '())])
               (if (< a b)
                 a
                 b))))
(define pgcd (lambda (a b) 
               (let ([c (min2 a b)])
                 (let ([d (max2 a b)])
                   (let ([reste (remainder d c)])
                     (let ([e (lambda (reste d c a b) 
                                '())])
                     (if (eq? reste 0)
                       c
                       (pgcd c reste))))))))
(define main (let ([top 1])
               (let ([bottom 1])
                 (let ([v 1])
                   (let ([w 9])
                     (letrec ([h (lambda (i bottom top) 
                                   (if (<= i w)
                                     (let ([s 1])
                                       (let ([u 9])
                                         (letrec ([l (lambda (j bottom top) 
                                                       (if (<= j u)
                                                         (let ([q 1])
                                                           (let ([r 9])
                                                             (letrec ([m 
                                                               (lambda (k bottom top) 
                                                                 (if (<= k r)
                                                                   (let ([n 
                                                                    (lambda (bottom top) 
                                                                    (m (+ k 1) bottom top))])
                                                                   (if (and (not (eq? i j)) (not (eq? j k)))
                                                                    (let ([a (+ (* i 10) j)])
                                                                    (let ([b (+ (* j 10) k)])
                                                                    (let ([o 
                                                                    (lambda (b a bottom top) 
                                                                    (n bottom top))])
                                                                    (if (eq? (* a k) (* i b))
                                                                    (block
                                                                    (display a)
                                                                    (display "/")
                                                                    (display b)
                                                                    (display "\n")
                                                                    (let ([top (* top a)])
                                                                    (let ([bottom (* bottom b)])
                                                                    (o b a bottom top)))
                                                                    )
                                                                    (o b a bottom top)))))
                                                                   (n bottom top)))
                                                               (l (+ j 1) bottom top)))])
                                                         (m q bottom top))))
                                         (h (+ i 1) bottom top)))])
                                   (l s bottom top))))
                   (block
                     (display top)
                     (display "/")
                     (display bottom)
                     (display "\n")
                     (let ([p (pgcd top bottom)])
                       (block
                         (display "pgcd=")
                         (display p)
                         (display "\n")
                         (display (quotient bottom p))
                         (display "\n")
                         ))
                     )))])
  (h v bottom top)))))))
