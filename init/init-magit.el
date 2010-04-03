(add-to-list 'load-path "~/.emacs.d/elisp/magit")
(require 'magit)
(global-set-key "\C-xgs" 'magit-status)
(global-set-key "\C-xgl" 'magit-log)

