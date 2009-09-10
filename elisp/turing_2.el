;; turing.el -- Turing Machines for GNU Emacs

;;; Code:

(defvar turing-min-blank-left 4
  "*Minimum blanks at left")
(defvar turing-min-blank-right 4
  "*Minimum blanks at right")

(defvar turing-tape '("" . "")
  "The Turing Machine tape")

(defvar turing-rules ()
  "A set of rules for the Turing Machine")

(defvar turing-state nil
  "The current state of the Turing Machinge")

(defvar turing-next-rule nil)

(defvar turing-final-states nil
  "A list of the final states for the Turing Machine")

(defvar turing-current-rule nil)

(defvar turing-tape-mark (make-marker))
(defvar turing-current-pos 0)
(defvar turing-state-mark (make-marker))
(defvar turing-rules-mark (make-marker))
(defvar turing-next-rule-mark (make-marker))
(defvar turing-final-states-mark (make-marker))

(defvar turing-rule-parse-regexp nil
  "The regexp used for parsing rules.")

(defvar turing-mode nil)

(defvar turing-rule-edit-mode nil
  "Minor mode for editing Turing Machine rules")

(defvar turing-run-mode nil
  "Minor mode for controlling Turing Machines")

(defvar turing-save-mark nil)
(defvar turing-rule-kill-ring nil)

(defvar turing-mode-map nil)

(defvar turing-rule-edit-map nil)
(defvar turing-run-map nil)
(defvar turing-comment-edit-map nil)

(if turing-mode-map nil
  (setq turing-mode-map (make-sparse-keymap)))

(if turing-run-map nil
  (setq turing-run-map (make-sparse-keymap))
  (define-key turing-run-map " " 'turing-next-move)
  (define-key turing-run-map "a" 'turing-add-rule)
  (define-key turing-run-map "e" 'turing-edit-rule)
  (define-key turing-run-map "i" 'turing-set-input)
  (define-key turing-run-map "s" 'turing-change-state)
  (define-key turing-run-map "f" 'turing-move-right)
  (define-key turing-run-map "b" 'turing-move-left)
  (define-key turing-run-map "p" 'turing-backward-rule)
  (define-key turing-run-map "n" 'turing-forward-rule)
  (define-key turing-run-map "k" 'turing-kill-rule)
  (define-key turing-run-map "y" 'turing-yank-rule)
  (define-key turing-run-map "F" 'turing-add-final-state)
  (define-key turing-run-map "r" 'turing-calcutate-next-rule))

(if turing-rule-edit-map nil
  (setq turing-rule-edit-map (make-sparse-keymap))
  (define-key turing-rule-edit-map "\C-m" 'turing-end-rule-edit)
  (define-key turing-rule-edit-map "\C-n" 'undefined)
  (define-key turing-rule-edit-map "\C-p" 'undefined)
  (define-key turing-rule-edit-map "\C-b" 'turing-backward-char)
  (define-key turing-rule-edit-map "\C-a" 'turing-beginning-of-rule)
  (define-key turing-rule-edit-map "\C-i" 'turing-rule-edit-tab)
  )
	

(if turing-rule-parse-regexp nil
  (let ((e  "\\([^ ]*\\)"))
    (setq turing-rule-parse-regexp
	  (format " *%s *, *%s *->? *%s *, *%s *, *%s *"
		  e e e e e))))

(or (assq 'turing-rule-edit-mode minor-mode-alist)
    (setq minor-mode-alist
	  (cons '(turing-rule-edit-mode " Rule") minor-mode-alist)))

(or (assq 'turing-rule-edit-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (cons (cons 'turing-rule-edit-mode turing-rule-edit-map)
		minor-mode-map-alist)))

(or (assq 'turing-run-mode minor-mode-alist)
    (setq minor-mode-alist
	  (cons '(turing-run-mode "") minor-mode-alist)))

(or (assq 'turing-run-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (cons (cons 'turing-run-mode turing-run-map)
		minor-mode-map-alist)))
;;;

(defun turing-change-label (marker string)
  "Change the text at MARKER to STRING"
  (save-excursion
    (let ((kill-whole-line nil))
      (goto-char marker)
      (or (eolp) (kill-line))
      (insert string))))
  
(defun turing-set-input (string)
  (interactive "sInput string: ")
  (setq turing-tape (cons (make-string turing-min-blank-left ? )
			  (concat string (make-string turing-min-blank-right ? ))))
  (setq turing-current-pos turing-min-blank-left)
  (turing-redraw-tape)
  (turing-calcutate-next-rule))

(defun turing-redraw-tape ()
  (save-excursion
    (let ((kill-whole-line t)
	  (border (make-string 79 ?=)))
      (aset border turing-current-pos ?|)
      (goto-char turing-tape-mark)
      (kill-line 3)
      (insert border "\n"
	      (car turing-tape)
	      (cdr turing-tape) "\n"
	      border "\n"))))

(defun turing-mode ()
    "A mode for building and exploring Turing Machines

You start out with an empty TM. Rules can be added with `\\[turing-add-rule]',
the current state is set with `\\[turing-change-state]' and the
input string is set using `\\[turing-set-input]'. To execute the next
move, use `\\[turing-next-move]'.

These are the key binding for controlling the TM. While editing rules
and comments, the bindings are different.:

\\{turing-run-map}"
  (interactive)
  (kill-all-local-variables)

  (use-local-map turing-mode-map)

  (setq mode-name "Turing")
  (setq major-mode 'turing-mode)

  (make-local-variable 'turing-tape)
  (make-local-variable 'turing-tape-mark)
  (make-local-variable 'turing-current-pos)
  (make-local-variable 'turing-state-mark)
  (make-local-variable 'turing-rules-mark)
  (make-local-variable 'turing-next-rule-mark)
  (make-local-variable 'turing-final-states-mark)
  (make-local-variable 'turing-rules)
  (make-local-variable 'turing-state)
  (make-local-variable 'turing-final-states)
  (make-local-variable 'turing-rule-edit-mode)
  (make-local-variable 'turing-run-mode)
  (make-local-variable 'turing-final-states)

  (setq truncate-lines t))

(defun turing-prepare-buffer (&optional buffer)
  (save-excursion
    (and buffer (set-buffer buffer))
    (erase-buffer)
    (insert "\n" (make-string 79 ?_) "\n\n")
    (set-marker turing-tape-mark (point))
    (insert (make-string 79 ?=) "\n")
    (insert "\n" (make-string 79 ?=))
    (insert "\n\n  State:     ")
    (set-marker turing-state-mark (point))
    (insert "\n  Next rule: ")
    (set-marker turing-next-rule-mark (point))
    (insert "\n" (make-string 79 ?_) "\n\n  Rules:\n\n")
    (set-marker turing-rules-mark (point))
    (insert "\n  Final states: ")
    (set-marker turing-final-states-mark (point))))

    
(defun turing ()
  (interactive)
  (let ((turing-buffer (get-buffer-create "*Turing*")))
    (set-buffer turing-buffer)
    (turing-mode)
    (turing-prepare-buffer)
    (setq turing-tape (cons "" "")
	  turing-current-pos 0
	  turing-current-rule nil
	  turing-state nil
	  turing-final-states ()
	  turing-rule-edit-mode nil
	  turing-run-mode t)
    (turing-set-input "")
    (turing-change-label turing-state-mark (symbol-name turing-state))
    (turing-calcutate-next-rule)
    (turing-change-label turing-final-states-mark
			 (format "%S" turing-final-states))
    (switch-to-buffer turing-buffer)))
    
(defun turing-change-cell (char)
  (save-excursion
    (aset (cdr turing-tape) 0 char)
    (goto-char (+ turing-tape-mark 80 turing-current-pos))
    (delete-char 1)
    (insert char)))

(defmacro turing-is-finished ()
  "Check if the Turing Machine is finished"
  (list 'member 'turing-state 'turing-final-states))

(defun turing-calcutate-next-rule ()
  (interactive)
  (setq turing-next-rule (turing-find-applicable-rule turing-rules))
  (if turing-next-rule
      (if (turing-is-finished)
	  (turing-change-label turing-next-rule-mark
			       (concat "FINISHED ("
				       (turing-format-rule turing-next-rule)
				       ")"))
	(turing-change-label turing-next-rule-mark
			     (turing-format-rule turing-next-rule)))
    (if (turing-is-finished)
	(turing-change-label turing-next-rule-mark "FINISHED")
      (turing-change-label turing-next-rule-mark "HALT"))))

(defun turing-move-left ()
  (interactive)
  (save-excursion
    (cond
     ((<= turing-current-pos turing-min-blank-left)
      (setcdr turing-tape (concat " " (cdr turing-tape)))
      (goto-char turing-tape-mark)
      (forward-line 1)
      (insert " "))
     (t
      (setcdr turing-tape (concat (substring (car turing-tape) -1)
				  (cdr turing-tape)))
      (setcar turing-tape (substring (car turing-tape) 0 -1))
      (setq turing-current-pos (1- turing-current-pos))
      (goto-char turing-tape-mark)
      (delete-char 1)
      (end-of-line)
      (insert "=")
      (forward-line 2)
      (delete-char 1)
      (end-of-line)
      (insert "=")))))

(defun turing-move-right ()
  (interactive)
  (save-excursion
    (goto-char turing-tape-mark)
    (insert "=")
    (end-of-line)
    (delete-char -1)
    (forward-line 1)
    (if (< (length (cdr turing-tape)) turing-min-blank-right)
	(progn
	  (setcdr turing-tape (concat (cdr turing-tape) " "))
	  (end-of-line)
	  (insert " ")))
    (setcar turing-tape (concat (car turing-tape)
				(substring (cdr turing-tape) 0 1)))
    (setcdr turing-tape (substring (cdr turing-tape) 1))
    (forward-line 1)
    (insert "=")
    (end-of-line)
    (delete-char -1)
    (setq turing-current-pos (1+ turing-current-pos))))

(defun turing-change-state (state)
  (interactive "sState: ")
  (if (stringp state)
      (setq state (intern state)))
  (setq turing-state state)
  (if (turing-is-finished)
      (setq state (concat (symbol-name state) " (final)"))
    (setq state (symbol-name state)))
  (turing-change-label turing-state-mark state)
  (turing-calcutate-next-rule))

(defun turing-apply-rule (rule)
  (if rule
      (let ((action (cdr rule)))
	(turing-change-state (nth 0 action))
	(turing-change-cell (nth 1 action))
	(if (eq (nth 2 action) 'l)
	    (turing-move-left)
	  (turing-move-right)))))

(defun turing-same-token (token1 token2)
  "Compare two input tokens"
  (if (eq token1 ? )
      (setq token1 ?_))
  (if (eq token2 ? )
      (setq token2 ?_))
  (= token1 token2))


(defun turing-find-applicable-rule (rules)
  (cond
   ((null rules)
    nil)
   ((and (eq turing-state (car (car (car rules))))
	 (turing-same-token (aref (cdr turing-tape) 0) (cdr (car (car rules)))))
    (car rules))
   (t
    (turing-find-applicable-rule (cdr rules)))))
   

(defun turing-next-move ()
  (interactive)
  (turing-apply-rule (turing-find-applicable-rule turing-rules))
  (turing-calcutate-next-rule))

(defun turing-forward-rule (&optional arg)
  "Move forward to next rule"
  (interactive "p")
  (or arg (setq arg 1))
  (turing-move-to-rule (+ turing-current-rule arg)))

(defun turing-backward-rule (&optional arg)
  "Move backward to next rule"
  (interactive "p")
  (or arg (setq arg 1))
  (turing-move-to-rule (- turing-current-rule arg)))

;;; Rule editing functions

(defun turing-backward-char (&optional arg)
  (interactive "p")
  (if (>= (current-column) 7)
      (backward-char arg)))

(defun turing-beginning-of-rule ()
  "Go to the beginning of the rule being edited"
  (interactive)
  (beginning-of-line)
  (forward-char 6))

(defun turing-rule-edit-tab ()
  "Jump to next field in a rule"
  (interactive)
  (let ((eol (save-excursion
	       (end-of-line)
	       (point))))
    (if (re-search-forward ",\\|->\\| ->?" eol t) nil
      (error "No more fields"))))

(defun insert-in-list (list pos item)
  "Insert ITEM in LIST at position POS and return the new list"
  (if (zerop pos)
      (cons item list)
    (cons (car list)
	  (insert-in-list (cdr list) (1- pos) item))))

(defun delete-from-list (list pos)
  (if (zerop pos)
      (cdr list)
    (cons (car list)
	  (delete-from-list (cdr list) (1- pos)))))
    
(defun turing-add-rule (&optional rule)
  "Add a rule.
If no rule i supplied, an empty rule is inserted and marked for editing"
  (interactive)
  (let ((new-rule (or rule
		      (cons
		       (cons (or turing-state 'q)
			     (aref (cdr turing-tape) 0))
		       (list (or turing-state 'q)
			     (aref (cdr turing-tape) 0)
			     'r)))))
    (setq turing-rules
	  (insert-in-list turing-rules (or turing-current-rule 0) new-rule))
    (save-excursion
      (goto-char turing-rules-mark)
      (if turing-current-rule
	  (progn
	    (forward-line turing-current-rule)
	    (forward-char 6)
	    (insert (turing-format-rule (car turing-rules)) "\n      "))
	(insert "      " (turing-format-rule (car turing-rules)) "\n")
	(turing-move-to-rule 0))))
  (if rule
      (turing-calcutate-next-rule)
    (turing-begin-rule-edit)))

(defun turing-kill-rule (&optional count)
  (interactive "p")
  (while (> count 0)
    (setq turing-rule-kill-ring (cons (nth turing-current-rule turing-rules)
				      turing-rule-kill-ring))
    (setq turing-rules (delete-from-list turing-rules turing-current-rule))
    (save-excursion
      (let ((kill-whole-line t))
	(goto-char turing-rules-mark)
	(forward-line turing-current-rule)
	(cond
	 ((null turing-rules)
	  (kill-line)
	  (setq turing-current-rule nil))
	 ((= turing-current-rule (length turing-rules))
	  (turing-move-to-rule (1- turing-current-rule))
	  (kill-line))
	 (t
	  (forward-char 6)
	  (kill-line)
	  (delete-char 7)))))
    (setq count (1- count)))
  (turing-calcutate-next-rule))

(defun turing-yank-rule (&optional count)
  "Yank killed rules
Prefix arg controls how many rules should be yanked"
  (interactive "p")
  (setq count (or count 1))
  (while (> count 0)
    (turing-add-rule (car turing-rule-kill-ring))
    (setq turing-rule-kill-ring (cdr turing-rule-kill-ring))
    (setq count (1- count)))
  (turing-calcutate-next-rule))

(defun turing-edit-rule ()
  (interactive)
  (turing-begin-rule-edit))

(defun turing-move-to-rule (n)
  (interactive "nWhich rule: ")
  (if (< n 0)
      (setq n 0))
  (if (>= n (length turing-rules))
      (setq n (1- (length turing-rules))))
  (save-excursion
    (if turing-current-rule
	(progn
	  (goto-char turing-rules-mark)
	  (forward-line turing-current-rule)
	  (delete-char 4)
	  (insert "    ")))
    (setq turing-current-rule n)
    (goto-char turing-rules-mark)
    (forward-line turing-current-rule)
    (delete-char 4)
    (insert "  =>")))
    

(defun turing-parse-rule (string)
  "Parse a string representation of a Turing Machine rule
Returns the rule. if STRING already is a rule, it is returned."
  (if (consp string)
      string
    (if (string-match turing-rule-parse-regexp string)
	(cons
	 (cons (intern (substring string (match-beginning 1) (match-end 1)))
	       (string-to-char (substring string (match-beginning 2) (match-end 2))))
	 (list (intern (substring string (match-beginning 3) (match-end 3)))
	       (string-to-char (substring string (match-beginning 4) (match-end 4)))
	       (intern (substring string (match-beginning 5) (match-end 5)))))
      (error "Not a valid rule: %2" string))))

(defun turing-char (char &optional arg)
  "Convert spaces to underlines or vice versa if ARG is non-nil"
  (cond
   ((and (not arg) (= char ? ))
    ?_)
   ((and arg (= char ?_))
    ? )
   (t
    char)))

(defun turing-format-rule (rule)
  "Return a string representation of a rule.
The string can be parsed by `turing-parse-rule'."
  (format "%S,%c -> %S,%c,%S"
	  (car (car rule))
	  (turing-char (cdr (car rule)))
	  (nth 0 (cdr rule))
	  (turing-char (nth 1 (cdr rule)))
	  (nth 2 (cdr rule))))

(defun turing-begin-rule-edit ()
  (setq turing-save-mark (point-marker))
  (goto-char turing-rules-mark)
  (forward-line turing-current-rule)
  (forward-char 6)
  (setq	turing-rule-edit-mode t
	turing-run-mode nil))
  
(defun turing-end-rule-edit ()
  (interactive)
  (save-excursion
    (let (bol rule)
      (beginning-of-line)
      (setq bol (point))
      (end-of-line)
      (setq rule (turing-parse-rule (buffer-substring bol (point))))
      (setcar (nth turing-current-rule turing-rules) (car rule))
      (setcdr (nth turing-current-rule turing-rules) (cdr rule))
      (delete-region bol (point))
      (insert "  =>  " (turing-format-rule rule))
      (setq turing-rule-edit-mode nil
	    turing-run-mode t)))
  (goto-char turing-save-mark)
  (turing-calcutate-next-rule))

;;; Final states

(defun turing-add-final-state (state)
  (interactive "sAdd final state: ")
  (setq state (intern state))
  (or (turing-is-finished)
      (setq turing-final-states (cons state turing-final-states)))
  (turing-change-label turing-final-states-mark
		       (format "%S" turing-final-states))
  (turing-calcutate-next-rule)
  (turing-change-state turing-state))

(provide 'turing)
;;; turing.el ends here
