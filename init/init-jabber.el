(add-to-list 'load-path "~/.emacs.d/elisp/jabber")

(require 'jabber)

(setq jabber-show-offline-contacts nil)
(setq jabber-roster-show-title nil)
(setq jabber-roster-show-empty-group nil)
(setq jabber-roster-show-bindings nil)
(setq jabber-auto-reconnect t)
;; (setq jabber-history-enabled t)
;; (setq jabber-use-global-history nil)

(defadvice jabber-fix-status (around jabber-fix-status-around-advice
                                     (status) activate)
  ad-do-it
  (setq ad-return-value (concat "\n     " status)))


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

(add-hook 'jabber-alert-message-hooks 'jabber-message-osd)

(define-key jabber-chat-mode-map "\C-ct"
  '(lambda()
     (interactive)
     (save-excursion
       (tiny-url-replace jabber-point-insert))))
