;;; charrot-latex.el --- an Emacs LISP code template

;;; Author: Riccardo Murri <riccardo.murri@gmail.com>
;;; Version: 2009-08-24


;;; Copyright (c) 2009 Riccardo Murri <riccardo.murri@gmail.com>

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


;;; TO-DO:
;;


;;; History:
;; 


;;; Code:

(require 'charrot)

;; common mathematical symbols
(charrot-define-rotating "!=" "\\not=")
(charrot-define-rotating "->" "\\to" "\\longrightarrow")
(charrot-define-rotating "..." "\\ldots" "\\cdots")
(charrot-define-rotating ":" "\\colon")
(charrot-define-rotating "<=" "\\leq")
(charrot-define-rotating ">=" "\\geq")
(charrot-define-rotating "{" "\\{" "\\langle")
(charrot-define-rotating "|->" "\\mapsto" "\\longmapsto")
(charrot-define-rotating "}" "\\}" "\\rangle")
(charrot-define-rotating "~" "\\sim")
(charrot-define-rotating "~=" "\\simeq")

;; lowercase greek letters
(charrot-define-rotating "a" "\\alpha" "\\alef")
(charrot-define-rotating "b" "\\beta")
(charrot-define-rotating "c" "\\chi")
(charrot-define-rotating "d" "\\delta")
(charrot-define-rotating "e" "\\epsilon" "\\varepsilon")
(charrot-define-rotating "f" "\\phi" "\\varphi")
(charrot-define-rotating "g" "\\gamma")
(charrot-define-rotating "h" "\\eta")
(charrot-define-rotating "i" "\\iota")
(charrot-define-rotating "k" "\\kappa")
(charrot-define-rotating "l" "\\lambda")
(charrot-define-rotating "m" "\\mu")
(charrot-define-rotating "n" "\\nu")
(charrot-define-rotating "o" "\\omega")
(charrot-define-rotating "p" "\\pi" "\\varpi")
(charrot-define-rotating "r" "\\rho")
(charrot-define-rotating "s" "\\sigma" "\\varsigma")
(charrot-define-rotating "t" "\\theta" "\\vartheta")
(charrot-define-rotating "u" "\\upsilon")
(charrot-define-rotating "x" "\\xi")
(charrot-define-rotating "y" "\\psi")
(charrot-define-rotating "z" "\\zeta")

;; Uppercase greek letters
(charrot-define-rotating "C" "\\Chi")
(charrot-define-rotating "D" "\\Delta")
(charrot-define-rotating "F" "\\Phi")
(charrot-define-rotating "G" "\\Gamma")
(charrot-define-rotating "L" "\\Lambda")
(charrot-define-rotating "O" "\\Omega")
(charrot-define-rotating "P" "\\Pi")
(charrot-define-rotating "S" "\\Sigma")
(charrot-define-rotating "T" "\\Theta")
(charrot-define-rotating "X" "\\Xi")
(charrot-define-rotating "U" "\\Upsilon")
(charrot-define-rotating "Y" "\\Psi")
(charrot-define-rotating "Z" "\\Zeta")


;; that's all folks!
(provide 'charrot-latex)

;;; charrot-latex.el ends here
