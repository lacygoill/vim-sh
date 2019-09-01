fu! sh#shellcheck_wiki(number) abort "{{{1
    let url = 'https://github.com/koalaman/shellcheck/wiki/SC' . a:number
    let cmd = 'xdg-open ' . shellescape(url)
    sil call system(cmd)
endfu

fu! sh#complete_shellcheck(_arglead, _cmdline, _pos) abort
    return join(map(getloclist(0), {_,v -> v.nr}), "\n")
endfu

