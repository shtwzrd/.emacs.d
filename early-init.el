;; early-init.el -*- lexical-binding: t; -*-

(setq gc-cons-threshold 268435456)

;; disable package.el, will init straight.el instead later
(setq package-enable-at-startup nil)

(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars))
;; hide mode-line -- we use header-line instead
(setq-default mode-line-format nil)

(setq site-run-file nil)
