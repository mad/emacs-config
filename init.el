;;; Time-stamp: "2011-03-04 22:23:53 mad"
;;; GNU Emacs 23.1.1 (i686-pc-linux-gnu, GTK+ Version 2.14.7)
;;; of 2009-08-02 on home

;; This config files depend on:

;; `actionscript-mode' `bison-mode' `bm' `cc-mode' `cedet'
;; `semantic-decorate-include' `semantic-gcc' `semantic-ia' `eassist'
;; `semanticdb-global' `semanticdb-ectag' `company' `color-theme' `desktop'
;; `uniquify' `tramp' `saveplace' `jit-lock' `dired' `ecb' `emms-setup'
;; `emms-player-mplayer' `flex-mode' `gtags' `gtk-look' `identica-mode'
;; `irfc' `jabber' `jabber-libnotify' `juick' `magit' `muttrc-mode' `osd'
;; `pastebin' `cperl-mode' `c-eldoc' `skeleton' `prolog' `pymacs' `sdcv'
;; `slackware-changelog' `sr-speedbar' `twitter' `vkontakte' `w3m-load'
;; `mime-w3m' `weather' `yasnippet' `dropdown-list' `zencoding-mode'
;; From:
;; FIXME: load-file, load too use
;; egrep  -o "\(require '(.*)\)" ~/.emacs.d/init/* | \
;;     sed "s/.*'\(.*\))/\`\1'/"                   | \
;;     fmt                                         | \
;;     xsel -b

(add-to-list 'load-path "~/.emacs.d/init")

(load "init-default")
(load "init-custom")
(load "init-keybinding")

(load "init-progmode")
(load "init-c")
(load "init-elisp")
(load "init-bison")
(load "init-flex")
(load "init-js2")
(load "init-lua")
(load "init-php")
(load "init-prolog")
(load "init-as")
(load "init-perl")

(load "init-cedet")
;; XXX: Not used
;; (load "init-ecb")
(load "init-yasnippet")
(load "init-flymake")
(load "init-gtags")
(load "init-gtk-look")
;; FIXME: `Object vanished when the Pymacs helper was killed`
;; (load "init-pymacs")
(load "init-diff")
(load "init-ediff")
(load "init-magit")
(load "init-ahg")
(load "init-sr-speedbar")
;; XXX: Not used
;; (load "init-company")
(load "init-bm")

(load "init-org")
(load "init-dired")
(load "init-elscreen")
(load "init-irfc")
(load "init-markdown")
(load "init-auctex")
(load "init-muttrc")
(load "init-osd")
(load "init-slackware")

(load "init-emms")
(load "init-jabber")
(load "init-juick")
(load "init-gnus")
;; XXX: Not used
;; (load "init-twitter")
(load "init-identica")
(load "init-vkontakte")
(load "init-google")
(load "init-pastebin")
(load "init-tv")
(load "init-w3m")
(load "init-sdcv")
(load "init-weather")

(load "init-personal")

