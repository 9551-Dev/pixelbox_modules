(defun init (box module api share initialized? load-flags)
  "This is the function in charge of creating your module, the inputs are:
   BOX is the object that pixelbox:new returns
   MODULE is your module data, like the id and name
   API is the pixelbox module
   SHARE is a table which is used for shared state
   INITIALIZED? is bullshit, ignore it
   LOAD-FLAGS are extra values passed in the modules table. why?
   It returns two tables:
   one with data that will be inserted into the pixelbox object
   and the second with callbacks, you can find them in the code"
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
