;;;; -*- mode: emacs-lisp -*-

(load "~/.emacs.common")

(cond ((eq system-type 'gnu/linux)
       (load "~/.emacs.linux"))
      ((eq system-type 'windows-nt)
       (load "~/.emacs.win"))
      ((eq system-type 'darwin)
       (load "~/.emacs.darwin"))
      (t
       (load "~/.emacs.linux")))

(if (file-exists-p "~/.emacs.local")
    (load-file "~/.emacs.local"))
