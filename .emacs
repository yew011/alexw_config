;; Alex W, emacs config
;; to be further enriched,
;; packages

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

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

;; Define function to call when go-mode loads
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
  (setq gofmt-command "goimports")                ; gofmt uses invokes goimports
  (if (not (string-match "go" compile-command))   ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; guru settings
  (go-guru-hl-identifier-mode)                    ; highlight identifiers

  ;; Key bindings specific to go-mode
  (local-set-key (kbd "M-.") 'go-guru-definition) ; Go to definition
  (local-set-key (kbd "M-*") 'pop-tag-mark)       ; Return from whence you came
  (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
  (local-set-key (kbd "M-P") 'recompile)          ; Redo most recent compile cmd
  (local-set-key (kbd "M-]") 'next-error)         ; Go to next error (or msg)
  (local-set-key (kbd "M-[") 'previous-error)     ; Go to previous error or msg

  ;; Crappy way to disable autofill which conflict with the
  ;; auto-complete.
  (setq-default fill-column -1)
  ;; Misc go stuff
  (auto-complete-mode 1))                         ; Enable auto-complete mode

;; Connect go-mode-hook with the function we just defined
(add-hook 'go-mode-hook 'my-go-mode-hook)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

;; If the go-guru.el file is in the load path, this will load it.
(require 'go-guru)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (popup neotree go-impl go-guru go-errcheck go-autocomplete go flymake-go exec-path-from-shell atom-one-dark-theme))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(popup-menu-selection-face ((t (:inherit default :background "blue" :foreground "white")))))

(require 'popup)
