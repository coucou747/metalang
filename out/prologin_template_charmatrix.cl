
(si::use-fast-links nil)
(defun array_init (len fun)
  (let ((out (make-array len)) (i 0))
    (while (not (= i len))
      (progn
        (setf (aref out i) (funcall fun i))
        (setq i (+ 1 i ))))
        out
    ))(let ((last-char 0)))
(defun next-char () (setq last-char (read-char *standard-input* nil)))
(next-char)
(defun mread-char ()
  (let (( out last-char))
    (progn
      (next-char)
      out
    )))
(defun mread-int ()
  (if (eq #\- last-char)
  (progn (next-char) (- 0 (mread-int)))
  (let ((out 0))
    (progn
      (while (and last-char (>= (char-int last-char) (char-int #\0)) (<= (char-int last-char) (char-int #\9)))
        (progn
          (setq out (+ (* 10 out) (- (char-int last-char) (char-int #\0))))
          (next-char)
        )
      )
      out
    ))))
(defun mread-blank () (progn
  (while (or (eq last-char #\NewLine) (eq last-char #\Space) ) (next-char))
))

(defun programme_candidat (tableau taille_x taille_y)
(progn
  (let ((out0 0))
    (do
      ((i 0 (+ 1 i)))
      ((> i (- taille_y 1)))
      (progn
        (do
          ((j 0 (+ 1 j)))
          ((> j (- taille_x 1)))
          (progn
            (setq out0 ( + out0 (* (char-int (aref (aref tableau i) j)) (+ i (* j 2)))))
            (princ (aref (aref tableau i) j))
          )
        )
        (princ "--
")
      )
    )
    (return-from programme_candidat out0)
  )))

(progn
  (let ((taille_x (mread-int )))
    (mread-blank)
    (let ((taille_y (mread-int )))
      (mread-blank)
      (let
       ((a (array_init
              taille_y
              (function (lambda (b)
              (block lambda_1
                (let
                 ((d (array_init
                        taille_x
                        (function (lambda (e)
                        (block lambda_2
                          (let ((c (mread-char )))
                            (return-from lambda_2 c)
                          )))
                        ))))
                (mread-blank)
                (return-from lambda_1 d)
                )))
              ))))
      (let ((tableau a))
        (princ (programme_candidat tableau taille_x taille_y))
        (princ "
")
      )))))


