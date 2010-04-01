;; emacs 23.1.93 include it
;; (add-to-list 'load-path "~/.emacs.d/elisp/cedet/common")

;; (require 'cedet)
;; (require 'semantic-decorate-include)
;; (require 'semantic-gcc)
;; (require 'semantic-ia)
;; (require 'eassist)
;; (require 'semanticdb-global)
;; (require 'semanticdb-ectag)

;; (semantic-load-enable-minimum-features)
;; BUG: /usr/src/linux/kernel/module.c closed in some line
(semantic-mode)
;; (semantic-load-enable-excessive-code-helpers)
;; (semanticdb-enable-gnu-global-databases 'c-mode)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)
;; (semantic-load-enable-primary-exuberent-ctags-support)

;;(setq senator-minor-mode-name "SN")
;;(setq semantic-imenu-auto-rebuild-directory-indexes nil)
;;(setq-mode-local c-mode semanticdb-find-default-throttle
;;               '(project unloaded system recursive))
;;(setq-mode-local c++-mode semanticdb-find-default-throttle
;;                 '(project unloaded system recursive))
;;(setq semantic-idle-scheduler-idle-time 1)
;;(setq semantic-self-insert-show-completion-function
;;      (lambda nil (semantic-ia-complete-symbol-menu (point))))
;;(setq global-semantic-tag-folding-mode t)

;;(global-srecode-minor-mode 1)
;;(global-semantic-mru-bookmark-mode 1)
;;(global-semantic-folding-mode 1)
;; BUG: buffer closed and switched to latest buffer
;;(global-semantic-idle-tag-highlight-mode -1)
;; I`m not use it
;;(global-ede-mode t)


;;
(load "~/cvs/cedet/contrib/eassist.el" t t)

(defun my-cedet-hook ()
  (local-set-key "\C-ci" 'semantic-ia-complete-symbol-menu)
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

;; (defun my-semantic-hook ()
;;   (imenu-add-to-menubar "TAGS"))

;; (add-hook 'semantic-init-hooks 'my-semantic-hook)

(defun my-c-mode-cedet-hook ()
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref))

(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

;; Used when semantic LAAAAGGG
(defun semanticdb-CLEAN ()
  (interactive)
  (setq semanticdb-database-list nil))


(global-semantic-decoration-mode)
(global-semantic-highlight-func-mode)
(global-semantic-idle-summary-mode)
(global-semantic-stickyfunc-mode)
