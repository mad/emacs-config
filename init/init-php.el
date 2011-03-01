(autoload 'php-mode "php-mode" "Major mode for editing php." t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(setq php-completion-file "~/.emacs.d/php-completion/php-completion-file")
(setq php-manual-path "/usr/share/doc/php-manual/ru/html/")
(setq php-manual-url "http://www.php.net/manual/ru/")
(setq php-mode-force-pear 1)

(modify-syntax-entry ?\# "< b" php-mode-syntax-table)
(modify-syntax-entry ?\n "> b" php-mode-syntax-table)
