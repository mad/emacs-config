;;; Keybindings
(global-set-key "\C-c\C-u" 'browse-url-at-point)
;;; Conflict with elscreen
;; (global-set-key "\C-z" nil)
(global-set-key "\C-xh" 'mark-whole-buffer)
(global-set-key "\C-x\C-d" 'dired)
(global-set-key "\C-xd" 'dired)
(global-set-key [(pause)] 'remember)
(global-set-key "\C-x\C-b" 'bs-show)
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
(global-set-key [(control tab)] `other-window)
(global-set-key "\C-cu" 'browse-apropos-url)
(global-set-key "\M-g" 'goto-line)
(define-key global-map [(control x) (control c)]
  '(lambda () (interactive)
     (cond ((y-or-n-p "Quit editor? ")
            (save-buffers-kill-emacs)))))
(define-key global-map (kbd "C-S-<left>") 'shrink-window-horizontally)
(define-key global-map (kbd "C-S-<right>") 'enlarge-window-horizontally)
(define-key global-map (kbd "C-S-<up>") 'enlarge-window)
(define-key global-map (kbd "C-S-<down>") 'shrink-window)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

(global-set-key [f1] 'woman)
;; f2 - use
;; f3 - use
;; f4 - use

(global-set-key [f5] '(lambda()
                        "Remove all local mark"
                        (interactive)
                        (setq mark-ring nil)))

;;(global-set-key [f6] ')
(global-set-key [f7] 'replace-string)
(global-set-key [f8] 'replace-regexp)

(global-set-key [f9] 'compile)
;; (global-set-key [f10] ')
(global-set-key [f11] 'flyspell-mode)
(global-set-key [f12] 'recover-this-file)

;; (global-set-key [S-f1] ')
;; (global-set-key [S-f2] ')
;; (global-set-key [S-f3] ')
;; (global-set-key [S-f4] ')

(global-set-key [S-f5] '(lambda ()
                           (interactive)
                           (revert-buffer-with-coding-system 'cp1251 t)))
(global-set-key [S-f6] 'find-file-at-point)
;; (global-set-key [S-f7] ')
;; (global-set-key [S-f8] ')

;; (global-set-key [S-f9] ')
(global-set-key [S-f10] 'kill-buffer)
(global-set-key [S-f11] 'bury-buffer)
(global-set-key [S-f12] 'revert-buffer)

(global-set-key "\C-x/" 'hippie-expand)
(global-set-key "\C-ctr" '(lambda (min max)
                            (interactive "r")
                            (gt min max "en")))

;; From emacs starter-kit
(global-set-key (kbd "C-x \\") 'align-regexp)
(global-set-key "\C-cg"
                '(lambda()
                   (interactive)
                   (browse-url (concat
                                "http://www.google.com/search?q="
                                (url-hexify-string (current-word t))))))

(global-set-key (kbd "C-c C-SPC") 'push-mark-command)
(global-set-key (kbd "M-`") 'other-frame)