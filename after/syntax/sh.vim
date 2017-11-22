" syntax {{{1

syn cluster shAnyComment contains=shComment,shQuickComment,zshComment

" replace noisy/ugly markers, used in folds, with ❭ and ❬
"                           ┌ get rid of it once we've concealed comment leaders
"                         ┌─┤
syn match shFoldMarkers  /#\?\s*{{{\d*\s*\ze\n/  conceal cchar=❭  containedin=@shAnyComment
syn match shFoldMarkers  /#\?\s*}}}\d*\s*\ze\n/  conceal cchar=❬  containedin=@shAnyComment


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
"         syn match shComment /#.*/ contains=@Spell,shTodo    ✘
" syn region shComment matchgroup=Comment start=/^\s*\zs#@\@!/ end=/$/ concealends contains=@Spell,shTodo    ✘

syn match shCommentCode    "^\s*#@.*"   containedin=@shAnyComment contains=shCommentCode
syn match shCommentCodeAt  "^\s*#\zs@"  conceal

" colors {{{1

hi link shCommentCode Number

" syntax {{{2
"
" Redefine the `awkComment` group, because we want to conceal the comment leader.
"
" Originally:
"           syn match awkComment /#.*/ contains=@Spell,awkTodo
" syn region awkComment matchgroup=Comment start=/^\s*\zs#@\@!/ end=/$/ concealends contains=@Spell,awkTodo
"
" replace noisy markers, used in folds, with ❭ and ❬
" syn match awkFoldMarkers  /\s*{{{\d*\s*\ze\n/  conceal cchar=❭  containedin=awkComment
" syn match awkFoldMarkers  /\s*}}}\d*\s*\ze\n/  conceal cchar=❬  containedin=awkComment
"
" define a syntax group for commented code
" syn region awkCommentCode matchgroup=Number start=/^\s*\zs#@/ end=/$/ containedin=awkComment concealends
"
" by default, `awkTodo` only contains the keyword `TODO`
" syn keyword awkTodo contained TODO FIXME XXX
"                     │
"                     └─ the group will be recognized only if it is mentioned
"                        in the "contains" field of another match; i.e.:
"
"                               syn … contains=awkTodo
"
" colors {{{2
"
" hi link  awkComment      Comment
" hi link  awkCommentCode  Number