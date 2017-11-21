fu! sh#fold_text() abort "{{{1
    let indent = repeat(' ', (v:foldlevel-1)*3)
    let title  = substitute(getline(v:foldstart), '\v^\s*#\s*|\s*#?\{\{\{\d?', '', 'g')
    let title  = substitute(title, '\v^.*\zs\(\)\s*%(\{|\()', '', '')

    if get(b:, 'my_title_full', 0)
        let foldsize  = (v:foldend - v:foldstart)
        let linecount = '['.foldsize.']'.repeat(' ', 4 - strchars(foldsize))
        return indent.' '.linecount.' '.title
    else
        return indent.' '.title
    endif
endfu

fu! sh#man_k(pgm) abort "{{{1
    let cur_word = expand('<cword>')
    let g:cur_word = deepcopy(cur_word)
    exe 'Man '.a:pgm

    try
        " populate location list
        exe 'lvim /\<\C'.cur_word.'\>/ %'
        " set its title
        call setloclist(0, [], 'a', { 'title': cur_word })

        " Hit `[L` and then `[l`, so that we can move across the matches with
        " `;` and `,`.
        sil! norm [L
        sil! norm [l
    catch
        try
            sil exe 'Man '.cur_word
        catch
            " If the word under the cursor is not present in any man page, quit.
            quit
            " FIXME:
            " If I hit `K` on a garbage word inside a shell script, the function
            " doesn't quit, because `:Man garbage_word` isn't considered an error.
            " If it was considered an error `:silent` wouldn't be enough to
            " hide the warning message. We would have to add a bang.
            " The problem comes from `man#open_page()` inside
            " ~/.vim/plugged/vim-man/autoload/man.vim
            "
            " When it receives an optional word as an argument, and there's no
            " manual page for it, the function calls `s:error()`. The latter
            " don't raise any exception. Maybe we could use `:throw`, although
            " I don't know how it works exactly. But then we would have errors
            " when we execute `:Man garbage_word` manually.
        endtry
    endtry
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
    else
        " position the cursor on first error
        sil! norm [L
        " make next motions with `;` and `,` repeat `]l` and `]l`,
        " instead of `]L` and `[L`
        sil! norm [l
    endif

    call setloclist(0, loclist)
    call setloclist(0, [], 'a', { 'title': 'Errors' })
    lwindow

    if &l:buftype !=# 'quickfix'
        return
    endif

    setl cocu=nc cole=3
    let pat = '\v^.{-}SC\d{-1,}:'
    call matchadd('Conceal', pat, 0, -1, {'conceal': 'x'})

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

    nno <buffer> <nowait> <silent> q    :<c-u>close<cr>

    $-,$d_ | 1d_
    setl noma ro

    wincmd p | call winrestview(view)
    call sh#shellcheck_loclist()
endfu
