
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
(defun mread-blank () (progn
  (while (or (eq last-char #\NewLine) (eq last-char #\Space) ) (next-char))
))

(progn
  (let
   ((str (array_init
            12
            (function (lambda (a)
            (block lambda_1
              (let ((b (mread-char )))
                (return-from lambda_1 b)
              )))
            ))))
  (mread-blank)
  (do
    ((i 0 (+ 1 i)))
    ((> i 11))
    (princ (aref str i))
  )
  ))


