(require 'url)
(require 'url-util)

(defun codepad-detect-lang ()
  "detect codepad's lang parameter from current major mode"
  (let ((mode-list '(("c-mode" . "C")
                     ("c++-mode" . "C++")
                     ("d-mode" . "D")
                     ("haskell-mode" . "Haskell")
                     ("lua-mode" . "Lua")
                     ("ocaml-mode" . "Ocaml")
                     ("php-mode" . "PHP")
                     ("perl-mode" . "Perl")
                     ("cperl-mode" . "Perl")
                     ("python-mode" . "Python")
                     ("ruby-mode" . "Ruby")
                     ("scheme-mode" . "Scheme"))))
    (cdr (assoc (format "%s" major-mode) mode-list))))

(defun codepad-run-buffer ()
  "run codepad on current buffer"
  (interactive)
  (codepad-run (buffer-string)))

(defun codepad-run-region (begin end)
  "run codepad on current buffer"
  (interactive "r")
  (save-excursion
    (codepad-run (buffer-substring begin end))))

(defun codepad-run (code)
  "run code on codepad"
  (interactive
   (let ((lang (or (codepad-detect-lang) "Plain Text")))
     (list (read-string (format "Run Codepad (%s): " lang)))))
  (let ((url "http://codepad.org/")
        (url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data
         (concat "lang=" (or (codepad-detect-lang) "Plain Text")
                 "&code=" (url-hexify-string code)
                 "&run=True&submit=Submit"))
        (cb (lambda (status)
              (url-mark-buffer-as-dead (current-buffer))
              (let ((loc (plist-get status :redirect))
                    (err (plist-get status :error)))
                (if loc (codepad-result loc)
                  (if err (message (format "%s" err))
                    (message (buffer-string))))))))
    (url-retrieve url cb)))

(defun codepad-result (url)
  (interactive)
  (let ((cb (lambda (status)
              (url-mark-buffer-as-dead (current-buffer))
              (let ((raw (buffer-string)))
                (with-temp-buffer
                  (insert (decode-coding-string raw 'utf-8))
                  (beginning-of-buffer)
                  (if (re-search-forward "<a name=\"output\">\\(?:\\(?:[\r\n]\\|.\\)+?\\)<td width=\"100%\" valign=\"top\">\\(?:\\(?:[\r\n]\\|.\\)+?\\)<pre>\\(\\(?:[\r\n]\\|.\\)+?\\)</pre>" nil t)
                      (codepad-show-result (codepad-strip-tags (match-string 1)))
                    (message "no output found")))))))
    (url-retrieve url cb)))

(defun codepad-show-result (result)
  "show result in other window"
  (with-current-buffer (get-buffer-create "*codepad*")
    (insert result)
    (switch-to-buffer-other-window "*codepad*")))

(defun codepad-strip-tags (html)
  "strip alc html tags"
  (with-temp-buffer
    (insert html)
    (beginning-of-buffer)
    (replace-regexp "<.*?>" "")
    (beginning-of-buffer)
    (replace-string "&quot;" "\"")
    (beginning-of-buffer)
    (replace-string "&gt;" ">")
    (beginning-of-buffer)
    (replace-string "&lt;" "<")
    (beginning-of-buffer)
    (replace-string "&amp;" "&")
    (buffer-string)))

(provide 'codepad)
