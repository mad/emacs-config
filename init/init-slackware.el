(when (file-exists-p "/etc/slackware-version")
  (add-to-list 'load-path "~/.emacs.d/elisp/slackware-el")
  (require 'slackware-changelog)
  (setq slackware-mirror-root "/pub/mirrors/slackware/slackware-current/"))

