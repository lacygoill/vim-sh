fu! sh#clean_zsh_history() abort "{{{1
    " TODO: handle the case where we delete the first line of a multi-line command;
    " we need to remove the others too.
    "
    " I think this pattern matches a line which doesn't end with `\` (continuation
    " line), and whose next line doesn't begin with a colon:
    "         [^\\]\_$\n[^:]
    "
    " This is the kind of line which could remain after deleting the first line of
    " a multi-line command.

    sil! g/\v:\s+\d+:\d+;\w\s/d_
    let cmds = [
    \            'api',
    \            'app',
    \            'aps',
    \            'cd',
    \            'cp',
    \            'echo',
    \            'ls',
    \            'man',
    \            'mkdir',
    \            'rm',
    \            'rmdir',
    \            'sleep',
    \            'touch',
    \            'web',
    \          ]

    sil! exe 'g/\v:\s+\d+:\d+;%(sudo\s+)?%('.join(cmds, '|').')%(\s|$)/d_'
endfu

fu! sh#shellcheck_loclist() abort "{{{1
" FIXME:
" consider this line:
"
"     echo `echo $i`
"
" `shellcheck` find 6 errors.
" Our `shellcheck_loclist()` function can only display one or two errors.

    let output = system('shellcheck '.shellescape(expand('%:p')))
    let errors = split(output, "\n\n")

    let loclist = []
    for error in errors
        if match(error, '^\nin') != -1
            let lnum = matchstr(error, '\nin.\{-}\zs\d\+\ze:\n')
            let text = matchstr(error, 'SC\d\+.*')
            let col  = match(matchstr(error, ':\n.*\n\zs.*'), '\^') + 1
            call add(loclist, {'bufnr': bufnr('%'), 'lnum': lnum, 'col': col, 'text': text })
        endif
    endfor
    if empty(loclist)
        echo 'No errors'
        lclose
        return
    endif

    sil! call lg#motion#repeatable#make#set_last_used(']l', {'bwd': ',', 'fwd': ';'})

    call setloclist(0, loclist)
    call setloclist(0, [], 'a', { 'title': 'Errors' })
    doautocmd <nomodeline> QuickFixCmdPost lopen

    if &bt !=# 'quickfix'
        return
    endif

    call qf#set_matches('sh:shellcheck_loclist', 'Conceal', '\v^.{-}SC\d{-1,}:')
    call qf#create_matches()

    " get out of quickfix window, back to our shell buffer
    wincmd p
endfu

fu! sh#shellcheck_raw_output() abort "{{{1
    let output = system('shellcheck '.shellescape(expand('%:p')))
    if empty(output)
        echo 'No errors'
        return
    endif
    let view = winsaveview()

    new
    setl bh=wipe nobl bt=nofile noswf nowrap
    if !bufexists('shellcheck') | sil file shellcheck | endif

    sil 0put =output

    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>

    $-,$d_ | 1d_
    setl noma ro

    wincmd p | call winrestview(view)
    call sh#shellcheck_loclist()
endfu
