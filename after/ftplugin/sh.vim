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
com -bar -buffer -complete=custom,sh#shellcheck_complete -nargs=1 ShellCheckWiki call sh#shellcheck_wiki(<q-args>)

" Mappings {{{1

nno <buffer><nowait><silent> =rb :<c-u>set opfunc=sh#break_long_cmd<cr>g@l

noremap <buffer><expr><nowait><silent> [m brackets#move#regex('sh_fu',0)
noremap <buffer><expr><nowait><silent> ]m brackets#move#regex('sh_fu',1)

noremap <buffer><expr><nowait><silent> [M brackets#move#regex('sh_endfu',0)
noremap <buffer><expr><nowait><silent> ]M brackets#move#regex('sh_endfu',1)

sil! call repmap#make#all({
    \ 'mode': '',
    \ 'buffer': 1,
    \ 'from': expand('<sfile>:p').':'.expand('<slnum>'),
    \ 'motions': [
    \     {'bwd': '[m',  'fwd': ']m'},
    \     {'bwd': '[M',  'fwd': ']M'},
    \ ]})

" Options {{{1

setl sts=2
setl sw=2
setl ts=2
setl tw=80

" If you need a buggy shell script to test the linter:
"     $ echo 'echo `echo $i`' >/tmp/sh.sh
compiler shellcheck

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| call sh#undo_ftplugin()'

