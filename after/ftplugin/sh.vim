vim9script

# Commands {{{1

# Purpose: Get more information about an error found by shellcheck.
# There's no need to run `shellcheck` in the shell to get the error number.{{{
#
# When you run the linter in Vim (press `|c` at the moment), the error number is
# given in the qf window:
#
#     /tmp/sh.sh  |3 col 8 n 2016  | Expressions don't expand in single quotes, use double quotes for that.
#                            ^--^
#}}}
command -bar -buffer -nargs=1 -complete=custom,sh#shellcheckComplete
    \ ShellCheckWiki sh#shellcheckWiki(<q-args>)

# Mappings {{{1

nnoremap <buffer><expr><nowait> =rb sh#breakLongCmd()

map <buffer><nowait> ]m <Plug>(next-func-start)
map <buffer><nowait> [m <Plug>(prev-func-start)
noremap <buffer><expr> <Plug>(next-func-start) brackets#move#regex('sh-func-start')
noremap <buffer><expr> <Plug>(prev-func-start) brackets#move#regex('sh-func-start', v:false)
silent! submode#enter('sh-func-start', 'nx', 'br', ']m', '<Plug>(next-func-start)')
silent! submode#enter('sh-func-start', 'nx', 'br', '[m', '<Plug>(prev-func-start)')

map <buffer><nowait> ]M <Plug>(next-func-end)
map <buffer><nowait> [M <Plug>(prev-func-end)
noremap <buffer><expr> <Plug>(next-func-end) brackets#move#regex('sh-func-end')
noremap <buffer><expr> <Plug>(prev-func-end) brackets#move#regex('sh-func-end', v:false)
silent! submode#enter('sh-func-end', 'nx', 'br', ']M', '<Plug>(next-func-end)')
silent! submode#enter('sh-func-end', 'nx', 'br', '[M', '<Plug>(prev-func-end)')

# Options {{{1

&l:shiftwidth = 2
&l:textwidth = 80
# When I press `K` on a command name, Vim starts `less(1)`.  I want to read the documentation in a Vim buffer!{{{
#
# The current behavior is due to these lines in the default zsh filetype plugin:
#
#     # $VIMRUNTIME/ftplugin/zsh.vim
#     setlocal keywordprg=:RunHelp
#     command! -buffer -nargs=1 RunHelp
#     \ silent execute '!zsh -ic "autoload -Uz run-help; run-help <args> 2>/dev/null | LESS= less"' | redraw!
#
# Solution1:
#
#     &l:keywordprg = ':Man'
#
# Solution2:
#
# In `less(1)`, press `E` (custom key binding) to read the contents of the pager
# in a Vim buffer.
#
# For the moment, I prefer the second solution, because it runs the zsh function
# `run-help` which – before printing a manpage  – tries find a help file in case
# the argument is a builtin command name.
#}}}

# If you need a buggy shell script to test the linter:
#     $ echo 'echo `echo $i`' >/tmp/sh.sh
compiler shellcheck

# Teardown {{{1

b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
    .. '| call sh#undoFtplugin()'

