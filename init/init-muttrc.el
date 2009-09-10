(require 'muttrc-mode)
(add-to-list 'auto-mode-alist '("^mutt-.*-[0-9]+-[0-9]+-[0-9]+$" . mail-mode))
(add-to-list 'auto-mode-alist '("muttrc" . muttrc-mode))

