(setq ditaa-cmd "java -jar ~/.emacs.d/ditaa0_6b.jar -o -E")
(defun djcb-ditaa-generate ()
  (interactive)
  (shell-command
   (concat ditaa-cmd " " buffer-file-name)))

