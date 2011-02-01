(require 'c-eldoc)
(which-func-mode)

;; highlight FIXME, TODO and XXX as warning in some major modes
(dolist (mode '(c-mode
                java-mode
                cperl-mode
                html-mode-hook
                sh-mode
                css-mode-hook
                emacs-lisp-mode))
  ;; highlight additional keywords
  (font-lock-add-keywords mode '(("\\(XXX\\|FIXME\\|TODO\\|BUG\\):"
                                  1 font-lock-warning-face t))))
;; highlight too long lines
;; (font-lock-add-keywords mode '(("^[^\n]\\{90\\}\\(.*\\)$"
;;                                 1 font-lock-warning-face t))))

(add-hook 'sh-mode-hook '(lambda ()
                           (interactive)
                           (require 'skeleton)
                           (setq skeleton-pair (not skeleton-pair))))

;; hook for wrap text mode
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook
          (lambda()
            (set-fill-column 78)
            (auto-fill-mode t)))

