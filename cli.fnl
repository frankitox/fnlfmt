(local fennel (require :fennel))

(set debug.traceback fennel.traceback)

(local {: format-file : version} (require :fnlfmt))

(fn help []
  (print "Usage: fnlfmt [--no-comments] [--fix] [--check] FILENAME...")
  (print "With the --fix or --check argument, multiple files can be specified.")
  (print "With the --fix argument, formats all the files in-place;")
  (print "with the --check argument, only checks if all the files are formatted;")
  (print "otherwise prints the formatted file to stdout."))

(local options [])

(for [i (length arg) 1 -1]
  (when (= :--no-comments (. arg i))
    (set options.no-comments true)
    (table.remove arg i)))

(fn check-file [filename]
  (let [old (with-open [in (assert (io.open filename))] (in:read :*a))
        new (format-file filename options)]
    (or (= old new)
        (do
          (io.stderr:write (string.format "Not formatted: %s\n" filename))
          false))))

(fn check-files [filenames]
  (-> (accumulate [ok? true _ filename (ipairs filenames)]
        (and (check-file filename) ok?))
      (#(if $ 0 1))
      (os.exit)))

(fn fix [filename]
  (let [new (format-file filename options)
        f (assert (io.open filename :w))]
    (f:write new)
    (f:close)))

(match arg
  [:--version] (print (.. "fnlfmt version " version))
  [:--fix & filenames] (each [_ filename (pairs filenames)] (fix filename))
  [:--check & filenames] (check-files filenames)
  (where (or [:--help] ["-?"] [:-h])) (help)
  [filename nil] (io.stdout:write (format-file filename options))
  _ (help))
