fu! sh#shellcheck_loclist() abort "{{{1
" FIXME:
" consider this line:
"
"     echo `echo $i`
"
" `shellcheck` find 6 errors.
" Our `shellcheck_loclist()` function can only display one or two errors.

    let output = system('shellcheck '.expand('%:p:S'))
    let errors = split(output, "\n\n")

    let loclist = []
    for error in errors
        if match(error, '^\nin') !=# -1
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
    do <nomodeline> QuickFixCmdPost lopen

    call qf#set_matches('sh:shellcheck_loclist', 'Conceal', '\v^.{-}SC\d{-1,}:')
    call qf#create_matches()

    " get out of quickfix window, back to our shell buffer
    wincmd p
endfu

fu! sh#shellcheck_wiki(number) abort "{{{1
    let url = 'https://github.com/koalaman/shellcheck/wiki/SC'.a:number
    let cmd = 'xdg-open '.string(url)
    call system(cmd)
endfu

fu! sh#shellcheck_raw_output() abort "{{{1
    let output = systemlist('shellcheck '.expand('%:p:S'))
    if empty(output)
        echo 'No errors'
        return
    endif
    let view = winsaveview()

    let tempfile = tempname().'/shellcheck'
    exe 'new '.tempfile
    setl bt=nofile nobl noswf nowrap

    call setline(1, output)

    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>

    wincmd p | call winrestview(view)
    call sh#shellcheck_loclist()
endfu

