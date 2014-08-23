
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

(defun programme_candidat (tableau taille)
(progn
  (let ((out_ 0))
    (do
      ((i 0 (+ 1 i)))
      ((> i (- taille 1)))
      (setq out_ ( + out_ (aref tableau i)))
    )
    (return-from programme_candidat out_)
  )))

(progn
  (let ((b (mread-int )))
    (mread-blank)
    (let ((taille b))
      (let
       ((d (array_init
              taille
              (function (lambda (e)
              (block lambda_1
                (let ((f (mread-int )))
                  (mread-blank)
                  (return-from lambda_1 f)
                )))
              ))))
      (let ((tableau d))
        (princ (programme_candidat tableau taille))
        (princ "
")
      )))))


