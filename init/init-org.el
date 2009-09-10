;; Org
(defun my-org-mode-hook()
  (local-set-key [M-left] 'windmove-left)
  (local-set-key [M-right] 'windmove-right)
  (local-set-key [M-up] 'windmove-up)
  (local-set-key [M-down] 'windmove-down)
  (set-fill-column 78))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode 1)))

