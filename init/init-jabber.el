(add-to-list 'load-path "~/.emacs.d/elisp/jabber")

(require 'jabber)

(setq jabber-show-offline-contacts nil)
(setq jabber-roster-show-title nil)
(setq jabber-roster-show-empty-group nil)
(setq jabber-roster-show-bindings nil)
(setq jabber-auto-reconnect t)
;; (setq jabber-history-enabled t)
;; (setq jabber-use-global-history nil)


(defun jabber-message-osd (from buffer text proposed-alert)
  "Display a message using the osd_cat program."
  (let ((jid (substring from 0 (string-match "/" from))))
    (if (not (string-match jid (buffer-name (window-buffer (selected-window)))))
        (let* ((notify-msg (concat "Message from "
                                   (substring jid 0 (string-match "@" jid))))
               (offset (number-to-string (- 500 (* (length notify-msg) 4)))))
          (setq osd-program-args `("--pos" "top"
                                   "--align" "center"
                                   "--colour" "blue"
                                   "--indent" ,offset
                                   "--delay" "3"
                                   "--offset" "-3"
                                   "--font"
                                   "-adobe-times-medium-r-normal--34-240-100-100-p-170-iso8859-1"))
          (osd-show-string notify-msg)))))

(defun jabber-message-notify (from buffer text proposed-alert)
  "Display a message using the osd_cat program."
  (let ((jid (substring from 0 (string-match "/" from))))
    (if (not (string-match jid (buffer-name (window-buffer (selected-window)))))
        (let* ((notify-msg (concat "Message from "
                                   (substring jid 0 (string-match "@" jid))))
               (offset (number-to-string (- 500 (* (length notify-msg) 4)))))
          (jabber-libnotify-message notify-msg)))))

(require 'jabber-libnotify)
(setq jabber-libnotify-icon "/usr/share/icons/hicolor/128x128/apps/emacs.png")
(setq jabber-libnotify-timeout 10000)

(add-hook 'jabber-alert-message-hooks 'jabber-message-notify)
(add-hook 'jabber-chat-mode-hook 'auto-fill-mode)

(define-key jabber-chat-mode-map "\C-ct"
  '(lambda()
     (interactive)
     (save-excursion
       (tiny-url-replace jabber-point-insert))))
