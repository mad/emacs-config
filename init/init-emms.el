(add-to-list 'load-path "~/.emacs.d/elisp/emms")

(require 'emms-setup)
(require 'emms-player-mplayer)
(emms-devel)
(setq emms-player-list '(;;emms-player-ogg123
                         emms-player-mplayer))
;;                         emms-player-mpg321
  ;;                       emms-player-lastfm-radio))
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

(defvar my-emms-playlists
  '(("default" . "/home/disk/music/default")
    ;; not resolved
    ;;("stream radio" . "http://89.179.242.149:9000")
    ("old dnb" . "/home/disk/music/dnb.p")
    ("dnb" . "/pub/disk/dnb-t.epl")))

(defun my-emms-playlist-select ()
  (interactive)
  (emms-play-playlist
   (assoc-default
    (completing-read "Select playlist: " my-emms-playlists nil t)
    my-emms-playlists nil "dnb")))

;; FIXME: THIS HOTKEY NOT WORK ON CONSOLE VERSION EMACS
(global-set-key (kbd "<XF86Tools>") 'my-emms-playlist-select)
(global-set-key (kbd "<XF86AudioPlay>") 'emms-pause)
(global-set-key (kbd "<XF86Favorites>") 'emms)
(global-set-key (kbd "\C-ce+") 'emms-volume-raise)
(global-set-key (kbd "\C-ce=") 'emms-volume-raise)
(global-set-key (kbd "\C-ce-") 'emms-volume-lower)
(global-set-key (kbd "\C-cep") 'emms-pause)
(global-set-key (kbd "\C-ces") 'emms-stop)
(global-set-key [C-S-prior] 'emms-previous)
(global-set-key [C-S-next] 'emms-random)

;; (add-hook 'emms-player-started-hook (lambda () (osd-broadcast-string
;;                                              (emms-mode-line-playlist-current))))

(defun emms-toggle-random ()
  (interactive)
  (if (eq emms-player-next-function 'emms-next-noerror)
      (progn
        (setq emms-player-next-function 'emms-random)
        (global-set-key [C-next] 'emms-random)
        (message "emms next random"))
    (progn
      (setq emms-player-next-function 'emms-next-noerror)
      (global-set-key [C-next] 'emms-next)
      (message "emms next norm"))))
