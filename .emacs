;; Alex W, emacs config
;; to be further enriched,
(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'git)
(require 'git-blame)

(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)

(global-set-key [?\C-c ?g ?c] 'mo-git-blame-current)
(global-set-key [?\C-c ?g ?f] 'mo-git-blame-file)

;; mark the trailing whitespace
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; hightlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#280")

;; enable colum number
(setq column-number-mode t)

"for navigate in a separate window"
(global-set-key (kbd "C-x C-g") 'view-tag-other-window)

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)

;; fill the 80th char line
(require 'fill-column-indicator)
(setq-default fill-column 80)
(setq fci-rule-color "red")
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 80)))
(global-fci-mode t)

;; scroll other window up
(global-set-key "\C-c\M-\C-v" `scroll-other-window-down)

(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
(setq mouse-sel-mode t)
