fu sh#shellcheck_wiki(number) abort "{{{1
    let url = 'https://github.com/koalaman/shellcheck/wiki/SC' . a:number
    let cmd = 'xdg-open ' . shellescape(url)
    sil call system(cmd)
endfu

fu sh#shellcheck_complete(_a, _l, _p) abort "{{{1
    return join(map(getloclist(0), {_,v -> v.nr}), "\n")
endfu

fu sh#undo_ftplugin() abort "{{{1
    setl efm< mp< sts< sw< ts< tw<
    set kp<

    nunmap <buffer> K
    nunmap <buffer> [[
    nunmap <buffer> ]]
    nunmap <buffer> [m
    nunmap <buffer> ]m
    nunmap <buffer> [M
    nunmap <buffer> ]M

    delc ShellCheckWiki
endfu
