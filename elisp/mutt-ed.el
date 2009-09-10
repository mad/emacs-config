(add-hook 'find-file-hooks (lambda ()
  (when (string-match "^mutt-.*-[0-9]+-[0-9]+-[0-9]+$"
                      (file-name-nondirectory (buffer-file-name)))

    (set (make-local-variable 'backup-inhibited) t)

    ;; The following code is executed only when composing messages
    ;; (new messages or replies), not when editing messages (which
    ;; start with "From ") from the mailbox.
    (when (looking-at "^From:")
      (flush-lines "^\\(> \n\\)*> -- \\(\\(\n> .*\\)+\\|$\\)")
      (not-modified)
      (search-forward "\n\n" nil t))

    (mail-mode))))