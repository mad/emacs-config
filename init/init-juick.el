(add-to-list 'load-path "~/git/emacs-juick-el/")
(require 'juick)

(add-hook 'jabber-chat-mode-hook 'goto-address)
(setq juick-icon-mode t)
(setq juick-reply-id-add-plus t)
(setq juick-tag-subscribed '("emacs" "vim" "juick.el"))
(setq juick-auto-subscribe-list '("emacs" "vim" "juick.el"))
(juick-auto-update)

