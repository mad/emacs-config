(add-to-list 'load-path "~/.emacs.d/elisp/emms")
(require 'emms-setup)
(require 'emms-player-mplayer)
(emms-devel)
(setq emms-player-list '(emms-player-ogg123
                         emms-player-mplayer
                         emms-player-mpg321
                         emms-player-lastfm-radio))
(setq  emms-info-asynchronously t
       later-do-interval 0.0001
       emms-source-file-default-directory "/home/disk/music/"
       emms-repeat-playlist t
       emms-mode-line-titlebar-function 'emms-mode-line-playlist-current
       emms-player-mpg321-parameters '("-o" "alsa")
       emms-show-format "NP: %s"
       emms-player-next-function 'emms-random
       emms-mode-line-mode-line-function 'nil)
(emms-playing-time-disable-display)
(add-to-list 'emms-info-functions 'emms-info-mp3info)
(add-to-list 'emms-info-functions 'emms-info-ogginfo)
(global-set-key "\C-ce1"
                '(lambda()
                   (interactive)
                   (emms-play-playlist "/home/disk/music/default")))
(global-set-key "\C-ce2"
                '(lambda()
                   (interactive)
                   (emms-play-url "http://89.179.242.149:9000")))
(global-set-key "\C-ce3"
                '(lambda()
                   (interactive)
                   (emms-play-playlist "/home/disk/music/dnb.p")))

(global-set-key (kbd "\C-cel") 'emms)
(global-set-key (kbd "\C-ce-") 'emms-volume-raise)
(global-set-key (kbd "\C-ce=") 'emms-volume-raise)
(global-set-key (kbd "\C-ce-") 'emms-volume-lower)
(global-set-key (kbd "\C-cep") 'emms-pause)
(global-set-key (kbd "\C-ces") 'emms-stop)
(global-set-key [C-prior] 'emms-previous)
(global-set-key [C-next] 'emms-random)
;; (add-hook 'emms-player-started-hook (lambda () (osd-broadcast-string
;;                                              (emms-mode-line-playlist-current))))

