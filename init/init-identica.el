(add-to-list 'load-path "~/.emacs.d/elisp/identica-mode/")

(require 'identica-mode)
(global-set-key "\C-cip" 'identica-update-status-interactive)
(global-set-key "\C-cii" 'identica)
(global-set-key "\C-cid" 'identica-direct-message-interactive)

