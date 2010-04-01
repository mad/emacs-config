(setq org-agenda-files '("~/org/study-5.org" "~/org/home.org" "~/study_8/study_8.org"))
(setq org-default-notes-file "~/.notes")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)

(setq org-remember-templates
      '(("notes" ?n "* %^{Title} %^g\n  %U\n  %?" "~/org/notes.org" bottom)
        ("tips" ?t "* %^{Title} %^g\n  %U\n  %?" "~/org/TIPS.org" bottom)
        ("phone" ?p "* %^{Name}\n  %U %?" "~/phone.org" bottom nil)
        ("TODO" ?d "* TODO %^{Title} %^g\n  %U\n  %?" "~/org/home.org" bottom)
        ("juick" ?j "* Juick %^{Title} %^g\n  %U\n  %?\n  %a" "~/org/juick.bkm.org" bottom)))

(defun my-org-mode-hook()
  (local-set-key [M-left] 'windmove-left)
  (local-set-key [M-right] 'windmove-right)
  (local-set-key [M-up] 'windmove-up)
  (local-set-key [M-down] 'windmove-down)
  (set-fill-column 78))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq org-log-done 'time)

(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode 1)))
