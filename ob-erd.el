(require 'ob)

(defcustom org-erd-executable-path "erd"
  "Path to the erd executable."
  :group 'org-babel
  :type 'stirng)

(defcustom org-imagemagick-convert-executable-path "convert"
  "Path to imagemagick's convert executable."
  :group 'org-babel
  :type 'string)

;;;###autoload
(defun org-babel-execute:erd (body params)
  "Execute a block of erd code with org-babel.
This function is called by `org-babel-execute-src-block'."
  (let* ((tmp-out-file (make-temp-file "ob-erd"))
         (tmp-file (make-temp-file "ob-erd"))
         (out-file (or (cdr (assq :file params))
                       (error "erd requires a \":file\" header argument")))

         (erd-cmd (format "%s -i %s -o %s"
                            org-erd-executable-path
                            tmp-file
                            tmp-out-file))

         (convert-cmd (format "%s %s %s"
                            org-imagemagick-convert-executable-path
                            tmp-out-file
                            out-file)))

    (org-babel-process-file-name tmp-file)
    (org-babel-process-file-name tmp-out-file)
    (org-babel-process-file-name out-file)

    (with-temp-file tmp-file
      (insert body))

    (org-babel-eval erd-cmd "")
    (org-babel-eval convert-cmd "")

    nil))

(provide 'ob-erd)
;;; ob-erd.el ends here
