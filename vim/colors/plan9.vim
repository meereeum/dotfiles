" via https://github.com/plan9-for-vimspace/acme-colors

highlight clear

if exists("syntax_on")
  syntax reset
endif

set t_Co=256

" original main color: 230
" better for mac: 255

" for cterm, 'black' might get overwritten by the terminal emulator, so we use
" 232 (#080808), which is close enough.

highlight! Normal guibg=#ffffea guifg=#000000 ctermbg=230 ctermfg=232
highlight! NonText guibg=bg guifg=#ffffea ctermbg=bg ctermfg=230
highlight! StatusLine guibg=#aeeeee guifg=#000000 gui=NONE ctermbg=159 ctermfg=232 cterm=NONE
highlight! StatusLineNC guibg=#eaffff guifg=#000000 gui=NONE ctermbg=194 ctermfg=232 cterm=NONE
highlight! WildMenu guibg=#000000 guifg=#eaffff gui=NONE ctermbg=black ctermfg=159 cterm=NONE
highlight! VertSplit guibg=#ffffea guifg=#000000 gui=NONE ctermbg=159 ctermfg=232 cterm=NONE
highlight! Folded guibg=#cccc7c guifg=fg gui=italic ctermbg=187 ctermfg=fg cterm=italic
highlight! FoldColumn guibg=#fcfcce guifg=fg ctermbg=229 ctermfg=fg
highlight! Conceal guibg=bg guifg=fg gui=NONE ctermbg=bg ctermfg=fg cterm=NONE
highlight! LineNr guibg=bg guifg=#505050 gui=italic ctermbg=bg ctermfg=239 cterm=italic
highlight! Visual guibg=fg guifg=bg ctermbg=fg ctermfg=bg
highlight! CursorLine guibg=#ffffca guifg=fg ctermbg=230 ctermfg=fg

highlight! Statement guibg=bg guifg=fg gui=italic ctermbg=bg ctermfg=fg cterm=italic
highlight! Identifier guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! Type guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! PreProc guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! Constant guibg=bg guifg=#101010 gui=bold ctermbg=bg ctermfg=233 cterm=italic
highlight! Comment guibg=bg guifg=#303030 gui=italic ctermbg=bg ctermfg=236 cterm=italic
highlight! Special guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! SpecialKey guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! Directory guibg=bg guifg=fg gui=bold ctermbg=bg ctermfg=fg cterm=bold
highlight! link Title Directory
highlight! link MoreMsg Comment
highlight! link Question Comment

highlight! Todo cterm=underline,bold,italic ctermbg=NONE
" highlight! Search ctermfg=bg ctermbg=fg cterm=underline
highlight! Search ctermbg=NONE cterm=underline
highlight! IncSearch ctermfg=bg ctermbg=fg cterm=underline
" highlight! MatchParen ctermbg=167 cterm=underline,bold
highlight! MatchParen ctermbg=NONE cterm=underline,bold
" highlight! MatchParen ctermbg=14 " <- orig: cyan
highlight! Error ctermbg=167
highlight! ErrorMsg ctermbg=167
highlight! Warning ctermfg=167

" vim
hi link vimFunction Identifier

"let g:colors_name = "acme"
let g:colors_name = "plan9"
