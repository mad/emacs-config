(put 'dired-find-alternate-file 'disabled nil)

(defun kill-all-dired-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count ))))
(fset 'kadb 'kill-all-dired-buffers)

(defun dired-show-only (&optional regexp)
  (interactive)
  (dired-mark-files-regexp (or regexp "^[^\.]"))
  (dired-toggle-marks)
  (dired-do-kill-lines))
(define-key dired-mode-map "\C-ch" 'dired-show-only)
(defvar dired-sort-map (make-sparse-keymap))

(define-key dired-mode-map "s" dired-sort-map)

(define-key dired-sort-map "s" (lambda () "sort by Size" (interactive) (dired-sort-other (concat dired-listing-switches "S"))))
(define-key dired-sort-map "x" (lambda () "sort by eXtension" (interactive) (dired-sort-other (concat dired-listing-switches "X"))))
(define-key dired-sort-map "t" (lambda () "sort by Time" (interactive) (dired-sort-other (concat dired-listing-switches "t"))))
(define-key dired-sort-map "n" (lambda () "sort by Name" (interactive) (dired-sort-other dired-listing-switches)))

;; (add-hook 'dired-load-hook
;;           (function (lambda ()
;;                       (load "dired-x"))))
;; (setq dired-omit-files-p t)
;; (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$")
;; (add-hook 'dired-mode-hook
;;           (function (lambda ()
;;                       (dired-omit-mode 1))))

;; Advice `dired-run-shell-command' with asynchronously.
;; XXX: EMACS KILLED IF KILL THIS COMMAND
;; (defadvice dired-run-shell-command (around dired-run-shell-command-async activate)
;;   "Postfix COMMAND argument of `dired-run-shell-command' with an ampersand.
;; If there is none yet, so that it is run asynchronously."
;;   (let* ((cmd (ad-get-arg 0))
;;          (cmd-length (length cmd))
;;          (last-cmd-char (substring cmd
;;                                    (max 0 (- cmd-length 1))
;;                                    cmd-length)))
;;     (unless (string= last-cmd-char "&")
;;       (ad-set-arg 0 (concat cmd "&")))
;;     (save-window-excursion ad-do-it)))
