;;; ob-erd.el --- Babel functions for erd. -*- lexical-binding: t -*-

;; Author: Hector Orellana <hofm92@gmail.com>
;; Package-Version: 0.07
;; URL: https://github.com/orimh/ob-erd

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package enables you to generate diagrams using erd and imagemagick.
;; It first creates a pdf file with erd and then using imagemagick's convert it converts the
;; pdf file to png, so it can be inlined on a org file

;;; Requirements:

;; erd         | https://github.com/BurntSushi/erd/
;; imagemagick | https://www.imagemagick.org/script/index.php

;;; Code:
(require 'ob)

(defcustom ob-erd-executable-path "erd"
  "Path to the erd executable."
  :group 'org-babel
  :type 'string)

(defcustom ob-erd-imagemagick-convert-executable-path "convert"
  "Path to imagemagick's convert executable."
  :group 'org-babel
  :type 'string)

;;;###autoload
(defun org-babel-execute:erd (body params)
  "Execute a block of erd code in BODY with org-babel.
Takes a file path from PARAMS.
This function is called by `org-babel-execute-src-block'."
  (let* ((tmp-out-file (make-temp-file "ob-erd"))
         (tmp-file (make-temp-file "ob-erd"))
         (out-file (or (cdr (assq :file params))
                       (error "Erd requires a \":file\" header argument")))

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
