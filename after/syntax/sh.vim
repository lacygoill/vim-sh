" syntax {{{1

syn cluster shAnyComment contains=shComment,shQuickComment,zshComment

" replace noisy/ugly markers, used in folds, with ❭ and ❬
exe 'syn match shFoldMarkers  /#\?\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=@shAnyComment'
exe 'syn match shFoldMarkers  /#\?\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=@shAnyComment'

syn region shBackticks  matchgroup=Comment  start=/`/  end=/`/  oneline concealends containedin=@shAnyComment

" colors {{{1

hi link  shBackticks  Backticks

