(require 'cc-mode)

(defun my-c-mode-common-hook ()
  (auto-fill-mode 1)
  (hs-minor-mode 1)
  (c-set-style "gnu")
  (setq c-basic-offset 2
        show-trailing-whitespace t
        comment-style 'extra-line
        c-toggle-hungry-state 1)
  (local-set-key "\C-cm" '(lambda()
			    (interactive)
			    (woman (current-word t))))
  (local-set-key "\C-cf"
                 '(lambda()
                    (interactive)
                    (browse-url (concat
                                 "http://www.cplusplus.com/query/search.cgi?q="
                                 (current-word t)))))
  (local-set-key "\C-c4"
                 '(lambda()
                    (interactive)
                    (browse-url (concat
                                 "http://social.msdn.microsoft.com/Search/en-US/?query="
                                 (current-word t))))))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

