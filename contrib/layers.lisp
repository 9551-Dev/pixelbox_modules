(import core/base (get-idx))

(defun .>? (x &keys)
  (loop [(keys keys)
         (out x)]
    [(or (= nil out) (= nil (car keys))) out]
    (recur (cdr keys) (.> out (car keys)))))

(defun find-index-rev (p xs)
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(= i 0) nil]
                  [(p (nth xs i)) i]
                  [else (fun (- i 1))])))
    (fun len)))

(define layers (setmetatable '()
                 {:__newindex (lambda (self idx v)
                   (.<! self :n (len# self)))}))

(defun index-y (y)
  (let* ((index (lambda (_ x)
                  (let* ((find-layer (lambda (t) (/= (.>? t y x) nil)))
                         (layer (find-index-rev find-layer layers)))
                    (.> layers layer y x)))))
    (setmetatable {} {:__index index})))

(defun make-mt (y)
  {:__index (index-y y)
   :__newindex (lambda (_ x val)
                 (.<! layers 1 y x val))})

(defun init (box module api share initialized? load-flags)
  (let* ((height (.> box :height))
         (width (.> box :width))
         (lines (range :from 1 :to height))
         (make-line (lambda (y)
                      (setmetatable {} (make-mt y))))
         (canvas (map make-line lines)))
    (push! layers (.> box :canvas))
    (.<! box :canvas canvas)
    { :layers layers }))

{
  :init init

  :id :layers
  :name "Multilayer support"
  :author "viwty"
  :contact "viwty@discord or viwty@cock.li"
  :report_msg "\n__name: complain over at __contact"
}
