(add-to-list 'load-path "~/.emacs.d/elisp/cedet/common")

(require 'cedet)
(require 'semantic-decorate-include)
(require 'semantic-gcc)
(require 'semantic-ia)
(require 'eassist)
(require 'semanticdb-global)
(require 'semanticdb-ectag)

(semantic-load-enable-excessive-code-helpers)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(semantic-load-enable-primary-exuberent-ctags-support)

(setq senator-minor-mode-name "SN")
(setq semantic-imenu-auto-rebuild-directory-indexes nil)
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq semantic-idle-scheduler-idle-time 1)
(setq semantic-self-insert-show-completion-function
      (lambda nil (semantic-ia-complete-symbol-menu (point))))
(setq global-semantic-tag-folding-mode t)

(global-srecode-minor-mode 1)
(global-semantic-mru-bookmark-mode 1)
(global-semantic-folding-mode 1)
(global-semantic-idle-tag-highlight-mode 1)
(global-ede-mode t)

(defun my-cedet-hook ()
  (local-set-key "\C-cm" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)

  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))

(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'lisp-mode-hook 'my-cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'my-cedet-hook)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))

(add-hook 'semantic-init-hooks 'my-semantic-hook)

(defun my-c-mode-cedet-hook ()
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref))

(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
