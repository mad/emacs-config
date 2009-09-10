(add-to-list 'load-path "~/git/emacs-juick-el/")
(require 'juick)

(add-hook 'jabber-chat-mode-hook 'goto-address)
(setq juick-icon-mode t)
(setq juick-reply-id-add-plus t)
(setq juick-tag-subscribed '("linux" "juick" "jabber" "emacs" "vim" "juick.el"))
(setq juick-auto-subscribe-list '("linux" "emacs" "vim" "juick" "ugnich" "juick.el"))
(juick-auto-update t)

