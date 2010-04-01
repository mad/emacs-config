(add-to-list 'load-path "~/.emacs.d/elisp/ecb")
(require 'ecb)
(setq-default ecb-tip-of-the-day nil)
(setq ecb-layout-window-sizes
      (quote (("left8"
               (0.22151898734177214 . 0.21739130434782608)
               (0.22151898734177214 . 0.260869565217313)
               (0.22151898734177214 . 0.30434782608695654)
               (0.22151898734177214 . 0.17391304347826086)))))

(setq ecb-auto-update-methods-after-save t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
