;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
	"Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
	(setq-default
	 ;; Base distribution to use. This is a layer contained in the directory
	 ;; `+distribution'. For now available distributions are `spacemacs-base'
	 ;; or `spacemacs'. (default 'spacemacs)
	 dotspacemacs-distribution 'spacemacs
	 ;; List of additional paths where to look for configuration layers.
	 ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
	 dotspacemacs-configuration-layer-path '()
	 ;; List of configuration layers to load. If it is the symbol `all' instead
	 ;; of a list then all discovered layers will be installed.
	 dotspacemacs-configuration-layers
	 '(
     html
		 ;; ----------------------------------------------------------------
		 ;; Example of useful layers you may want to use right away.
		 ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
		 ;; <M-m f e R> (Emacs style) to install them.
		 ;; ----------------------------------------------------------------
		 auto-completion
		 better-defaults
		 ;;emacs-lisp
		 git
		 latex
		 markdown
		 org
		 osx
		 pandoc
		 python
		 (shell :variables
						shell-default-height 30
						shell-default-position 'bottom)
		 (spell-checking :variables spell-checking-enable-by-default nil) ;; default off
		 ;; syntax-checking
		 (syntax-checking :variables syntax-checking-enable-by-default nil) ;; default off
		 version-control
		 )
	 ;; List of additional packages that will be installed without being
	 ;; wrapped in a layer. If you need some configuration for these
	 ;; packages then consider to create a layer, you can also put the
	 ;; configuration in `dotspacemacs/config'.
	 dotspacemacs-additional-packages '(
																			key-chord
																			beacon
                                      exec-path-from-shell
																			)
	 ;; A list of packages and/or extensions that will not be install and loaded.
	 dotspacemacs-excluded-packages '()
	 ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
	 ;; are declared in a layer which is not a member of
	 ;; the list `dotspacemacs-configuration-layers'. (default t)
	 dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
	"Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
	;; This setq-default sexp is an exhaustive list of all the supported
	;; spacemacs settings.
	(setq-default
	 ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
	 ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
	 ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
	 ;; unchanged. (default 'vim)
	 dotspacemacs-editing-style 'vim
	 ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
	 dotspacemacs-verbose-loading nil
	 ;; Specify the startup banner. Default value is `official', it displays
	 ;; the official spacemacs logo. An integer value is the index of text
	 ;; banner, `random' chooses a random text banner in `core/banners'
	 ;; directory. A string value must be a path to an image format supported
	 ;; by your Emacs build.
	 ;; If the value is nil then no banner is displayed. (default 'official)
	 dotspacemacs-startup-banner 'official
	 ;; List of items to show in the startup buffer. If nil it is disabled.
	 ;; Possible values are: `recents' `bookmarks' `projects'.
	 ;; (default '(recents projects))
	 dotspacemacs-startup-lists '(recents projects)
	 ;; List of themes, the first of the list is loaded when spacemacs starts.
	 ;; Press <SPC> T n to cycle to the next theme in the list (works great
	 ;; with 2 themes variants, one dark and one light)
	 dotspacemacs-themes '(spacemacs-dark
												 spacemacs-light
												 solarized-light
												 solarized-dark
												 leuven
												 monokai
												 zenburn)
	 ;; If non nil the cursor color matches the state color.
	 dotspacemacs-colorize-cursor-according-to-state t
	 ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
	 ;; size to make separators look not too crappy.
	 dotspacemacs-default-font '("Source Code Pro"
															 :size 13
															 :weight normal
															 :width normal
															 :powerline-scale 1.1)
	 ;; The leader key
	 dotspacemacs-leader-key "SPC"
	 ;; The leader key accessible in `emacs state' and `insert state'
	 ;; (default "M-m")
	 dotspacemacs-emacs-leader-key "M-m"
	 ;; Major mode leader key is a shortcut key which is the equivalent of
	 ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
	 dotspacemacs-major-mode-leader-key ","
	 ;; Major mode leader key accessible in `emacs state' and `insert state'.
	 ;; (default "C-M-m)
	 dotspacemacs-major-mode-emacs-leader-key "C-M-m"
	 ;; The command key used for Evil commands (ex-commands) and
	 ;; Emacs commands (M-x).
	 ;; By default the command key is `:' so ex-commands are executed like in Vim
	 ;; with `:' and Emacs commands are executed with `<leader> :'.
	 dotspacemacs-command-key ":"
	 ;; If non nil `Y' is remapped to `y$'. (default t)
	 dotspacemacs-remap-Y-to-y$ t
	 ;; Location where to auto-save files. Possible values are `original' to
	 ;; auto-save the file in-place, `cache' to auto-save the file to another
	 ;; file stored in the cache directory and `nil' to disable auto-saving.
	 ;; (default 'cache)
	 dotspacemacs-auto-save-file-location 'cache
	 ;; If non nil then `ido' replaces `helm' for some commands. For now only
	 ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
	 ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
	 dotspacemacs-use-ido nil
	 ;; If non nil, `helm' will try to miminimize the space it uses. (default nil)
	 dotspacemacs-helm-resize nil
	 ;; if non nil, the helm header is hidden when there is only one source.
	 ;; (default nil)
	 dotspacemacs-helm-no-header nil
	 ;; define the position to display `helm', options are `bottom', `top',
	 ;; `left', or `right'. (default 'bottom)
	 dotspacemacs-helm-position 'bottom
	 ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
	 ;; several times cycle between the kill ring content. (default nil)
	 dotspacemacs-enable-paste-micro-state nil
	 ;; Which-key delay in seconds. The which-key buffer is the popup listing
	 ;; the commands bound to the current keystroke sequence. (default 0.4)
	 dotspacemacs-which-key-delay 0.4
	 ;; Which-key frame position. Possible values are `right', `bottom' and
	 ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
	 ;; right; if there is insufficient space it displays it at the bottom.
	 ;; (default 'bottom)
	 dotspacemacs-which-key-position 'bottom
	 ;; If non nil a progress bar is displayed when spacemacs is loading. This
	 ;; may increase the boot time on some systems and emacs builds, set it to
	 ;; nil to boost the loading time. (default t)
	 dotspacemacs-loading-progress-bar t
	 ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
	 ;; (Emacs 24.4+ only)
	 dotspacemacs-fullscreen-at-startup nil
	 ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
	 ;; Use to disable fullscreen animations in OSX. (default nil)
	 dotspacemacs-fullscreen-use-non-native nil
	 ;; If non nil the frame is maximized when Emacs starts up.
	 ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
	 ;; (default nil) (Emacs 24.4+ only)
	 dotspacemacs-maximized-at-startup nil
	 ;; A value from the range (0..100), in increasing opacity, which describes
	 ;; the transparency level of a frame when it's active or selected.
	 ;; Transparency can be toggled through `toggle-transparency'. (default 90)
	 dotspacemacs-active-transparency 90
	 ;; A value from the range (0..100), in increasing opacity, which describes
	 ;; the transparency level of a frame when it's inactive or deselected.
	 ;; Transparency can be toggled through `toggle-transparency'. (default 90)
	 dotspacemacs-inactive-transparency 90
	 ;; If non nil unicode symbols are displayed in the mode line. (default t)
	 dotspacemacs-mode-line-unicode-symbols t
	 ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
	 ;; scrolling overrides the default behavior of Emacs which recenters the
	 ;; point when it reaches the top or bottom of the screen. (default t)
	 dotspacemacs-smooth-scrolling t
	 ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
	 ;; (default nil)
	 dotspacemacs-smartparens-strict-mode nil
	 ;; Select a scope to highlight delimiters. Possible values are `any',
	 ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
	 ;; emphasis the current one). (default 'all)
	 dotspacemacs-highlight-delimiters 'all
	 ;; If non nil advises quit functions to keep server open when quitting.
	 ;; (default nil)
	 dotspacemacs-persistent-server nil
	 ;; List of search tool executable names. Spacemacs uses the first installed
	 ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
	 ;; (default '("ag" "pt" "ack" "grep"))
	 dotspacemacs-search-tools '("grep" "ag" "pt" "ack")
	 ;; The default package repository used if no explicit repository has been
	 ;; specified with an installed package.
	 ;; Not used for now. (default nil)
	 dotspacemacs-default-package-repository nil
	 ))

(defun dotspacemacs/user-init ()
	"Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put any
user code."
	)

(defun dotspacemacs/user-config ()
	"Configuration function for user code.
 This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  ;; Delete selection mode to enable deletion/replacement of selected region
    (delete-selection-mode 1)
	(beacon-mode 1)
    (golden-ratio-mode 1)

	;; Add key binding jk for ESC
	;;(setq-default evil-escape-key-sequence "jk")
	;;(setq-default evil-escape-key-sequence "kj")
	;;(key-chord-define helm-map "jk" 'minibuffer-keyboard-quit)
	;;(key-chord-define helm-map "kj" 'minibuffer-keyboard-quit)
	;; ---------------------------------------------------------------------------
	;; -------------------- REMAPPING THE ESC KEY WITH KEYCHORD ------------------
	(require 'key-chord)
	(key-chord-mode 1)
	(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
	(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
	;; ---------------------------------------------------------------------------

    ;; (exec-path-from-shell-copy-env "PYTHONPATH")
	;; (setq python-shell-virtualenv-path "/Users/shiff/anaconda3")
	(setq python-shell-interpreter "/Users/shiff/anaconda3/bin/python")
	(add-hook 'python-mode-hook 'anaconda-mode)
	(add-hook 'python-mode-hook 'anaconda-eldoc-mode) ;; docs

	;; Add line nums
	;;(add-hook 'prog-mode-hook #'linum-mode)

	;; tramp - via https://sriramkswamy.github.io/dotemacs/
	(setq tramp-default-method "ssh"
	      tramp-backup-directory-alist backup-directory-alist
	      tramp-ssh-controlmaster-options "ssh"
        ;; speed up ? - via https://www.gnu.org/software/emacs/manual/html_node/tramp/Frequently-Asked-Questions.html
        tramp-completion-reread-directory-timeout nil
        )
    (setq vc-ignore-dir-regexp
          (format "\\(%s\\)\\|\\(%s\\)"
                  vc-ignore-dir-regexp
                  tramp-file-name-regexp))


    (add-hook 'before-save-hook 'delete-trailing-whitespace)

	;;(spacemacs/toggle-spelling-checking-off)
	;; (spacemacs/toggle-syntax-checking-off)
	;; disable flyspell by default
	;; (setq-default dotspacemacs-configuration-layers
	;; 							'((spell-checking :variables spell-checking-enable-by-default nil)))
    ;; (setq-default spell-checking-enable-by-default nil)
    ;;(setq-default spacemacs/toggle-spelling-checking-off)

    ;; bug fix ?
    ;; via https://github.com/syl20bnr/spacemacs/issues/9608#issuecomment-330499394
    (require 'helm-bookmark)
    ;; via https://github.com/syl20bnr/spacemacs/pull/10196#issuecomment-359213211
    (with-eval-after-load 'helm
    (setq helm-display-function 'helm-default-display-buffer))

    dotspacemacs-check-for-update t


	;; Remove fly-spell for markdown and text-files.
	(remove-hook 'text-mode-hook 'enable-flyspell-mode)
	(remove-hook 'markdown-mode-hook 'enable-flyspell-mode)

	;; enable copy/paste from system clipboard in visual mode
	(fset 'evil-visual-update-x-selection 'ignore)
	;; automatically run inferior python process
	(add-hook 'python-mode 'run-python)
	;; persistent highlighting is annoying
	(define-key evil-normal-state-map (kbd "RET")
	  'evil-search-highlight-persist-remove-all)
	;;(setq-default helm-mode-handle-completion-in-region nil)
	;; (setq helm-mode-no-completion-in-region-in-modes
	;;       '(circe-channel-mode
	;;         circe-query-mode
	;;         circe-server-mode)))

	;; latex stuff
	;; full doc previews
	(add-hook 'doc-view-mode-hook 'auto-revert-mode)
	;; auto-fill
	dotspacemacs-configuration-layers '((latex :variables latex-enable-auto-fill t))
	;; folding
	dotspacemacs-configuration-layers '((latex :variables latex-enable-folding t))

	;; from http://blog.sjas.de/posts/spacemacs-essentials.html
	;; syntax highlighting for markdown
	(autoload 'markdown-mode "markdown-mode"
		"Major mode for editing Markdown files" t)
	(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
	;; LaTeX highlighting
	(setq markdown-enable-math t)
	;; pandoc
	(add-hook 'markdown-mode-hook 'pandoc-mode)

	;; font
  (set-face-attribute 'default nil :family "Roboto Mono" :weight 'light) ;; "Inconsolata" :weight 'regular) ;; :weight 'light)
	(set-face-attribute 'default nil :height 145)
	;; (set-face-attribute 'default nil :height 114)
	;; (set-face-attribute 'default nil :height 80)

    ;; plz work
    ;; http://stackoverflow.com/questions/37845243/python-indentation-in-spacemacs-with-hard-tabs-is-off

    ;; local values in this buffer
	(setq indent-tabs-mode nil) ;; nil for spaces, t for tabs
	(setq evil-shift-width 4)
	(setq standard-indent 4)

	;; python mode tabs / auto-spacing
	(add-hook 'python-mode-hook
	          (lambda ()
              (setq-default python-indent-offset 4)
              (setq-default python-indent-levels '(0 4))
							(add-to-list 'write-file-functions 'delete-trailing-whitespace)
              (setq-default evil-shift-width 4)
              (setq-default tab-width 4)
              (setq-default indent-tabs-mode nil);; t) ;; nil for spaces, t for tabs
							;; (setq-default py-indent-tabs-mode t)
	            ))
	;; (add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
	;; (add-hook 'python-mode-hook (lambda ()
	;;                               (guess-style-guess-tab-width)))

    ;; fix lockfiles
    ;; https://github.com/syl20bnr/spacemacs/issues/5186
    ;; (setq recentf-save-file (format "/tmp/recentf.%s" (emacs-pid)))

    ;; https://sriramkswamy.github.io/dotemacs/
    ;; better autosave
    ;; Backups at .tmp folder in the current folder
    (setq backup-by-copying t      ; don't clobber symlinks
          backup-directory-alist
          '(("." . "~/.tmp"))      ; don't litter my fs tree
          delete-old-versions t
          kept-new-versions 6
          kept-old-versions 2
          version-control t)       ; use versioned backups
    (setq auto-save-file-name-transforms `((".*", temporary-file-directory t))
          create-lockfiles nil)
    (setq-default create-lockfiles nil)

    ;; better sentences
    (setq sentence-end-double-space nil)
    ;; pdfs
    (setq doc-view-continuous t)

)


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-mime lv transient org-category-capture dash-functional ghub treepy graphql web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data auctex-latexmk yapfify xterm-color ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package unfill toc-org spaceline powerline smeargle shell-pop reveal-in-osx-finder restart-emacs rainbow-delimiters pyvenv pytest pyenv-mode py-isort popwin pip-requirements persp-mode pcre2el pbcopy paradox spinner pandoc-mode ox-pandoc ht osx-trash osx-dictionary orgit org-projectile org-present org-pomodoro alert log4e gntp org-plus-contrib org-download org-bullets open-junk-file neotree mwim multi-term move-text mmm-mode markdown-toc markdown-mode magit-gitflow lorem-ipsum live-py-mode linum-relative link-hint launchctl key-chord info+ indent-guide hydra hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make projectile helm-gitignore request helm-flx helm-descbinds helm-company helm-c-yasnippet helm-ag google-translate golden-ratio gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md fuzzy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck pkg-info epl flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit magit-popup git-commit with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight eshell-z eshell-prompt-extras esh-help dumb-jump diminish diff-hl cython-mode company-statistics company-auctex company-anaconda company column-enforce-mode clean-aindent-mode bind-map bind-key beacon seq auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary auctex anaconda-mode pythonic f dash s aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
