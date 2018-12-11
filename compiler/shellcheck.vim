let current_compiler = 'shellcheck'

" Old Vim versions don't automatically define `:CompilerSet`.
if exists(':CompilerSet') !=# 2
    com -nargs=* CompilerSet setl <args>
endif

" https://vimways.org/2018/runtime-hackery/
CompilerSet efm=%f:%l:%c:\ %t%*[^:]:\ %m\ [SC%n]
CompilerSet mp=shellcheck\ -s\ bash\ -f\ gcc\ --\ %:S
"                          ├──────┘  ├─────┘{{{
"                          │         └ GCC compatible output.
"                          │           Useful for editors that support compiling and showing syntax errors.
"                          │
"                          └ Specify Bash shell dialect.
"}}}
