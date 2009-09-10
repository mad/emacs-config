(add-to-list 'load-path "~/.emacs.d/elisp/")
(add-to-list 'load-path "~/.emacs.d/")

(server-start)

(cond ((assoc-string system-name '(home home.mad localhost))
       (progn
         (set-default-font "Monospace-12")
         (add-to-list 'default-frame-alist '(font . "Monospace-12"))
         (setq initial-frame-alist default-frame-alist)
         (setq special-display-frame-alist default-frame-alist)))
      ((assoc-string system-name '(eeepc eeepc.mad))
       (progn
         (set-foreground-color "gray85")
         (set-background-color "gray25")
         (set-cursor-color "red3")
         ;;(require 'color-theme)
         (set-default-font "-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1")
         (add-to-list 'default-frame-alist '(font .
                                                  "-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1"))
         (setq initial-frame-alist default-frame-alist)
         (setq special-display-frame-alist default-frame-alist)
         (setq make-backup-files nil)
         (display-battery-mode)
         (custom-set-variables '(battery-mode-line-format "[%t(%b%p%%),%d°C]"))))
      ((eq system-type 'windows-nt)
       (progn
         (setq exec-path (cons "D:/cygwin/bin" exec-path))
         (setq shell-file-name "D:/cygwin/bin/bash.exe")
         (setenv "SHELL" shell-file-name)
         (setenv "PS1" "\\u:\\w$ ")
         (setenv "PATH" (concat (getenv "PATH") ";D:\\cygwin\\bin"))
         (setq explicit-shell-args '("--login" "-i"))
         (setq Info-default-directory-list (append Info-default-directory-list
                                                   (list "D:/cygwin/usr/info/")))
         (setq ange-ftp-ftp-program-name "D:/opt/ftp.exe")
         (setq process-coding-system-alist
               (cons '("bash" . (cp1251 . raw-text-unix)) process-coding-system-alist))

         (set-default-font "Courier New-11"))))

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(setq echo-keystrokes 0.01)
(fset 'yes-or-no-p 'y-or-n-p)
(global-font-lock-mode t)
(blink-cursor-mode -1)
(setq x-select-enable-clipboard t)
(setq frame-title-format "%b")
(line-number-mode 1)
(column-number-mode 1)
(setq-default mode-line-buffer-identification
              (cons
               '(:eval (replace-regexp-in-string "^.*/\\(.*\\)/" "\\1/" default-directory))
               mode-line-buffer-identification))

(require 'desktop)
;;(desktop-save-mode)
(setq desktop-save t)
(setq desktop-path '("~/"))
(add-to-list 'desktop-locals-to-save 'buffer-file-coding-system)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control nil)
(setq safe-local-variable-values (quote ((buffer-read-only . 1))))

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

(require 'tramp)
(tramp-set-completion-function "ftp"
                               '((tramp-parse-rhosts "~/.rhosts")))

(require 'saveplace)
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)

(require 'jit-lock)                   ; enable JIT to make font-lock faster
(setq jit-lock-stealth-time 1)        ; new with emacs21

(delete-selection-mode)
(transient-mark-mode 1)
(partial-completion-mode t)
;; (winner-mode)
;; (global-set-key [(shift f9)] 'winner-undo)
;; (global-set-key [(shift f10)] 'winner-redo)

(cua-mode)
(setq cua-enable-cua-keys nil)

(recentf-mode)
(global-set-key "\C-cr" 'recentf-open-files)
(setq recentf-max-saved-items 200)

(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)

(setq auto-mode-alist
      (append
       '(("\\.rar\\'" . archive-mode))
       '(("\\.ear\\'" . archive-mode))
       '(("\\.sar\\'" . archive-mode))
       auto-mode-alist))

(setq compilation-finish-function
      (lambda (buf str)
        (switch-to-buffer buf)
        (goto-char (point-min))
        (if (string-match "exited abnormally" str)
            (message "compilation errors, press C-x ` to visit")
          (if (not (re-search-forward "mode: grep;" nil t))
              (progn
                ;; (run-at-time 1.5 nil 'delete-windows-on buf)
                (message "No compilation errors!")))))
      compilation-window-height 15)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-vertically)

(setq calendar-week-start-day 1)
(setq european-calendar-style 't)

;; Hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'before-save-hook 'time-stamp)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
