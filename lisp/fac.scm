(define add  (lambda (a b)    (+ a b)))(add 3 4)
(define fac (lambda (n) (if (eq? n 0) 1 (* n (fac (- n 1))))))(fac 5)
