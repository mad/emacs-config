(require 'cperl-mode)
(defalias 'perl-mode 'cperl-mode)

(setq cperl-hairy t)
(set-face-background 'cperl-array-face "wheat")
(set-face-background 'cperl-hash-face "wheat")

;; When so bright
(set-face-foreground 'cperl-nonoverridable-face "chartreuse4")

(defun perltidy-region ()
  "Run the perltidy parser on the current region."
  (interactive)
  (let ((start (mark))
        (end   (point))
        (shell-command-default-error-buffer "perltidy-errors")
        (command "perltidy -q -lp -cti=1"))
    (shell-command-on-region start end command t t
                             shell-command-default-error-buffer)))

(add-hook 'cperl-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-h f") 'cperl-perldoc)
            (local-set-key "\C-xt" 'perltidy-region)))

;; use eldoc
(defun my-cperl-eldoc-documentation-function ()
  "Return meaningful doc string for `eldoc-mode'."
  (car
   (let ((cperl-message-on-help-error nil))
     (cperl-get-help))))

(add-hook 'cperl-mode-hook
          (lambda ()
            (set (make-local-variable 'eldoc-documentation-function)
                 'my-cperl-eldoc-documentation-function)))
(add-hook 'cperl-mode-hook 'eldoc-mode)

(defun perltidy-whole ()
  (interactive)
  (let ((current-point (point)))
    (save-excursion
      (mark-whole-buffer)
      (perltidy-region))
    (goto-char current-point)))
