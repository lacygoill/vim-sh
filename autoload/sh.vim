fu sh#break_long_cmd(...) abort "{{{1
    if !a:0
        let &opfunc = 'sh#break_long_cmd'
        return 'g@l'
    endif

    if !executable('zsh')
        echohl Error
        echo 'requires zsh, but zsh is not installed'
        echohl NONE
        return
    endif

    " get new refactored shell command
    if &shell =~# '\Czsh'
        let shell_save = &shell
        set shell=zsh
    endif
    let lnum = line('.')
    let old = getline(lnum)
    sil let new = systemlist('cmd=' .. shellescape(old) .. "; printf -- '%s\n' ${${(z)cmd}[@]}")
    if exists('shell_save')
        let &shell = shell_save
    endif

    " add indentation for lines after the first one
    let curindent = matchstr(old, '^\s*')
    call map(new, {i, v -> i > 0 ? curindent .. '    ' .. v : curindent .. v})
    " add line continuations for lines before the last one
    call map(new, {i, v -> i < len(new) - 1 ? v .. ' \' : v})

    " replace old command with new one
    let reg_save = getreginfo('"')
    call deepcopy(reg_save)
        \ ->extend({'regcontents': new, 'regtype': 'l'})
        \ ->setreg('"')
    exe 'norm! ' .. lnum .. 'GVp'
    call setreg('"', reg_save)

    " join lines which don't start with an option with the previous one (except for the very first line)
    let range = (lnum+1) .. ',' .. (lnum + len(new) - 1)
    sil exe range .. 'g/^\s*[^-+ ]/-s/\\$//|j'
    "                         ^^
    "                         options usually start with a hyphen, but also – sometimes – with a plus
endfu

fu sh#shellcheck_wiki(number) abort "{{{1
    let url = 'https://github.com/koalaman/shellcheck/wiki/SC' .. a:number
    let cmd = 'xdg-open ' .. shellescape(url)
    sil call system(cmd)
endfu

fu sh#shellcheck_complete(_a, _l, _p) abort "{{{1
    return getloclist(0)->map({_, v -> v.nr})->join("\n")
endfu

fu sh#undo_ftplugin() abort "{{{1
    set efm< mp< sts< sw< ts< tw<

    nunmap <buffer> =rb

    nunmap <buffer> [m
    nunmap <buffer> ]m
    nunmap <buffer> [M
    nunmap <buffer> ]M

    delc ShellCheckWiki
endfu
