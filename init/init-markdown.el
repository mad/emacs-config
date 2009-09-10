(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (nconc '(("\\.markdown" . markdown-mode)
               ("\\.text" . markdown-mode)
               ("\\.mdwn" . markdown-mode)) auto-mode-alist))

