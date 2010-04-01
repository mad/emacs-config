(add-to-list 'load-path "~/.emacs.d/elisp/apel")
(load-file "~/.emacs.d/elisp/elscreen.el")

(setq elscreen-display-tab nil)
(define-key elscreen-map (kbd "SPC") 'elscreen-next)
(define-key elscreen-map (kbd "C-z") 'elscreen-swap)

;;; Conflict with elscreen
;; (global-set-key "\C-z" nil)


