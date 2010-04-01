(defun remove-elc-on-save ()
  "If you're saving an elisp file, likely the .elc is no longer valid."
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))))
(add-hook 'emacs-lisp-mode-hook 'remove-elc-on-save)

(defun my-elisp-mode-hook ()
  (show-paren-mode t)
  (setq show-trailing-whitespace t)
  (setq indent-tabs-mode nil)
  (local-set-key "\C-c m" 'mark-sexp) ;; Yes, this space
  (local-set-key "\C-x \C-j" 'eval-print-last-sexp)
  (local-set-key "\r" 'reindent-then-newline-and-indent)
  (local-set-key "\M-." 'find-function)
  (local-set-key "\C-c;" 'comment-or-uncomment-region)
  (eldoc-mode))
(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)

