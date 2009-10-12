
(setq org-agenda-files '("~/org/study-5.org" "~/org/home.org"))
(setq org-default-notes-file "~/.notes")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)

(setq org-remember-templates
      '((?n "* NOTE %U %?\n  %i\n  %a" "~/org/notes.org")
        (?t "%?\n%i\n%a" "~/org/TIPS.org" bottom)
        (?p "* PHONE %?\n %i %u %?" "~/phone.org" bottom nil)
        (?x "* XCLIP %U %?\n  %x\n  %a" "~/org/TIPS.org" bottom nil)
        (?h "* TODO %T %?\n  %i\n  %a" "~/org/home.org")))

(defun my-org-mode-hook()
  (local-set-key [M-left] 'windmove-left)
  (local-set-key [M-right] 'windmove-right)
  (local-set-key [M-up] 'windmove-up)
  (local-set-key [M-down] 'windmove-down)
  (set-fill-column 78))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode 1)))
