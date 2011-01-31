;;; Some func

(defun template-insert (template &rest words)
  (interactive (list (read-string "Type template: ")
                     (read-string "Type word: ")))
  (dolist (x (apply 'list words))
    (insert (format template x))))

(defun sudo-edit-current-file ()
  (interactive)
  (find-alternate-file (concat "/sudo:root@localhost:" (buffer-file-name (current-buffer)))))

;;; TEST future
;;; Thx http://nflath.com/2009/08/autoindentation/
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

(defadvice yank-pop (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

(defun define-trivial-mode (mode-prefix file-regexp &optional command)
  (or command (setq command mode-prefix))
  (let ((mode-command (intern (concat mode-prefix "-mode"))))
    (fset mode-command
          `(lambda ()
             (interactive)
             (toggle-read-only t)
   	     (start-process ,mode-prefix nil
   			    ,command (buffer-file-name))
   	     (let ((obuf (other-buffer (current-buffer) t))
   		   (kbuf (current-buffer)))
   	       (set-buffer obuf)
   	       (kill-buffer kbuf))))
    (add-to-list 'auto-mode-alist (cons file-regexp mode-command))))

(define-trivial-mode "gv" "\\.ps$")
(define-trivial-mode "gv" "\\.eps$")
(define-trivial-mode "xpdf" "\\.pdf$")
(define-trivial-mode "xdvi" "\\.dvi$")
(define-trivial-mode "djview" "\\.djvu$")
(define-trivial-mode "mplayer" "\\.mp3$")
(define-trivial-mode "ods" "\\.ods$" "oocalc")
(define-trivial-mode "swriter" "\\.doc$")
(define-trivial-mode "swriter" "\\.DOC$")

;; Use M-backspace or C-backspace for kill word
(defun my-delete-word-or-kill-region (arg)
  (interactive "p")
  (if (and transient-mark-mode mark-active)
      (kill-region (point) (mark))
    (delete-region (point) (progn (backward-word arg) (point)))))
(global-set-key "\C-w" 'my-delete-word-or-kill-region)

;; bury needed buffer instead of kill it
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (assoc-string (if (bufferp buffer-to-kill)
			  (buffer-name buffer-to-kill)
			buffer-to-kill) '("*Messages*" "*scratch*"))
        (bury-buffer)
      ad-do-it)))


(defun my-truncate ()
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t)))

(defun my-insert-date ()
  (interactive)
  (insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))

(defun  print-elements-of-list (list)
  "Print each element of LIST on a line of its own."
  (while list
    (print (car list))
    (setq list (cdr list))))

(defun edit-dot-emacs ()
  "Load the .emacs file into a buffer for editing."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-8")  'edit-dot-emacs)

(defun edit-init-emacs ()
  (interactive)
  (ido-file-internal ido-default-file-method 'find-file  "~/.emacs.d/init"))

(global-set-key (kbd "C-9")  'edit-init-emacs)

;; split window and run shell
;; (defun set-shell()
;;   (interactive)
;;   (if (not (eq (count-windows) 1))
;;       (delete-other-windows))
;;   (split-window-vertically)
;;   (enlarge-window 10)
;;   (other-window 1)
;;   (if (equal "*ansi-term*" (buffer-name))
;;       (call-interactively 'rename-buffer)
;;     (if (get-buffer "*ansi-term*")
;;         (switch-to-buffer "*ansi-term*")
;;       (ansi-term "/bin/bash")))
;;   (other-window 1))
;; (global-set-key [(f3)] 'set-shell)

(defun browse-apropos-url (text &optional new-window)
  (interactive (browse-url-interactive-arg "Location: "))
  (let ((text (replace-regexp-in-string
               "^ *\\| *$" ""
               (replace-regexp-in-string "[ \t\n]+" " " text))))
    (let ((url (assoc-default text apropos-url-alist
                              '(lambda (a b)
                                 (let () (setq __braplast a) (string-match a b)))
                              text)))
      (browse-url (replace-regexp-in-string __braplast url text) new-window))))

(autoload 'browse-url-interactive-arg "browse-url")

(defun untabify-buffer ()
  "Untabify the whole (accessible part of the) current buffer"
  (interactive)
  (save-excursion (untabify (point-min) (point-max))))

(defun indent-buffer ()
  "Indent the whole current buffer"
  (interactive)
  (save-excursion (indent-region (point-min) (point-max) nil)))

(defun fix-broken-indentation ()
  "Example:
if(i < 10)
{
replace to
if(i < 10) {"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward
            "\\(\\(if\\|while\\|for\\|do\\|switch\\|else\\).*[)=]\\)[ \n\r\t]*{"
            nil t)
      (replace-match "\\1 {"))))


(defun tiny-url-replace(&optional pos)
  "Replace normal url to tinyurl.com in the
current buffer.

If POS set to find url from this POS or
`point-min'"
  (interactive)
  (let* ((url-bounds (bounds-of-thing-at-point 'url))
         (url (thing-at-point 'url))
         (newurl nil))
    (when url-bounds
      (setq newurl (save-excursion
                     (set-buffer
                      (url-retrieve-synchronously
                       (concat "http://tinyurl.com/api-create.php?url=" url)))
                     (goto-char (point-min))
                     (re-search-forward "http://tinyurl.com/.*" nil t)
                     (setq res (match-string 0))
                     (kill-buffer) res))
      (save-restriction
        (narrow-to-region (car url-bounds) (cdr url-bounds))
        (delete-region (point-min) (point-max))
        (insert newurl)))))

(defun take-screenshot-delayed(&optional arg)
  "Take screenshot from root display.
If ARG not set, take imediately"
  (interactive "P")
  (when (y-or-n-p "Take screen? ")
    (message "wait %d sec and take screenshot" (or arg 0))
    (run-with-idle-timer (or arg 0) nil
                         '(lambda()
                            ;; -geometry 1024x768
                            (shell-command "import -window root ~/screen.png")
                            (if (y-or-n-p "Upload screen ? ")
                                (browse-url (upload-image "~/screen.png"))
                              (browse-url "~/screen.png"))))))
(global-set-key [print] 'take-screenshot-delayed)

;; TODO: make asynch
(defun upload-image (filename)
  "Upload image to imageshack.us"
  (shell-command (concat "curl -H Expect: -F fileupload=\"@" (expand-file-name  filename)
                         "\" -F xml=yes -# \"http://www.imageshack.us/index.php\""))
  (save-excursion
    (switch-to-buffer "*Shell Command Output*")
    (progn
      (re-search-forward "<image_link>\\(.*\\)</image_link>")
      (clipboard-kill-ring-save (match-beginning 1) (match-end 1))
      (setq res (match-string 1))
      (kill-buffer "*Shell Command Output*") res)))

;; From http://www.emacswiki.org/emacs/misc-cmds.el
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))
