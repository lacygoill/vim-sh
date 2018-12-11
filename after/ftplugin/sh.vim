" Commands {{{1

com! -bar -buffer -nargs=1 ShellCheckWiki call sh#shellcheck_wiki(<q-args>)

" Mappings {{{1

nno  <buffer><nowait><silent>  K       :<c-u>call lg#man_k('bash')<cr>
" If you need a buggy shell script to test the linter:
"     $ echo 'echo `echo $i`' >/tmp/sh.sh
nno  <buffer><nowait><silent>  <bar>c  :<c-u>compiler shellcheck<bar>sil lmake!<bar>redraw!<cr>

noremap  <buffer><expr><nowait><silent>  [[  lg#motion#regex#rhs('{{',0)
noremap  <buffer><expr><nowait><silent>  ]]  lg#motion#regex#rhs('{{',1)

noremap  <buffer><expr><nowait><silent>  [m  lg#motion#regex#rhs('sh_fu',0)
noremap  <buffer><expr><nowait><silent>  ]m  lg#motion#regex#rhs('sh_fu',1)

noremap  <buffer><expr><nowait><silent>  [M  lg#motion#regex#rhs('sh_endfu',0)
noremap  <buffer><expr><nowait><silent>  ]M  lg#motion#regex#rhs('sh_endfu',1)

if stridx(&rtp, 'vim-lg-lib') >= 0
    call lg#motion#repeatable#make#all({
        \ 'mode': '',
        \ 'buffer': 1,
        \ 'axis': {'bwd': ',', 'fwd': ';'},
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

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \ setl kp< sts< sw< ts< tw<
    \
    \|nunmap <buffer> K
    \|nunmap <buffer> <bar>c
    \|nunmap <buffer> [[
    \|nunmap <buffer> ]]
    \|nunmap <buffer> [m
    \|nunmap <buffer> ]m
    \|nunmap <buffer> [M
    \|nunmap <buffer> ]M
    \
    \|delc ShellCheckWiki
    \"

