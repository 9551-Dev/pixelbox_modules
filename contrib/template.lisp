(defun init (box module api share initialized? load-flags)
  (let ((hello (lambda ()
                 (print! "Hello, world!")))
         (verified-load (lambda ()
                          (print! "Example loaded"))))
    (values-list {:hello hello} {:verified_load verified-load})))

{
  :init init

  :id :urn-example
  :name "Urn Example"
  :author "pixelbox enjoyer"
  :contact "pixelboxenjoyer@cumallover.me"
  :report_msg "\n__name: complain over at __contact"
}
