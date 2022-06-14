" via https://stackoverflow.com/a/34645680

" This gets rid of the nasty _ italic bug in tpope's vim-markdown
" block $$...$$
syn region multilinemath start=/\$\$/ end=/\$\$/
syn region multilinemath start=/\\begin{align}/ end=/\\end{align}/
syn region multilinemath start=/\\begin{align\*}/ end=/\\end{align\*}/

" inline math $...$
syn match math '\$[^$].\{-}\$'

" actually highlight the region we defined as "math"
hi link math String
hi link multilinemath Statement
