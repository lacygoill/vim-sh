" NO GUARD
" otherwise our ftplugin would never be sourced, because a previous
" ftplugin already set the variable `b:did_ftplugin` (hit `gF`):
"
"         $VIMRUNTIME/ftplugin/zsh.vim:12

" load filetype plugin for `sh`

if filereadable($HOME.'/.vim/plugged/vim-sh/after/ftplugin/sh.vim')
    so $HOME/.vim/plugged/vim-sh/after/ftplugin/sh.vim
endif
