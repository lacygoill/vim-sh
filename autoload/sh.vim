vim9script noclear

def sh#breakLongCmd(type = ''): string #{{{1
    if type == ''
        &operatorfunc = 'sh#breakLongCmd'
        return 'g@l'
    endif

    if !executable('zsh')
        echohl Error
        echo 'requires zsh, but zsh is not installed'
        echohl NONE
        return
    endif

    # get new refactored shell command
    var shell_save: string
    if &shell =~ '\Czsh'
        shell_save = &shell
        &shell = 'zsh'
    endif
    var lnum: number = line('.')
    var old: string = getline(lnum)
    sil var new: list<string> = systemlist('cmd=' .. shellescape(old) .. "; printf -- '%s\n' ${${(z)cmd}[@]}")
    if shell_save != ''
        &shell = shell_save
    endif

    # add indentation for lines after the first one
    var curindent: string = old->matchstr('^\s*')
    new
        ->map((i: number, v: string): string => i > 0 ? curindent .. '    ' .. v : curindent .. v)
        # add line continuations for lines before the last one
        ->map((i: number, v: string): string => i < len(new) - 1 ? v .. ' \' : v)

    # replace old command with new one
    var reg_save: dict<any> = getreginfo('"')
    reg_save
        ->deepcopy()
        ->extend({regcontents: new, regtype: 'l'})
        ->setreg('"')
    exe 'norm! ' .. lnum .. 'GVp'
    setreg('"', reg_save)

    # join lines which don't start with an option with the previous one (except for the very first line)
    var range: string = ':' .. (lnum + 1) .. ',' .. (lnum + len(new) - 1)
    exe 'sil ' .. range .. 'g/^\s*[^-+ ]/-s/\\$//|j'
    #                               ^^
    #                               options usually start with a hyphen, but also – sometimes – with a plus
enddef

def sh#shellcheckWiki(errorcode: string) #{{{1
    var url: string = 'https://github.com/koalaman/shellcheck/wiki/SC' .. errorcode
    var cmd: string = 'xdg-open ' .. shellescape(url)
    sil system(cmd)
enddef

def sh#shellcheckComplete(_, _, _): string #{{{1
    return getloclist(0)
        ->mapnew((_, v: dict<any>): number => v.nr)
        ->join("\n")
enddef

def sh#undoFtplugin() #{{{1
    set errorformat< makeprg< shiftwidth< textwidth<

    nunmap <buffer> =rb

    nunmap <buffer> [m
    nunmap <buffer> ]m
    nunmap <buffer> [M
    nunmap <buffer> ]M

    delc ShellCheckWiki
enddef
