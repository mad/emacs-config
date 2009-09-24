(add-to-list 'load-path "~/.emacs.d/elisp/company/")

(require 'company)

(add-hook 'c-mode-common-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'company-mode)

