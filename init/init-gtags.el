(require 'gtags)

(setq c-mode-hook
      '(lambda ()
         (gtags-mode 1)))
(setq gtags-mode-hook
      '(lambda ()
         (setq gtags-pop-delete t)
         (setq gtags-path-style 'absolute)))
(setq gtags-select-mode-hook
      '(lambda ()
         (setq hl-line-face 'underline)
         (hl-line-mode 1)))
(global-set-key "\M-[" 'gtags-find-rtag)

