;;; gtk-look.el --- lookup Gtk and Gnome documentation.

;; Copyright 2004, 2006, 2007, 2008, 2009 Kevin Ryde

;; Author: Kevin Ryde <user42@zip.com.au>
;; Version: 13
;; Keywords: tools, c
;; URL: http://user42.tuxfamily.org/gtk-look/index.html
;; EmacsWiki: GtkLook

;; gtk-look.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation; either version 3, or (at your option) any later
;; version.
;;
;; gtk-look.el is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
;; Public License for more details.
;;
;; You can get a copy of the GNU General Public License online at
;; <http://www.gnu.org/licenses/>.


;;; Commentary:

;; M-x gtk-lookup-symbol displays HTML documentation for Gtk and Gnome
;; functions and variables, similar to what M-x info-lookup-symbol does for
;; info files.  The documentation is expected to be HTML files with devhelp
;; indexes, like the Debian packages libgtk2.0-doc etc.  See the
;; `gtk-lookup-symbol' docstring below for more.

;;; Install:

;; Put gtk-look.el in one of your `load-path' directories, and in your
;; .emacs add
;;
;;     (autoload 'gtk-lookup-symbol "gtk-look" nil t)
;;
;; This makes M-x gtk-lookup-symbol available, but you'll probably want to
;; bind it to a key.  C-h C-j is one possibility, being close to C-h C-i for
;; `info-lookup-symbol'.  For instance to do that globally,
;;
;;     (define-key global-map [?\C-h ?\C-j] 'gtk-lookup-symbol)

;;; Emacsen:

;; Designed for Emacs 21 and 22.  Works in XEmacs 21 if you copy
;; `file-expand-wildcards' from Emacs and byte-compile to avoid slowness in
;; the other compatibility code below.

;;; History:

;; Version 1 - the first version
;; Version 2 - correction to usual .devhelp file locations
;; Version 3 - recognise devhelp2 format
;; Version 4 - home page link, more parens on funcs in index,
;;             fix lookup done from within an existing browser buffer
;; Version 5 - make browse other window work in xemacs
;; Version 6 - use with-compression-mode and display-warning, when available
;; Version 7 - gtk2-perl support, no longer use info-look for symbol at point
;; Version 8 - fix perl Glib::G_FOO and UIManager symbol munging
;; Version 9 - leave cache uninitialized if C-g interrupt during cache build,
;;             fix camel case VScrollbar symbol munging
;; Version 10 - fix preferring .devhelp2 files over .devhelp when not .gz
;; Version 11 - munging for Gnome2, Gtk2::GladeXML
;;            - require-match since must choose one of the available links
;; Version 12 - propagate upper/lower case from gtk2-perl methods
;; Version 13 - avoid `with-auto-compression-mode' in Emacs 21 as it's buggy
;;              when byte compiled

;;; Code:

(require 'browse-url)

;;;###autoload
(defgroup gtk-lookup nil
  "GTK/GNOME documentation lookup."
 :prefix "gtk-lookup-"
 :group 'languages ;; same as info-look
 :link  '(url-link
          :tag "gtk-look.el home page"
          "http://user42.tuxfamily.org/gtk-look/index.html"))

(defvar gtk-lookup-cache 'uninitialized
  "Cache of targets for `gtk-lookup-symbol'.
The current format is (NAME . (BASE . LINK)), where NAME is a
function or type string, and BASE and LINK will be concatenated
to make a URL.  BASE and LINK are separate to save a little
memory because the BASE part is shared by all the links in one
manual.  Being an alist means this can be passed to
`completing-read' and friends.

If `gtk-lookup-cache' is not yet initialized the value is the
symbol `uninitialized'.  `gtk-lookup-cache-init' should be used
to ensure it's initialized.")

(defvar gtk-lookup-history nil
  "Symbols previously looked up with `gtk-lookup-symbol'.")

(defun gtk-lookup-reset ()
  "Discard data cached for `gtk-lookup-symbol'.
This can be used to get newly installed documents recognised."
  (interactive)
  (setq gtk-lookup-cache 'uninitialized))

;; note this defcustom is after gtk-lookup-reset so the :set method here can
;; call gtk-lookup-reset immediately for setting the initial value
(defcustom gtk-lookup-devhelp-indices
  '(;; usual place (see /usr/share/doc/devhelp-common/README
    "/usr/share/gtk-doc/html/*/*.devhelp*"
    ;; possible locally installed stuff
    "/usr/local/share/gtk-doc/html/*/*.devhelp*")
  "List of devhelp index files containing GTK/GNOME documentation.
Shell wildcards like \"*.devhelp\" can be used, and gzip \".gz\"
compressed files are allowed.

Usually these files are under /usr/share/gtk-doc/html, and
possibly /usr/local/share/gtk-doc.

If you change this variable you should call `gtk-lookup-reset' to
clear previously cached data.  This is done automatically from
the `customize' interface."

 :set (lambda (sym val)
        (custom-set-default sym val)
        (gtk-lookup-reset))
 :type '(repeat string)
 :group 'gtk-lookup)


(defmacro gtk-lookup-with-auto-compression (&rest body)
  "Evaluate BODY forms with `auto-compression-mode' enabled.
`auto-compression-mode' is turned on if it isn't already then put
back to its original setting when BODY returns.  The return value
is the last form in BODY."

  (if (eval-when-compile
        (and (fboundp 'with-auto-compression-mode)
             (not (string-match "^21\\." emacs-version)))) ;; not Emacs 21.x
      ;; emacs22
      `(with-auto-compression-mode ,@body)

    ;; emacs21 has `with-auto-compression-mode', but it's buggy when byte
    ;; compiled as it tries to call jka-compr-installed-p without loading
    ;; jka-compr.el
    ;;
    ;; xemacs21 doesn't have `with-auto-compression-mode'.  It also doesn't
    ;; have an `auto-compression-mode' variable (which emacs has) to get the
    ;; current state, hence the use of the `jka-compr-installed-p'.
    ;;
    `(let ((gtk-lookup-with-auto-compression--old-state
            (and (fboundp 'jka-compr-installed-p) ;; if jka-compr loaded
                 (jka-compr-installed-p))))

       ;; turn on if not already on
       ;; xemacs21 has a toggle-auto-compression which takes a "no message"
       ;; arg, but not emacs21
       (if (not gtk-lookup-with-auto-compression--old-state)
           (auto-compression-mode 1))

       (unwind-protect
           (progn ,@body)
         ;; turn off again if it was off before
         (if (not gtk-lookup-with-auto-compression--old-state)
             (auto-compression-mode -1))))))

(defun gtk-lookup-cache-init ()
  "Initialize `gtk-lookup-cache', if not already done.
The return is the `gtk-lookup-cache' list."
  (when (eq gtk-lookup-cache 'uninitialized)
    ;; build in `result' and only after that set gtk-lookup-cache, so as not
    ;; to leave a half built cache if killed (C-g) part-way through
    (let ((result nil)
          (found nil))
      (gtk-lookup-with-auto-compression
       (with-temp-buffer
         (let ((filelist
                ;; `file-truename' here and `remove' below will eliminate
                ;; any duplicate filenames arising from symlinks or repeat
                ;; matches of wildcards in gtk-lookup-devhelp-indices
                (sort (mapcar 'file-truename
                              (apply 'append
                                     (mapcar 'file-expand-wildcards
                                             gtk-lookup-devhelp-indices)))
                      'string<)))

           ;; if there's a .devhelp2 then don't look at the old .devhelp
           (dolist (filename filelist)
             (when (string-match "\\(.*\\)\\.devhelp2\\(\\.gz\\)?\\'"
                                 filename)
               (let ((base (match-string 1 filename)))
                 (setq filelist (remove (concat base ".devhelp")
                                        filelist))
                 (setq filelist (remove (concat base ".devhelp.gz")
                                        filelist)))))

           (while filelist
             (let ((filename (car filelist)))
               (message "Processing %s" filename)
               (setq found t)
               (let ((base (concat "file://" (file-name-directory filename))))
                 ;; In Emacs 21.3 jka-compr doesn't erase the buffer
                 ;; properly under the "replace" argument to
                 ;; insert-file-contents, so use erase-buffer instead.
                 ;; (Fixed in Emacs 22.)
                 (erase-buffer)
                 (insert-file-contents filename)

                 ;; "<function ...>" is devhelp 1 format
                 (while (re-search-forward "<function name=\"\\(struct \\|union \\|enum \\)?\\([a-zA-Z0-9_-]+\\)[ ()]*\" link=\"\\([^\"]+\\)\"/>"
                                           (point-max) t)
                   (setq result (cons (cons (match-string 2)
                                            (cons base (match-string 3)))
                                      result)))

                 ;; "<keyword ...>" is devhelp 2 format
                 ;; the name field can be
                 ;;     "enum foo"
                 ;;     "foo()"
                 ;;     "foo ()"
                 ;;
                 ;; the type field is empty for ordinary index entries like
                 ;; "Build Requirements" etc, so exclude those by matching
                 ;; only particular types
                 ;;
                 (goto-char (point-min))
                 (while (re-search-forward "<keyword type=\"\\(enum\\|function\\|macro\\|struct\\|typedef\\|union\\|variable\\)\" name=\"\\([^\"]*\\)\" link=\"\\([^\"]+\\)\""
                                           (point-max) t)
                   (let ((name (match-string 2))
                         (link (match-string 3)))

                     ;; lose leading "enum" or "union" from name
                     (if (string-match "\\`\\(enum\\|struct\\|union\\) \\(.*\\)" name)
                         (setq name (match-string 2 name)))

                     ;; lose trailing "()" or " ()" on name for functions
                     (if (string-match "\\`\\(.*?\\) ?()\\'" name)
                         (setq name (match-string 1 name)))

                     (setq result (cons (cons name (cons base link))
                                        result)))))

               (setq filelist (remove filename filelist)))))))
      (unless found
        (if (eval-when-compile (fboundp 'display-warning)) ;; not in emacs21
            (display-warning 'gtk-look "No devhelp files found")
          (message "No devhelp files found")))
      (setq gtk-lookup-cache result)))
  gtk-lookup-cache)

(defun gtk-lookup-string-suffix-ci-p (suff str)
  "Return true if string SUFF is a suffix of STR, ignoring case."
  (and (>= (length str) (length suff))
       (if (eval-when-compile (fboundp 'compare-strings)) ;; not in xemacs21
           (eq t (compare-strings str (- (length str) (length suff)) nil
                                  suff nil nil
                                  t)) ;; ignore case
         (setq suff (upcase suff))
         (setq str (upcase str))
         (string-equal suff
                       (substring str (- (length str) (length suff)))))))

(defun gtk-lookup-symbol-method-candidates (method)
  "Return a list of Gtk symbols (strings) having METHOD as a suffix.
For example \"set_parent\" gives a list
\(\"gtk_widget_set_parent\" \"gnome_dialog_set_parent\" ...).

The method must match after a \"_\" separator, so for instance
\"parent\" doesn't give \"gtk_widget_unparent\"."

  (let ((ret (and (assoc-ignore-case method (gtk-lookup-cache-init))
                  (list method))))    ;; whole name if exists
    (setq method (concat "_" method)) ;; and otherwise at _ boundary
    (dolist (elem (gtk-lookup-cache-init) ret)
      (let ((name (car elem)))
        (if (gtk-lookup-string-suffix-ci-p method name)
            (setq ret (cons name ret)))))))

(defun gtk-lookup-canonicalize-symbol (str)
  "Return canonicalized Gtk function name etc from string STR.
Various transformations are applied to turn Gtk2-Perl, Guile-Gtk
and Guile-Gnome into C names.  For example Scheme func
\"gdk-keyval-to-lower\" becomes \"gdk_keyval_to_lower\", or Perl
\"Gtk2::TreeStore->new\" becomes \"Gtk_Tree_Store_new\".

Not much attention is paid to upper/lower case in the transformed
return.  It's basically left like the input, anticipating a
case-insensitive lookup by `completing-read' in
`gtk-lookup-symbol-interactive-arg'."

  (when str
    (let ((case-fold-search nil))
      ;; note xemacs21 replace-match doesn't take a "subexp" arg when
      ;; replacing in a string (only in a buffer)

      ;; gtk2-perl "Glib::G_PRIORITY_LOW" -> "G_PRIORITY_LOW", to avoid a
      ;; doubling to "g_G_..."
      (if (string-match "\\`Glib::\\(G_\\)" str)
          (setq str (replace-match "\\1" t nil str)))

      ;; gtk2-perl "Gtk2::Gdk::GDK_PRIORITY_EVENTS" -> "GDK_PRIORITY_EVENTS",
      ;; to avoid a doubling to "gdk_GDK_..."
      (if (string-match "\\`Gtk2::Gdk::\\(GDK_\\)" str)
          (setq str (replace-match "\\1" t nil str)))

      ;; gtk2-perl "Gtk2::GTK_PRIORITY_RESIZE" -> "GTK_PRIORITY_RESIZE", to
      ;; avoid a doubling to "gtk_GTK_..."
      (if (string-match "\\`Gtk2::\\(GTK_\\)" str)
          (setq str (replace-match "\\1" t nil str)))

      ;; gtk2-perl "Glib" -> "G"
      (if (string-match "\\`\\(Glib\\)\\(::\\|->\\)" str)
          (setq str (replace-match "G\\2" t nil str)))
      ;; gtk2-perl "Gtk2::Gdk", "Gtk2::Glade", "Gtk2::Pango" lose "Gtk2::" part
      (if (string-match "\\`\\(Gtk2::\\)\\(Gdk\\|Glade\\|Pango\\)" str)
          (setq str (replace-match "\\2" t nil str)))
      ;; gtk2-perl "Gtk2" -> "Gtk", "Gnome2" -> "Gnome", losing the "2"
      (if (string-match "\\`\\(Gtk\\|Gnome\\)2\\(::\\|->\\)" str)
          (setq str (replace-match "\\1\\2" t nil str)))

      ;; guile-gnome classes "<gtype-instance>" -> "gtypeInstance"
      ;; base types as per gtype-name->scheme-name-alist in utils.scm
      (when (string-match "\\`<\\(.*\\)>\\'" str)
        (setq str (match-string 1 str))
        (while (string-match "\\(-\\)\\(.\\)" str)
          (setq str (replace-match (upcase (match-string 2 str)) t t str))))
      ;; guile-gnome "gtype:gtype" -> "G_TYPE_gtype"
      ;; and "gtype:gboolean" -> "G_TYPE_boolean" by stripping the "g" if
      ;; there's no match with it, but a match without
      (when (string-match "\\`\\(gtype:\\)g?" str)
        (let ((alt (replace-match "G_TYPE_" t t str)))
          (setq str (replace-match "G_TYPE_g" t t str))
          (gtk-lookup-cache-init)
          (and (not (assoc-ignore-case str gtk-lookup-cache))
               (assoc-ignore-case alt gtk-lookup-cache)
               (setq str alt))))

      (if (string-match "[_-]" str)
          ;; function or constant
          (progn
            ;; gtk2-perl camel case class like "TreeStore" -> "Tree_Store"
            (while (string-match "\\([a-z]\\)\\([A-Z]\\)" str)
              (setq str (replace-match "\\1_\\2" t nil str)))

            ;; gtk2-perl camel case like "UIManager" -> "UI_Manager"
            ;; but only two or more like UI, a single VScrollbar unchanged
            (while (string-match "\\([A-Z]\\{2,\\}\\)\\([A-Z][a-z]\\)" str)
              (setq str (replace-match "\\1_\\2" t nil str)))

            ;; gtk2-perl component separator "->" becomes "_"
            ;; The upper/lower case of the PRE part is adjusted to follow
            ;; the POST part.  This means Gtk2->check_version gives the
            ;; function gtk_check_version() whereas Gtk2->CHECK_VERSION
            ;; gives the macro GTK_CHECK_VERSION().  This only matters if an
            ;; upper and a lower both exist, if there's just one the
            ;; `assoc-ignore-case' lookup will go to the right place
            ;; irrespective of mangling here.
            (while (string-match "->" str)
              (let ((pre  (substring str 0 (match-beginning 0)))
                    (post (substring str (match-end 0))))
                (setq str (concat (if (string-match "\\`[a-z]" post)
                                      (downcase pre)
                                    (upcase pre))
                                  "_" post))))

            ;; other component separators become "_"
            ;;    "-"   lisp
            ;;    "::"  gtk2-perl
            (while (string-match "-\\|::" str)
              (setq str (replace-match "_" t t str))))

        ;; one word class name

        ;; gtk2-perl "::" separators eg. "Gtk::Object" -> "GtkObject",
        ;; including subclassing forms like "Gtk::Label::" -> "GtkLabel",
        (while (string-match "::" str)
          (setq str (replace-match "" t t str))))))

  str)

(defun gtk-lookup-symbol-bounds-of-thing-at-point ()
  "Find the bounds of a `gtk-lookup-symbol' symbol at point.
The return is a pair (BEG . END) of buffer positions, or nil if
point is not at or within a symbol."

  ;; For perl style "Gtk2::Foo->bar" demand the left side start with a
  ;; capital letter like "Gtk2::Label->new", so as to distinguish it from a
  ;; method call like "$label->set_text".  For the latter the return is just
  ;; the "set_text" part (when point is with that "set_text").
  ;;
  ;; The desired match is the one earliest in the buffer which covers point.
  ;; `re-search-backwards' is no good for that, as it stops at the first
  ;; match, not the earliest possible.  `thing-at-point-looking-at' is
  ;; better, but the optional "(...)?" perl class part ends up with only a
  ;; partial match (like only the "Store" part of "TreeStore->"), not the
  ;; biggest surrounding point.  So the strategy is to look forwards from the
  ;; beginning of the line for the first which covers point.
  ;;
  (save-excursion
    (let ((case-fold-search nil)
          (orig-point (point))
          (re "\\([A-Z][a-zA-Z0-9_:]*[a-zA-Z0-9_]->\\)?[a-zA-Z_][a-zA-Z0-9_:-]*[a-zA-Z0-9]\\|<[a-zA-Z0-9_-]+>"))
      (beginning-of-line)
      (and (re-search-forward re nil t)
           (progn
             (while (< (match-end 0) orig-point)
               (re-search-forward re nil t))
             t)
           (<= (match-beginning 0) orig-point)
           (cons (match-beginning 0) (match-end 0))))))

(put 'gtk-lookup-symbol 'bounds-of-thing-at-point
     'gtk-lookup-symbol-bounds-of-thing-at-point)

(defvar gtk-lookup-initial-completion-list nil
  "Initial completions to display for `gtk-lookup-symbol-interactive-arg'.
This is let-bound by `gtk-lookup-symbol-interactive-arg' and is
nil at other times.")

(defun gtk-lookup-display-initial-completion-list ()
  "Display initial method completions for `gtk-lookup-symbol'."
  (if (>= (length gtk-lookup-initial-completion-list) 2)
      (with-output-to-temp-buffer "*Completions*"
        (display-completion-list gtk-lookup-initial-completion-list)))
  (setq gtk-lookup-initial-completion-list nil))

(add-hook 'minibuffer-setup-hook
          'gtk-lookup-display-initial-completion-list)

(defun gtk-lookup-symbol-interactive-arg ()
  "Symbol argument read for interactive `gtk-lookup-symbol'.
Return a one-element list (\"symbol\") which is the user-selected
symbol name string."
  (let* ((completion-ignore-case t)
	 (enable-recursive-minibuffers t)
	 (default (gtk-lookup-canonicalize-symbol
                   (thing-at-point 'gtk-lookup-symbol)))
         (gtk-lookup-initial-completion-list
          (and default
               (gtk-lookup-symbol-method-candidates default))))
    (if (= 1 (length gtk-lookup-initial-completion-list))
        ;; one method match, offer full name as the default
        (setq default (car gtk-lookup-initial-completion-list)))

    (let ((symbol (gtk-lookup-canonicalize-symbol
                   (completing-read
                    (if default
                        (format "Describe symbol (default %s): " default)
                      "Describe symbol: ")
                    (gtk-lookup-cache-init)
                    nil  ;; predicate
                    t    ;; require-match
                    nil  ;; initial-input
                    'gtk-lookup-history
                    default))))
      (list (or symbol default "")))))

;;;###autoload
(defun gtk-lookup-symbol (symbol)
  "Lookup Gtk/Gnome documentation for SYMBOL.
SYMBOL is a string name of a function, variable, type, etc, in
Gtk, Gnome and related libraries like Pango.  The symbol is
sought in \"devhelp\" indexes (see `gtk-lookup-devhelp-indices'),
and the HTML documentation is displayed with `browse-url'.

The lookup tries first case-sensitively, then insensitively, for
ease of typing in a name.

Interactively SYMBOL is prompted for, with completions from the
available documentation.  The default is the function, variable,
type, etc at point.  Transformations are applied to make a C name
from forms used in

    * Gtk2-Perl   (URL `http://gtk2-perl.sourceforge.net/')
    * Guile-Gnome (URL `http://www.gnu.org/software/guile-gnome/')
    * Guile-Gtk   (URL `http://www.gnu.org/software/guile-gtk/')

For example with point on a Perl call like \"Gtk2::Label->new\"
the default offered is \"gtk_label_new\".  This is independent of
the major mode, so you can have code in one style and comments in
another.  If `browse-url' displays in a buffer you can even
lookup from the browser buffer if there's no link already
\(sample code, or a few cross references from Gtk to Pango).

When point is on a \"method\" name like just \"set_size_request\"
in Gtk2-Perl or Guile-Gnome the default is expanded to the full
name like \"gtk_widget_set_size_request\" if unique.  Or if
there's multiple candidates then a *Completions* window is
presented which you can switch to with \\<minibuffer-local-completion-map>\\[switch-to-completions] and select in the
usual way.

`browse-url' is used to display the documentation.  If it
displays in an Emacs buffer (like say `w3m' does) then that's put
in an \"other window\" below the current, similar to
`info-lookup' on Info docs.  You can customize
`browse-url-browser-function' to choose the viewer and with some
regexps there you can even have one browser for Gtk documents
\"file:///usr/share/gtk-doc/html/...\" and another browser for
other things.

The `completing-read' for the symbol demands a match, since
gtk-lookup-symbol can only go to the links available in the
devhelp indexes.  The full set of Gtk symbols is pretty big, so
you might try one of the completions add-ons like Icicles to help
searching or browsing.

The gtk-look home page is
URL `http://user42.tuxfamily.org/gtk-look/index.html'"

  (interactive (gtk-lookup-symbol-interactive-arg))
  (gtk-lookup-cache-init)
  (let ((entry (or (assoc symbol gtk-lookup-cache) ;; exact match preferred
                   (assoc-ignore-case symbol gtk-lookup-cache))))
    (or entry
        (error "Unknown symbol %s" symbol))
    (gtk-lookup-browse-url-other-window (concat (cadr entry) (cddr entry)))))

(defun gtk-lookup-browse-url-other-window (url)
  "`browse-url' but in an \"other-window\" if it uses an Emacs window."

  ;; this convoluted code divines the type of browser `browse-url' invokes:
  ;; perhaps an external program in its own X window, perhaps something in
  ;; an emacs buffer.  And when in a buffer it might switch to an "other
  ;; window" itself or just use the current window; and perhaps the current
  ;; buffer (and window) is already the browser buffer
  ;;
  (interactive (browse-url-interactive-arg "URL: "))
  (let ((orig-win-conf (current-window-configuration))
        (orig-buffer   (current-buffer))
        (orig-window   (selected-window))
        (dummy-buf     (get-buffer-create
                        "*gtk-lookup-browse-url-other-window--dummy-buffer*")))
    (switch-to-buffer-other-window dummy-buf)
    (let ((other-window (get-buffer-window dummy-buf)))
      (select-window other-window)
      (browse-url url)

      (cond ((and (eq dummy-buf (window-buffer other-window))
                  (eq orig-buffer (window-buffer orig-window)))
             ;; browse-url didn't touch the buffers, it left the original
             ;; and dummy current, so it's an external window system
             ;; program; put window configs all back how they were
             (set-window-configuration orig-win-conf))

            ((eq orig-buffer (window-buffer other-window))
             ;; browse-url has changed dummy-buf to orig-buf in the
             ;; other-window, which means we were in the browser buffer
             ;; already and shouldn't have split with "other window"; so put
             ;; window configs back how they were, but don't change point in
             ;; the browser buffer as that's the new document position
             (let ((point (window-point other-window)))
               (set-window-configuration orig-win-conf)
               (with-current-buffer orig-buffer
                 (goto-char point))))

            (t
             ;; browse-url has selected a buffer; but it might have done
             ;; "other window" itself (eg. w3m-browse-url does); don't let
             ;; two "other window" invocations leave our original buffer
             ;; at the bottom and the browser at the top, instead force
             ;; our orig-window back to orig-buffer, and let the other
             ;; window we made show the browser buffer
             (let ((browser-buffer (window-buffer other-window)))
               (select-window other-window)
               (switch-to-buffer browser-buffer)
               (select-window orig-window)
               (switch-to-buffer orig-buffer)))))

    (kill-buffer dummy-buf)))

(provide 'gtk-look)

;;; gtk-look.el ends here
