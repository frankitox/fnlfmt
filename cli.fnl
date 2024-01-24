(local fennel (require :fennel))

(set debug.traceback fennel.traceback)

(local {: format-file : version} (require :fnlfmt))

(fn help []
  (print "Usage: fnlfmt [--no-comments] [--fix] FILENAME...")
  (print "With the --fix argument, multiple files can be specified")
  (print "and changes are made in-place; otherwise prints the")
  (print "formatted file to stdout."))

(local options [])

(for [i (length arg) 1 -1]
  (when (= :--no-comments (. arg i))
    (set options.no-comments true)
    (table.remove arg i)))

(fn fix [filename]
  (let [new (format-file filename options)
        f (assert (io.open filename :w))]
    (f:write new)
    (f:close)))

(match arg
  [:--version] (print (.. "fnlfmt version " version))
  [:--fix & filenames] (each [_ filename (pairs filenames)] (fix filename))
  (where (or [:--help] ["-?"] [:-h])) (help)
  [filename nil] (io.stdout:write (format-file filename options))
  _ (help))
