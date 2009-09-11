(require 'irfc)
(setq irfc-directory "~/rfc")
(add-to-list 'auto-mode-alist '("rfc[0-9]+\\.txt\\'" . irfc-mode))
(defun irfc-index ()
  (interactive)
  (switch-to-buffer "*RFC index*")
  (insert-file-contents (concat irfc-directory "/1rfc_index.txt" ))
  (set-buffer-modified-p nil)
  (setq buffer-read-only t))
