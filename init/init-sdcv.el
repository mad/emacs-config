;; author: pluskid
;; http://lifegoo.pluskid.org/wiki/EmacsStardict.html
(defun my-star-dict ()
  (interactive)
  (let ((begin (point-min))
        (end (point-max)))
    (if mark-active
        (setq begin (region-beginning)
              end (region-end))
      (save-excursion
        (backward-word)
        (mark-word)
        (setq begin (region-beginning)
              end (region-end))))
    (message "Searching for %s ..." (buffer-substring begin end))
    (let ((tooltip-frame-parameters '((name . "tooltip")
                                      (internal-border-width . 2)
                                      (border-width . 1)
                                      (top . 300)
                                      (left . 300))))
      (tooltip-show
       (shell-command-to-string
        (concat "sdcv -n \""
                (replace-regexp-in-string "\"" "\\\\\"" (buffer-substring begin end)) "\""))))))

(require 'sdcv)

(global-set-key (kbd "C-c d") 'sdcv-search-input)