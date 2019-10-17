" Commands {{{1

" Purpose: Get more information about an error found by shellcheck.
" There's no need to run `shellcheck` in the shell to get the error number.{{{
"
" When you run the linter in Vim (press `|c` at the moment), the error number is
" given in the qf window:
"
"     /tmp/sh.sh  |3 col 8 n 2016  | Expressions don't expand in single quotes, use double quotes for that.
"                            ^^^^
"}}}
com -bar -buffer -complete=custom,sh#complete_shellcheck -nargs=1 ShellCheckWiki call sh#shellcheck_wiki(<q-args>)

" Mappings {{{1

nno <buffer><nowait><silent> K :<c-u>call lg#man_k('bash')<cr>

noremap <buffer><expr><nowait><silent> [[ lg#motion#regex#rhs('{{',0)
noremap <buffer><expr><nowait><silent> ]] lg#motion#regex#rhs('{{',1)

noremap <buffer><expr><nowait><silent> [m lg#motion#regex#rhs('sh_fu',0)
noremap <buffer><expr><nowait><silent> ]m lg#motion#regex#rhs('sh_fu',1)

noremap <buffer><expr><nowait><silent> [M lg#motion#regex#rhs('sh_endfu',0)
noremap <buffer><expr><nowait><silent> ]M lg#motion#regex#rhs('sh_endfu',1)

if stridx(&rtp, 'vim-lg-lib') >= 0
    call lg#motion#repeatable#make#all({
        \ 'mode': '',
        \ 'buffer': 1,
        \ 'from': expand('<sfile>:p').':'.expand('<slnum>'),
        \ 'motions': [
        \     {'bwd': '[m',  'fwd': ']m'},
        \     {'bwd': '[M',  'fwd': ']M'},
        \     {'bwd': '[[',  'fwd': ']]'},
        \ ]})
endif

" Options {{{1

setl kp=:Man
setl sts=2
setl sw=2
setl ts=2
setl tw=80

" If you need a buggy shell script to test the linter:
"     $ echo 'echo `echo $i`' >/tmp/sh.sh
compiler shellcheck

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'
    \ | setl efm< mp< sts< sw< ts< tw<
    \ | set kp<
    \
    \ | exe "nunmap <buffer> K"
    \ | exe "nunmap <buffer> [["
    \ | exe "nunmap <buffer> ]]"
    \ | exe "nunmap <buffer> [m"
    \ | exe "nunmap <buffer> ]m"
    \ | exe "nunmap <buffer> [M"
    \ | exe "nunmap <buffer> ]M"
    \
    \ | delc ShellCheckWiki
    \ '

