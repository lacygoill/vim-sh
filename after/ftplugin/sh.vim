" Commands {{{1

" Purpose: Get more information about an error found by shellcheck.
" There's no need to run `shellcheck` in the shell to get the error number.{{{
"
" When you run the linter in Vim (press `|c` at the moment), the error number is
" given in the qf window:
"
"     /tmp/sh.sh  |3 col 8 n 2016  | Expressions don't expand in single quotes, use double quotes for that.
"                            ^--^
"}}}
com -bar -buffer -nargs=1 -complete=custom,sh#shellcheck_complete ShellCheckWiki call sh#shellcheck_wiki(<q-args>)

" Mappings {{{1

nno <buffer><expr><nowait> =rb sh#break_long_cmd()

noremap <buffer><expr><nowait> [m brackets#move#regex('sh_fu', v:false)
noremap <buffer><expr><nowait> ]m brackets#move#regex('sh_fu', v:true)

noremap <buffer><expr><nowait> [M brackets#move#regex('sh_endfu', v:false)
noremap <buffer><expr><nowait> ]M brackets#move#regex('sh_endfu', v:true)

sil! call repmap#make#repeatable({
    \ 'mode': '',
    \ 'buffer': v:true,
    \ 'from': expand('<sfile>:p') .. ':' .. expand('<slnum>'),
    \ 'motions': [
    \     {'bwd': '[m', 'fwd': ']m'},
    \     {'bwd': '[M', 'fwd': ']M'},
    \ ]})

" Options {{{1

setl sts=2
setl sw=2
setl ts=2
setl tw=80
" When I press `K` on a command name, Vim starts `less(1)`.  I want to read the documentation in a Vim buffer!{{{
"
" The current behavior is due to these lines in the default zsh filetype plugin:
"
"     " $VIMRUNTIME/ftplugin/zsh.vim
"     setlocal keywordprg=:RunHelp
"     command! -buffer -nargs=1 RunHelp
"     \ silent exe '!zsh -ic "autoload -Uz run-help; run-help <args> 2>/dev/null | LESS= less"' | redraw!
"
" Solution1:
"
"     setl kp=:Man
"
" Solution2:
"
" In `less(1)`, press `E` (custom key binding) to read the contents of the pager
" in a Vim buffer.
"
" For the moment, I prefer the second solution, because it runs the zsh function
" `run-help` which – before printing a manpage  – tries find a help file in case
" the argument is a builtin command name.
"}}}

" If you need a buggy shell script to test the linter:
"     $ echo 'echo `echo $i`' >/tmp/sh.sh
compiler shellcheck

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| call sh#undo_ftplugin()'

