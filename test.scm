(define add  (lambda (a b)    (+ a b)))(add 3 4)
(define (sub a b) (- a b  )) (sub     3 4)

(define (> a b)
  (if (eq? a b)
      #f
      (if (< a b)
          #f
          #t)))
(> 10 -2)

(define (fact x)
  (if (eq? x 1)
      1
      (* x (fact (- x 1)))))
(fact 10)
