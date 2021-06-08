vim9script

g:current_compiler = 'shellcheck'

# https://vimways.org/2018/runtime-hackery/
CompilerSet errorformat=%f:%l:%c:\ %t%*[^:]:\ %m\ [SC%n]
CompilerSet makeprg=shellcheck\ -s\ bash\ -f\ gcc\ %:p:S
#                               ├──────┘  ├─────┘{{{
#                               │         └ GCC compatible output.
#                               │           Useful for editors that support compiling and showing syntax errors.
#                               │
#                               └ Specify Bash shell dialect.
#}}}
