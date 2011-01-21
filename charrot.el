;;; charrot.el --- Replace text before point, rotating among replacements.

;;; Author: Riccardo Murri <riccardo.murri@gmail.com>
;;; Version: 2009-08-23


;;; Copyright (c) 2009, 2010 Riccardo Murri <riccardo.murri@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA


;;; Commentary:
;;
;; CharRot provides a command `charrot-replace' to replace the text
;; before point with an arbitrary string, like the Emacs standard
;; `abbrev-mode'.  There are two main differences with `abbrev-mode':
;;
;; * Any text string can be defined as an abbreviation, not just
;;   words.  (On the other hand, this means that CharRot cannot
;;   provide any case-matching feature: abbreviation and replacement
;;   are matched verbatim.)
;;
;; * Replacement is not performed automatically but
;;   must be invoked by calling the command `charrot-replace'.
;; 
;; `charrot-replace' scans the text *before* point; if it matches any
;; abbreviation defined with `charrot-define-abbrev' or
;; `charrot-define-rotating', it will be replaced with the appropriate
;; replacement string. The longest-matching string is replaced. Point
;; is kept at the end of the replacement string -- thus, repeated
;; application of `charrot-replace' is possible. Undo works as usual,
;; so any replacement can be undone with `C-_'.
;; 
;; Example usage
;; -------------
;;
;; Load the file "charrot.el"::
;;
;;   (require 'charrot)
;;
;; CharRot is most useful when `charrot-replace' is bound to an easily
;; accessible key chord; I use `C-.' for that:
;;
;;   (global-set-key (kbd "C-.") #'charrot-replace)
;;
;; Replacements can now be defined with `charrot-define-abbrev' (which
;; also works interactively):
;;
;;   (charrot-define-abbrev "->" "\\to")
;;   (charrot-define-abbrev "|->" "\\mapsto")
;;
;; Now typing `C-.' just after `->' will turn it into the LaTeX
;; command `\to'; if the text before point is `|->' then the
;; replacement will be `\mapsto' instead.
;;
;; One can define *rotating* replacements with `charrot-define-rotating':
;;
;;   (charrot-define-rotating "..." "\\ldots" "\\cdots")
;;   (charrot-define-rotating "a" "\\alpha")
;;
;; Then, pressing `C-.' once after entring `...' will turn it into
;; `\ldots'; pressing it once more will replace this with `\cdots';
;; one more stroke of `C-.' turns back to the starting `...'.
;; Likewise, invoking `charrot-replace' when point is past an `a' will
;; turn it into `\alpha' and then back into `a'.
;;
;; If you have ever used X-Symbol with LaTeX, you already know (and
;; perhaps miss) this feature.  The file `charrot-latex.el' provides a
;; list of replacements useful with TeX/LaTeX.
;;
;; Caveats
;; -------
;;
;; The replacements table is *global*: you can't bind `^' to `\hat' in
;; LaTeX-mode and `<sup></sup>' in html-mode. (See TO-DO section.)
;;
;; It is no error to define rotating replacements that cross; the
;; latter definition partially overrides the former:
;;
;;   (charrot-define-rotating "f*" "foo")
;;   (charrot-define-rotating "foo" "bar" "baz" "quux")
;;
;; Then calling `charrot-replace' turns `f*' into `foo', but
;; successive invocations will cycle through the strings `bar', `baz',
;; and `quux', without ever going back to `f*'.


;;; TO-DO:
;;
;; * mode-local replacements
;; * ignore white space before point
;; * rotate replacements forwards and backwards?
;; * interactive definition of rotations?
;; * add "point placement" information? e.g., to replace "^" with
;;   "\hat{}" and place point in between "{" and "}"


;;; History:
;; 
;; 2009-08-23: basic functionality.


;;; Code:

(defvar charrot--abbrevs ()
  "Nested alist storing lookup sequences and their expansions.
This is an internal state variable and should only be manipulated 
using functions `charrot-define-abbrev' and `charrot-define-rotating'.")


(defun charrot-define-abbrev (abbrev replacement)
  "Set REPLACEMENT as a replacement text for ABBREV.
Calling `charrot-replace' when point is at the end of ABBREV,
will replace it with REPLACEMENT."
  (interactive "sReplace: \nswith: ")
  (flet 
      ((do-define (a b r)
                  (let ((ch (car b))
                        (nextchs (cdr b)))
                    (if (eq nil ch)
                        ;; at end of string
                        (cons (cons ch replacement) a)
                      ;; more characters to go, recurse into self
                      (let ((target (assq ch a)))
                        (if (eq nil target)
                            ;; no sub-map defined for `ch', provide one
                            (cons (cons ch (do-define nil nextchs r)) a)
                          ;; replace sub-map with a new one, 
                          ;; containing the additional mapping
                          (cons (cons (car target)
                                      (do-define (cdr target) nextchs r))
                                (delq target a))))))))
    (setq charrot--abbrevs
          (do-define charrot--abbrevs 
                     (nreverse (string-to-list abbrev))
                     replacement))))


(defun charrot-define-rotating (&rest args)
  "For each pair A,B of consecutive elements in ARGS,
define B as the replacement text of A.  Replacement
text of the last element is provided by the first element.

This effectively allows rotating among all replacements
by starting with any one of the provided texts and 
repeatedly applying `charrot-replace'."
  (if (< 1 (length args))
      (let ((first (car args)))
        (flet 
            ((do-define (args) 
                        (when args
                          (charrot-define-abbrev (car args) 
                                                 (if (cdr args) 
                                                     (nth 1 args)
                                                   first))
                          (do-define (cdr-safe args)))))
          (do-define args)))))


(defun charrot-replace ()
  "Replace text before point."
  (interactive)
  (flet 
      ((do-replace (pos point abbrevs)
                   (if abbrevs
                       (let ((next (cdr-safe (assq (char-before pos) abbrevs))))
                         ;; try recursing to find a longer abbrev
                         (or (do-replace (1- pos) point next)
                             ;; none found, try expanding here
                             (let ((replacement (cdr-safe (assq nil abbrevs))))
                               (if (and replacement (not (= point pos)))
                                   (progn
                                     (delete-region pos point)
                                     (insert replacement)
                                     pos))))))))
    (let ((pos (do-replace (point) (point) charrot--abbrevs)))
      (if (not pos)
          (message "Could not find expansion.")))))


;; that's all folks!
(provide 'charrot)

;;; charrot.el ends here
