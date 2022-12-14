#lang racket
(require racket/block)
(define last-char 0)
(define next-char (lambda () (set! last-char (read-char (current-input-port)))))
(next-char)
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

(define (copytab tab len)
  (build-vector len (lambda (i) 
                      (vector-ref tab i)))
)

(define (bubblesort tab len)
  (letrec ([a (lambda (i) (if (<= i (- len 1))
                          (letrec ([b (lambda (j) (if (<= j (- len 1))
                                                  (if (> (vector-ref tab i) (vector-ref tab j))
                                                  (let ([tmp (vector-ref tab i)])
                                                  (block
                                                    (vector-set! tab i (vector-ref tab j))
                                                    (vector-set! tab j tmp)
                                                    (b (+ j 1))
                                                    ))
                                                  (b (+ j 1)))
                                                  (a (+ i 1))))])
                            (b (+ i 1)))
                          '()))])
    (a 0))
)

(define (qsort0 tab len i j)
  (if (< i j)
  (let ([i0 i])
  (let ([j0 j])
  ; pivot : tab[0] 
  (letrec ([c (lambda (i j) (if (not (eq? i j))
                            (if (> (vector-ref tab i) (vector-ref tab j))
                            (if (eq? i (- j 1))
                            ; on inverse simplement
                            (let ([tmp (vector-ref tab i)])
                            (block
                              (vector-set! tab i (vector-ref tab j))
                              (vector-set! tab j tmp)
                              (let ([i (+ i 1)])
                              (c i j))
                              ))
                            ; on place tab[i+1] à la place de tab[j], tab[j] à la place de tab[i] et tab[i] à la place de tab[i+1] 
                            (let ([tmp (vector-ref tab i)])
                            (block
                              (vector-set! tab i (vector-ref tab j))
                              (vector-set! tab j (vector-ref tab (+ i 1)))
                              (vector-set! tab (+ i 1) tmp)
                              (let ([i (+ i 1)])
                              (c i j))
                              )))
                            (let ([j (- j 1)])
                            (c i j)))
                            (block
                              (qsort0 tab len i0 (- i 1))
                              (qsort0 tab len (+ i 1) j0)
                              '()
                              )))])
    (c i j))))
  '())
)

(define main
  (let ([len 2])
  ((lambda (d) 
     (let ([len d])
     (block
       (mread-blank)
       (let ([tab (build-vector len (lambda (i_) 
                                      (let ([tmp 0])
                                      ((lambda (g) 
                                         (let ([tmp g])
                                         (block
                                           (mread-blank)
                                           tmp
                                           ))) (mread-int)))))])
     (let ([tab2 (copytab tab len)])
     (block
       (bubblesort tab2 len)
       (letrec ([e (lambda (i) (if (<= i (- len 1))
                               (block
                                 (printf "~a " (vector-ref tab2 i))
                                 (e (+ i 1))
                                 )
                               (block
                                 (display "\n")
                                 (let ([tab3 (copytab tab len)])
                                 (block
                                   (qsort0 tab3 len 0 (- len 1))
                                   (letrec ([f (lambda (i) (if (<= i (- len 1))
                                                           (block
                                                             (printf "~a " (vector-ref tab3 i))
                                                             (f (+ i 1))
                                                             )
                                                           (display "\n")))])
                                     (f 0))
                                   ))
                                 )))])
         (e 0))
       )))
     ))) (mread-int)))
)

