clean:
	@rm -f init.elc emacs.el emacs.elc

compile: init.el emacs.org clean
	@emacs --batch -l 'init.el' -l 'lisp/compile.el'
