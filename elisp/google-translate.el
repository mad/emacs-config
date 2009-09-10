;; google-translate.el -- translates using Google
;; Copyright (C) 2009 Deniz Dogan

;; Author: Deniz Dogan <deniz.a.m.dogan@gmail.com>
;; Keywords: translating, google

;; Installation:
;;
;; 1. Put this file somewhere on your load-path.
;; 2. Add this line to your startup file: (load "google-translate.el")

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

;;; Code:

(require 'http-post-simple)

;;; Customization:

(defgroup google-translate nil
  "Translate using Google from Emacs."
  :group 'emacs)

(defcustom google-translate-result-regexp "id=result_box dir=\"ltr\">\\([^<]+\\)<"
  "Don't modify this, unless you're completely sure you can do
this better."
  :group 'google-translate
  :type 'regexp)

(defcustom google-translate-language-alist
  '(("Albanian" . "sq")
    ("Arabic" . "ar")
    ("Automatic" . "auto")
    ("Bulgarian" . "bg")
    ("Catalan" . "ca")
    ("Chinese (simplified)" . "zh-CN")
    ("Chinese (traditional)" . "zh-TW")
    ("Croatian" . "hr")
    ("Czech" . "cs")
    ("Danish" . "da")
    ("Dutch" . "nl")
    ("English" . "en")
    ("Estonian" . "et")
    ("Filippino" . "tl")
    ("Finnish" . "fi")
    ("French" . "fr")
    ("Galician" . "gl")
    ("German" . "de")
    ("Greek" . "el")
    ("Hebrew" . "iw")
    ("Hindi" . "hi")
    ("Hungarian" . "hu")
    ("Indonesian" . "id")
    ("Italian" . "it")
    ("Japanese" . "ja")
    ("Korean" . "ko")
    ("Latvian" . "lv")
    ("Lithuanian" . "lt")
    ("Maltesian" . "mt")
    ("Norwegian" . "no")
    ("Polish" . "pl")
    ("Portuguese" . "pt")
    ("Romanian" . "ro")
    ("Russian" . "ru")
    ("Serbian" . "sr")
    ("Slovakian" . "sk")
    ("Slovenian" . "sl")
    ("Spanish" . "es")
    ("Swedish" . "sv")
    ("Thai" . "th")
    ("Turkish" . "tr")
    ("Ukrainian" . "uk")
    ("Vietnamese" . "vi"))
  "An association list with keys being the names of the languages
and the keys being the Google Translate 'short form' for each
respective language."
  :group 'google-translate
  :type 'alist)

(defcustom google-translate-default-target-language
  "English"
  "The default target language for translation."
  :group 'google-translate
  :type 'string)

(defcustom google-translate-default-source-language
  "Automatic"
  "The default source language for translation.  You're probably
better off just leaving this as 'Automatic'."
  :group 'google-translate
  :type 'string)

;;; Functions:

(defun google-translate (from to what)
  "Given the 'from' and 'to' language and what to translate,
returns the translation as a string."
  (setq result (http-post-simple
                  "http://translate.google.com/translate_t"
                  `((sl . ,from)
                    (tl . ,to)
                    (text . ,what))))
  (multiple-value-bind (data header status) result
    (progn
      (if (string-match google-translate-result-regexp data)
          (message "*Google Translate*\n\"%s\"\nmeans\n\"%s\"" what (match-string 1 data))
        (message "*Google Translate* Nothing was found.")))))

(defun google-translate-internal (what arg)
  (setq from google-translate-default-source-language)
  (setq to   google-translate-default-target-language)
  (when arg
    (let ((completion-ignore-case t))
      (setq from (completing-read "Source language: " google-translate-language-alist))
      (setq to   (completing-read "Target language: " google-translate-language-alist))))
  (google-translate
   (cdr (assoc-string from google-translate-language-alist))
   (cdr (assoc-string to google-translate-language-alist))
   what))

(defun google-translate-region (begin end arg)
  (interactive "r\nP")
  (google-translate-internal (buffer-substring begin end) arg))

(defun google-translate-word-at-point (arg)
  (interactive "P")
  (google-translate-internal (word-at-point) arg))

(defun google-translate-buffer (arg)
  (interactive "P")
  (google-translate-internal (buffer-string) arg))

(defun google-translate-dwim (begin end arg)
  "This is what you want to bind your keys to."
  (interactive "r\nP")
  (if (region-active-p)
      (google-translate-region begin end arg)
    (google-translate-word-at-point arg)))
