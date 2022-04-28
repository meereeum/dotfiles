" Vim color file
"
" About dark-theme
" https://material.io/design/color/dark-theme.html

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

set t_Co=256
let g:colors_name = "neon-rollerblades"

"    HEX   |256-color| 256-Color |      Type
"          |         |  -> HEX   |
" --------------------------------------------------
"  #ffffff |     015 | #ffffff   | On Background
"  #e1e1e1 |     254 | #e4e4e4   | High-emphasis
"  #b2b2b2 |     249 | #b2b2b2   | Hi-Mid-emphasis
"  #8a8a8a |     245 | #8a8a8a   | Mid-emphasis
"  #6c6c6c |     242 | #6c6c6c   | Disabled
"  #383838 |     237 | #3a3a3a   | Overlay
"  #313131 |     236 | #303030   | Overlay
"  #2a2a2a |     235 | #262626   | Overlay
"  #1a1a1a |     234 | #1c1c1c   | Surface
"  #0c0c0c |     232 | #080808   | Background
"  #000000 |     000 | #000000   | Background
"  #bb86fc |     141 | #af87ff   | Primary
"  #b26eff |     135 | #af5fff   | Primary Valiant
"  #00d7ff |     045 | #00d7ff   | Secondary
"  #cf6679 |     168 | #d75f87   | Error
"  #ff4081 |     204 | #ff5f87   | (Special & Diff Delete)
"  #7CB342 |     107 | #87af5f   | (Diff Add)
"  #ffdf00 |     220 | #FDD835   | (Diff Change)

" 147 is light purpleish violet
" 173 is chill orangey
" 192 is neon yellow
" cyan is cyan (specialkey)

" ============
"  Primary
" ============
" hi Type ctermfg=192 ctermbg=NONE cterm=NONE
hi Keyword ctermfg=192 ctermbg=NONE cterm=NONE
hi String ctermfg=192 ctermbg=NONE cterm=NONE
hi Character ctermfg=192 ctermbg=NONE cterm=NONE
hi Define ctermfg=192 ctermbg=NONE cterm=NONE
hi StorageClass ctermfg=192 ctermbg=NONE cterm=NONE
hi Directory ctermfg=192 ctermbg=NONE cterm=NONE

" ============
"  Primary Valiant
" ============
hi Tag ctermfg=135 ctermbg=NONE cterm=NONE

" ============
"  Secondary
" ============
hi Type ctermfg=147 ctermbg=NONE cterm=underline
hi PreProc ctermfg=147 ctermbg=NONE cterm=NONE
hi Label ctermfg=147 ctermbg=NONE cterm=NONE
hi Conditional ctermfg=147 ctermbg=NONE cterm=NONE
hi Statement ctermfg=147 ctermbg=NONE cterm=NONE
hi Operator ctermfg=147 ctermbg=NONE cterm=NONE
hi Question ctermfg=147 ctermbg=NONE cterm=NONE

" ============
"  Special
" ============
hi Special ctermfg=210 ctermbg=NONE cterm=NONE
hi SpecialChar ctermfg=210 ctermbg=NONE cterm=NONE
hi MatchParen term=bold cterm=bold ctermbg=210
" hi MatchParen ctermfg=210 ctermbg=NONE cterm=underline
hi Todo ctermfg=210 ctermbg=NONE cterm=NONE
hi Search ctermfg=white  ctermbg=210
hi IncSearch ctermfg=white ctermbg=210 cterm=NONE
" hi Search ctermfg=210 ctermbg=NONE cterm=NONE
" hi IncSearch ctermfg=210 ctermbg=237 cterm=NONE

" ============
"  Error
" ============
hi Error ctermfg=0 ctermbg=167 cterm=NONE
hi ErrorMsg ctermfg=0 ctermbg=167 cterm=NONE
hi WarningMsg ctermfg=0 ctermbg=167 cterm=NONE

" =================
" High-emphasis
" =================
hi Boolean ctermfg=254 ctermbg=NONE cterm=NONE
hi Float ctermfg=254 ctermbg=NONE cterm=NONE
hi Number ctermfg=254 ctermbg=NONE cterm=NONE
hi Constant ctermfg=254 ctermbg=NONE cterm=bold
hi Structure ctermfg=254 ctermbg=NONE cterm=NONE

" =================
" Medium-emphasis
" =================
hi Identifier ctermfg=249 ctermbg=NONE cterm=NONE
hi Function ctermfg=249 ctermbg=NONE cterm=bold,italic
" cterm=NONE
hi Delimiter ctermfg=249 ctermbg=NONE cterm=NONE

" =================
"  Background
" =================
hi Normal ctermfg=254 ctermbg=234 cterm=NONE
hi NonText ctermfg=235 ctermbg=234 cterm=NONE

" ============
"  Diff
" ============
hi DiffAdd ctermfg=107 ctermbg=235 cterm=NONE
hi DiffText ctermfg=220 ctermbg=237 cterm=NONE
hi DiffChange ctermfg=NONE ctermbg=237 cterm=NONE
hi DiffDelete ctermfg=196 ctermbg=235 cterm=NONE

" =================
"  Line
" =================
hi LineNr ctermfg=254 ctermbg=236 cterm=NONE
hi ColorLineNr ctermfg=254 ctermbg=236 cterm=NONE
hi StatusLine ctermfg=245 ctermbg=235 cterm=bold
hi StatusLineNC ctermfg=245 ctermbg=235 cterm=NONE
hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE
hi CursorLineNr ctermfg=254 ctermbg=237 cterm=NONE
hi CursorColumn ctermfg=254 ctermbg=237 cterm=NONE

" =================
"  Select
" =================
" hi Visual ctermfg=NONE ctermbg=242 cterm=NONE
hi Visual ctermfg=NONE ctermbg=174 cterm=NONE
" hi Visual ctermfg=NONE ctermbg=189 cterm=NONE
" hi Visual ctermfg=NONE ctermbg=139 cterm=NONE
" hi Visual ctermfg=NONE ctermbg=146 cterm=NONE
" hi Visual ctermfg=NONE ctermbg=239 cterm=NONE
hi SignColumn ctermfg=15 ctermbg=237 cterm=NONE
hi SpecialKey ctermfg=cyan
" hi SpecialKey ctermfg=15 ctermbg=237 cterm=NONE
hi Cursor ctermfg=15 ctermbg=249 cterm=NONE

" ============
"  Underline
" ============
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=NONE ctermbg=NONE
hi clear SpellCap " & ALE
hi SpellBad cterm=underline ctermfg=NONE ctermbg=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline

" =================
"  Disabled
" =================
hi Comment ctermfg=243 ctermbg=NONE cterm=NONE
hi SpecialComment ctermfg=240 ctermbg=235 cterm=NONE

" =================
"  Folded and Column
" =================
hi Folded ctermfg=240 ctermbg=235 cterm=NONE
hi FoldColumn ctermfg=141 ctermbg=236 cterm=NONE
hi ColorColumn ctermfg=NONE ctermbg=232 cterm=NONE
hi VertSplit ctermfg=0 ctermbg=232 cterm=NONE

" =================
"  Tab
" =================
hi Title ctermfg=15 ctermbg=NONE cterm=bold
hi TabLine ctermfg=245 ctermbg=236 cterm=NONE
hi TabLineFill ctermfg=15 ctermbg=235 cterm=NONE
hi TabLineSel ctermfg=0 ctermbg=135 cterm=NONE

" =================
"  Menu
" =================
hi Pmenu ctermfg=254 ctermbg=235 cterm=NONE
hi PmenuSel ctermfg=135 ctermbg=236 cterm=NONE

" =================
"  Link
" =================
hi link gitcommitSummary String

" =================
"  Language part
" =================
"
" # Markdown
hi markdownHeadingDelimiter ctermfg=204 ctermbg=NONE cterm=NONE

