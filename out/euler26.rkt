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

(define periode (lambda (restes len a b) 
                  (letrec ([e (lambda (restes len a b) 
                                (if (not (eq? a 0))
                                  (let ([chiffre (quotient a b)])
                                    (let ([reste (remainder a b)])
                                      (let ([h 0])
                                        (let ([k (- len 1)])
                                          (letrec ([f (lambda (i reste chiffre restes len a b) 
                                                        (if (<= i k)
                                                          (let ([g (lambda (reste chiffre restes len a b) 
                                                                    (f (+ i 1) reste chiffre restes len a b))])
                                                          (if (eq? (vector-ref restes i) reste)
                                                            (- len i)
                                                            (g reste chiffre restes len a b)))
                                                        (block
                                                          (vector-set! restes len reste)
                                                          (let ([len (+ len 1)])
                                                            (let ([a (* reste 10)])
                                                              (e restes len a b)))
                                                          )))])
                                        (f h reste chiffre restes len a b))))))
                    0))])
(e restes len a b))))
(define main (let ([c 1000])
               (let ([t_ (array_init_withenv c (lambda (j) 
                                                 (lambda (c) 
                                                   (let ([l 0])
                                                     (list c l)))) c)])
  (let ([m 0])
    (let ([mi 0])
      (let ([q 1])
        (let ([r 1000])
          (letrec ([n (lambda (i mi m c) 
                        (if (<= i r)
                          (let ([p (periode t_ 0 1 i)])
                            (let ([o (lambda (p mi m c) 
                                       (n (+ i 1) mi m c))])
                            (if (> p m)
                              (let ([mi i])
                                (let ([m p])
                                  (o p mi m c)))
                              (o p mi m c))))
                        (block
                          (display mi)
                          (display "\n")
                          (display m)
                          (display "\n")
                          )))])
        (n q mi m c)))))))))
