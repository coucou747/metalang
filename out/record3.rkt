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

(struct toto ([bar #:mutable] [blah #:mutable] [foo #:mutable]))
(define mktoto (lambda (v1) 
                 (let ([t_ (toto 0 0 v1)])
                   t_)))
(define result (lambda (t_ len) 
                 (let ([out_ 0])
                   (let ([c 0])
                     (let ([d (- len 1)])
                       (letrec ([b (lambda (j out_ t_ len) 
                                     (if (<= j d)
                                       (block
                                         (set-toto-blah! (vector-ref t_ j) (+ (toto-blah (vector-ref t_ j)) 1))
                                         (let ([out_ (+ (+ (+ out_ (toto-foo (vector-ref t_ j))) (* (toto-blah (vector-ref t_ j)) (toto-bar (vector-ref t_ j)))) (* (toto-bar (vector-ref t_ j)) (toto-foo (vector-ref t_ j))))])
                                           (b (+ j 1) out_ t_ len))
                                         )
                                       out_))])
                       (b c out_ t_ len)))))))
(define main (let ([a 4])
               (let ([t_ (array_init_withenv a (lambda (i) 
                                                 (lambda (a) 
                                                   (let ([e (mktoto i)])
                                                     (list a e)))) a)])
  ((lambda (g) 
     (block
       (set-toto-bar! (vector-ref t_ 0) g)
       (block (mread-blank) ((lambda (f) 
                               (block
                                 (set-toto-blah! (vector-ref t_ 1) f)
                                 (let ([titi (result t_ 4)])
                                   (block
                                     (display titi)
                                     (display (toto-blah (vector-ref t_ 2)))
                                     ))
                                 )) (mread-int)) )
     )) (mread-int)))))
