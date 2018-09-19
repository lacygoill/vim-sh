" Commands {{{1

com! -bar -buffer -nargs=1 ShellCheckWiki call sh#shellcheck_wiki(<q-args>)

" Mappings {{{1

nno  <buffer><nowait><silent>  K       :<c-u>call lg#man_k('bash')<cr>
nno  <buffer><nowait><silent>  <bar>c  :<c-u>call sh#shellcheck_loclist()<cr>
nno  <buffer><nowait><silent>  <bar>C  :<c-u>call sh#shellcheck_raw_output()<cr>

noremap  <buffer><expr><nowait><silent>  [[  lg#motion#regex#rhs('{{',0)
noremap  <buffer><expr><nowait><silent>  ]]  lg#motion#regex#rhs('{{',1)

noremap  <buffer><expr><nowait><silent>  [m  lg#motion#regex#rhs('sh_fu',0)
noremap  <buffer><expr><nowait><silent>  ]m  lg#motion#regex#rhs('sh_fu',1)

noremap  <buffer><expr><nowait><silent>  [M  lg#motion#regex#rhs('sh_endfu',0)
noremap  <buffer><expr><nowait><silent>  ]M  lg#motion#regex#rhs('sh_endfu',1)

if has_key(get(g:, 'plugs', {}), 'vim-lg-lib')
    call lg#motion#repeatable#make#all({
    \        'mode':   '',
    \        'buffer': 1,
    \        'axis':   {'bwd': ',', 'fwd': ';'},
    \        'from':   expand('<sfile>:p').':'.expand('<slnum>'),
    \        'motions': [
    \                     {'bwd': '[m',  'fwd': ']m', },
    \                     {'bwd': '[M',  'fwd': ']M', },
    \                     {'bwd': '[[',  'fwd': ']]', },
    \                   ]
    \ })
endif

" Options {{{1

augroup my_sh
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
                           \ | setl fdt=fold#text()
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
                    \      setl cocu< cole< fdm< fdt< kp< sts< sw< ts< tw<
                    \    | exe 'au!  my_sh * <buffer>'
                    \    | exe 'nunmap <buffer> K'
                    \    | exe 'nunmap <buffer> <bar>c'
                    \    | exe 'nunmap <buffer> <bar>C'
                    \    | exe 'nunmap <buffer> [['
                    \    | exe 'nunmap <buffer> ]]'
                    \    | exe 'nunmap <buffer> [m'
                    \    | exe 'nunmap <buffer> ]m'
                    \    | exe 'nunmap <buffer> [M'
                    \    | exe 'nunmap <buffer> ]M'
                    \    | delc ShellCheckWiki
                    \  "
