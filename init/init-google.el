(defun gt (min max text &optional new-window)
  (interactive "r \nsWhat lang: \nP")
  (browse-apropos-url (concat "gt" text " " (buffer-substring min max)) new-window))

(setq apropos-url-alist
      '(("^gw?:? +\\(.*\\)" .  ;; Google Web
         "http://www.google.com/search?q=\\1")
        ("^gn:? +\\(.*\\)" .   ;; Google News
         "http://news.google.com/news?sa=N&tab=dn&q=\\1")
        ("^gtru:? +\\(.*\\)" . ;; Google Translate Text (ru->en)
         "http://translate.google.com/translate_t?langpair=ru|en&text=\\1")
        ("^gten:? +\\(.*\\)" . ;; Google Translate Text (en->ru)
         "http://translate.google.com/translate_t?langpair=en|ru&text=\\1")
        ("^msdn:? +\\(.*\\)" . ;; Msdn
         "http://social.msdn.microsoft.com/Search/en-US/?query=\\1")
        ("^cpp:? +\\(.*\\)" .  ;; C reference
         "http://www.cplusplus.com/query/search.cgi?q=")))

(defun google-get-history-search (&optional arg)
  "Getting search history from google service.
ARG how many page you have read, default 5 page"
  (interactive "P")
  (let* ((arg (or arg "5"))
         ;; TODO: rewrite python script to elisp
         ;; http://emacspeak.googlecode.com/svn/trunk/lisp/g-client/
         (cmd (format "python ~/scratches/py/getsearch.py %s 2>&1 | cat > /tmp/googlehist" arg)))
    (message "getting %s fileds" arg)
    (shell-command cmd)
    (switch-to-buffer "*Google History*")
    (kill-region (point-min) (point-max))
    (insert-file "/tmp/googlehist")))

(defun google-get-mail (&optional arg)
  "Getting mail from gmail.
ARG how many messages you will be read if ARG 0 get mail info
default read last 5 msg"
  (interactive "P")
  (let* ((arg (or arg "5"))
         ;; TODO: rewrite python script to elisp
         ;; http://emacspeak.googlecode.com/svn/trunk/lisp/g-client/
         (cmd (format "python ~/scratches/py/getmail.py %s 2>&1 | cat > /tmp/googlemail" arg)))
    (message "getting %s msg" arg)
    (shell-command cmd)
    (switch-to-buffer "*Google Mail*")
    (kill-region (point-min) (point-max))
    (insert-file "/tmp/googlemail")))
