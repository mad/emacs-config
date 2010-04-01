(add-to-list 'load-path "~/git/pymacs")
(require 'pymacs)
(setq pymacs-load-path '("/usr/lib/python2.6/site-packages/ropemacs/"
                         "/usr/lib/python2.6/site-packages/ropemode/"))
(setenv "PYMACS_PYTHON" "python2.6")
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(add-hook 'python-mode-hook 'ropemacs-mode)