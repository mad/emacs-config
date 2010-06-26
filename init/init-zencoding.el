(add-to-list 'load-path "~/git/zencoding/")
(require 'zencoding-mode)

(add-hook 'html-mode-hook 'zencoding-mode)
(define-key html-mode-map (kbd "\C-c\C-z") 'zencoding-expand-yas)
(define-key html-mode-map (kbd "\C-cz") 'zencoding-expand-line)