fu! sh#shellcheck_wiki(number) abort "{{{1
    let url = 'https://github.com/koalaman/shellcheck/wiki/SC'.a:number
    let cmd = 'xdg-open '.string(url)
    sil call system(cmd)
endfu

