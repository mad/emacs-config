(defvar channel-type-assoc
  '(("MTV" . 2) ("МузТВ" .8) ("РБК" . 10) ("Культура" . 11)
    ("VH1" . 12) ("СТС" . 13) ("РенТВ" . 14) ("РТР" . 15)
    ("5" . 16) ("НТВ" . 17) ("Звезда" . 18) ("ОРТ" . 19)
    ("2x2" . 20) ("ТНТ" . 21) ("Спорт" . 23) ("100тв" . 24)
    ("7тв" . 28) ("A-One" . 30)))
(defun tv ()
  "Run tvtime. Default is 2x2 channel"
  (interactive)
  (start-process "tvtime" nil "tvtime" "-c"
                 (number-to-string
                  (assoc-default
                   (completing-read "Select channel: " channel-type-assoc nil t "2x2")
                   channel-type-assoc nil "2x2"))))

