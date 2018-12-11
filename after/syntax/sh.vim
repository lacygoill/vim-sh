" Redefine the `shComment` group to include our custom `shCommentTitle` item.{{{
"
" The latter is defined in `lg#styled_comment#syntax()`:
"
"     ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim
"}}}
syn clear shComment
syn match shComment /^\s*\zs#.*$/  contains=@shCommentGroup,shCommentTitle
syn match shComment /\s\zs#.*$/  contains=@shCommentGroup,shCommentTitle
syn match shComment /#.*$/  contained contains=@shCommentGroup,shCommentTitle

