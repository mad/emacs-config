(defun my-auth-info ()
  (interactive)
  (save-excursion
    (find-file "~/.emacs.d/private.el")
    (eval-buffer)
    (kill-buffer)))

(if (assoc-string system-name '(home.mad home))
    (my-auth-info))
