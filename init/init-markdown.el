(add-to-list 'load-path "~/.emacs.d/elisp/markdown-mode")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (nconc '(("\\.markdown" . markdown-mode)
               ("\\.text" . markdown-mode)
               ("\\.md" . markdown-mode)
               ("\\.mdwn" . markdown-mode)) auto-mode-alist))

