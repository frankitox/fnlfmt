(λ greet [name]
  "Returns a greeting for the given name."
  (.. "Hello, " name "!"))

;; fnlfmt: skip
(lambda print-greeting [greeting]
  "Prints a greeting."
  (print greeting))
