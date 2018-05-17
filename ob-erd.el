(require 'ob)

(defcustom org-erd-executable-path "erd"
  "Path to the erd executable."
  :group 'org-babel
  :type 'stirng)

(defun org-babel-erd-make-body (body params)
  (org-babel-expand-body:generic body params))

(defun org-babel-execute:erd (body params)
  "Execute a block of erd code with org-babel.
This function is called by `org-babel-execute-src-block'."
  (let* ((tmp-out-file (make-temp-file "ob-erd"))
         (tmp-file (make-temp-file "ob-erd"))
         (out-file (or (cdr (assq :file params))
                       (error "erd requires a \":file\" header argument"))))

    (org-babel-process-file-name tmp-file)
    (org-babel-process-file-name tmp-out-file)
    (org-babel-process-file-name out-file)

    (with-temp-file tmp-file
      (insert body))

    (org-babel-eval (format "%s -i %s -o %s"
                            org-erd-executable-path
                            tmp-file
                            tmp-out-file)
                    "")

    (org-babel-eval (format "convert %s %s" tmp-out-file out-file) "")
    nil))

(provide 'ob-erd)
