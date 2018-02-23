" syntax {{{1

syn cluster shAnyComment contains=shComment,shQuickComment,zshComment

" replace noisy/ugly markers, used in folds, with ❭ and ❬
"                           ┌ get rid of it once we've concealed comment leaders
"                         ┌─┤
exe 'syn match shFoldMarkers  /#\?\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=@shAnyComment'
exe 'syn match shFoldMarkers  /#\?\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=@shAnyComment'


" :syn list shComment
"
"         shComment      xxx match /^\s*\zs#.*$/  contains=@shCommentGroup
"                            match /\s\zs#.*$/    contains=@shCommentGroup
"                            match /#.*$/         contains=@shCommentGroup contained
"                            links to Comment
"
" :syn list @shCommentGroup
"
"         shCommentGroup cluster=shTodo,@Spell
"
" :syn list shTodo
"
"         shTodo         xxx match /\<\%(COMBAK\|FIXME\|TODO\|XXX\)\ze:\=\>/  contained
"                            links to Todo
"
" :syn list shQuickComment
"
"         shQuickComment xxx match /#.*$/  contained
"                            links to shComment
"
" :syn list zshComment
"
"         zshComment     xxx start=/\%(^\|\s*\)#/ end=/$/  oneline fold contains=zshTodo,@Spell
"                            start=/^\s*#/ end=/^\%(\s*#\)\@!/  fold contains=zshTodo,@Spell
"                            links to Comment

" Redefine the `shComment` group, because we want to conceal the comment leader.
"
" Originally:
"         syn match shComment /#.*/ contains=@Spell,shTodo
syn region  shComment      matchgroup=Comment  start=/^\s*\zs#@\@!\s\?/  end=/$/  concealends contains=@Spell,shTodo
syn region  shCommentCode  matchgroup=Number   start=/^\s*\zs#@\s\?/     end=/$/  concealends containedin=ALL
syn region  shBackticks    matchgroup=Comment  start=/`/                 end=/`/  oneline concealends containedin=@shAnyComment

" colors {{{1

hi link  shComment      Comment
hi link  shCommentCode  Number
hi link  shBackticks    Backticks
