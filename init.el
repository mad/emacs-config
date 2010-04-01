;;; Time-stamp: "2010-04-01 23:39:32 mad"
;;; GNU Emacs 23.1.1 (i686-pc-linux-gnu, GTK+ Version 2.14.7)
;;; of 2009-08-02 on home

;; This config files depend on:

;; `actionscript-mode' `analog-clock' `anything' `apel'
;; `auto-complete' `autocompletion-php-functions' `bison-mode' `bm'
;; `c-eldoc' `codepad' `color-theme-autoloads' `color-theme'
;; `column-marker' `company' `ecb' `elscreen' `emacs-rc-auto-insert'
;; `emms' `etach' `etags-select' `festival' `flex-mode'
;; `flymake-shell' `folding' `gist' `google-translate'
;; `graphviz-dot-mode' `gtags' `gtk-look' `haxe-mode' `header2'
;; `hfy-cmap' `htmlfontify' `htmlize' `http-post-simple'
;; `http-twiddle' `identica-mode' `irfc' `jabber' `js2-mode'
;; `js2-mode.elc' `juick-el' `lua-mode' `magit' `magit.elc'
;; `make-regexp' `markdown-mode' `mutt-ed' `muttrc-mode' `osd'
;; `pastebin' `php-mode' `prolog' `py-complete' `rfc' `sdcv' `showtip'
;; `slackware-changelog' `slime' `sr-speedbar' `tex-site'
;; `textile-minor-mode' `themes' `turing' `turing_2' `twitter'
;; `twittering-mode' `typing-speed' `vline' `w3m-session' `weather'
;; `yasnippet'

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

(load "init-cedet")
;; New emacs
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
(load "init-sr-speedbar")
;; Not used
;;(load "init-company")
(load "init-bm")

(load "init-org")
(load "init-ditta")
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
(load ".gnus.el")
(load "init-twitter")
(load "init-identica")
(load "init-vkontakte")
(load "init-google")
(load "init-pastebin")
(load "init-tv")
(load "init-w3m")
(load "init-sdcv")
(load "init-weather")

(load "init-personal")
