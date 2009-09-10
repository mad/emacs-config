(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet/")

(require 'yasnippet)
(require 'dropdown-list)

;; (setq yas/prompt-functions '(yas/dropdown-prompt
;;                               yas/ido-prompt
;;                               yas/completing-prompt))

(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/")
(yas/load-directory "~/.emacs.d/elisp/yasnippet/snippets/")
