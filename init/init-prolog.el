;; Now in 24.0 emacs prolog mode out of the box

(when (version< emacs-version "24")
  (require 'prolog)
  (setq prolog-system 'swi))

