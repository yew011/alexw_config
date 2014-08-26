;; Alex W, emacs config
;; to be further enriched,
(add-to-list 'load-path "~/.emacs.d")

;; mark the trailing whitespace
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; hightlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#280")

;; enable colum number
(setq column-number-mode t)

;; etag tracing related
(defun view-tag-other-window (arg)
"Same as `find-tag-other-window' but doesn't move the point"
(interactive "P")
(let ((window (get-buffer-window)))
(if arg
(find-tag-other-window nil t)
(call-interactively 'find-tag-other-window))
(recenter 0)
(select-window window)))

"for navigate in a separate window"
(global-set-key (kbd "C-x C-g") 'view-tag-other-window)

"for auto complete"
(global-set-key (kbd "C-c SPC") 'complete-tag)

;; indentation
(setq-default c-basic-offset 8
                  tab-width 8
                  indent-tabs-mode t)

;; fill the 80th char line
(require 'fill-column-indicator)
(setq-default fill-column 80)
(setq fci-rule-color "red")
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 80)))
(global-fci-mode t)

;; not working
(require 'simple-call-tree)

;; pointer to tags
(setq tags-file-name "~/alex_dev/TAGS")
(setq tags-revert-without-query t)

;; another key binding for 'occur
(global-set-key (kbd "C-c o") 'occur)

;; scroll other window up
(global-set-key "\C-c\M-\C-v" `scroll-other-window-down)