" NO GUARD
" otherwise our ftplugin would never be sourced, because a previous
" ftplugin already set the variable `b:did_ftplugin` (hit `gF`):
"
"         $VIMRUNTIME/ftplugin/sh.vim:8

" Commands {{{1

com! -buffer CleanZshHistory call sh#clean_zsh_history()

" Mappings {{{1

nno <buffer> <nowait> <silent>  K       :<c-u>call sh#man_k('bash')<cr>
nno <buffer> <nowait> <silent>  <bar>c  :<c-u>call sh#shellcheck_loclist()<cr>
nno <buffer> <nowait> <silent>  <bar>C  :<c-u>call sh#shellcheck_raw_output()<cr>

" Options {{{1

augroup my_sh
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
                           \ | let &l:fdt = 'sh#fold_text()'
                           \ | setl cocu=nc
                           \ | setl cole=3
augroup END

setl kp=:Man
setl sts=2
setl sw=2
setl ts=2
setl tw=80

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   setl cocu< cole< fdm< fdt< kp< sts< sw< ts< tw<
                    \|  exe 'nunmap <buffer> K'
                    \|  exe 'nunmap <buffer> <bar>c'
                    \|  exe 'nunmap <buffer> <bar>C'
                    \|  exe 'au!  my_sh * <buffer>'
                    \|  exe 'aug! my_sh'
                    \|  delcommand CleanZshHistory
                    \  "