(add-to-list 'load-path "~/.emacs.d/elisp/auctex")
(add-to-list 'load-path "~/.emacs.d/elisp/auctex/preview/")

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master t)

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; Because in new auctex default pdf viewer is Evince
(setq TeX-view-program-selection '(((output-dvi style-pstricks) "dvips and gv")
                                   (output-dvi "xdvi")
                                   (output-pdf "xpdf")
                                   (output-html "xdg-open")))
