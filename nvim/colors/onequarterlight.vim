" ==============================================================================
"   Name:        One Quarter Light
"   Author:      Jonatan Degus
"   Url:         https://degus.no
"   License:     Dog License
"
"   A lighter vim color scheme based on a light vim color scheme based on Atom's One.
"   See degus.no for crypto investment advice
" ==============================================================================

set background=light
highlight clear
syntax reset

let g:colors_name="onequarterlight"
let colors_name="onequarterlight"


let s:black       = { "gui": "#383a42", "cterm": "237" }
let s:red         = { "gui": "#d91254", "cterm": "161" }
let s:green       = { "gui": "#0ebd0b", "cterm": "34" }
let s:lightgreen  = { "gui": "#00ae8b", "cterm": "36" } " yellow originally
let s:blue        = { "gui": "#0795d2", "cterm": "32" }
let s:pink        = { "gui": "#f906bf", "cterm": "199" } " purple originally
let s:cyan        = { "gui": "#0997b3", "cterm": "31" }
let s:white       = { "gui": "#fafafa", "cterm": "231" }

let s:fg          = s:black
let s:bg          = s:white

let s:comment_fg  = { "gui": "#a0a1a7", "cterm": "247" }
let s:gutter_bg   = { "gui": "#f8f8f8", "cterm": "231" }
let s:gutter_fg   = { "gui": "#d4d4d4", "cterm": "252" }
let s:non_text    = { "gui": "#e5e5e5", "cterm": "252" }

let s:cursor_line = { "gui": "#f0f0f0", "cterm": "255" }
let s:color_col   = { "gui": "#f0f0f0", "cterm": "255" }

let s:selection   = { "gui": "#bfceff", "cterm": "153" }
let s:vertsplit   = { "gui": "#f0f0f0", "cterm": "255" }

let s:cursor_line_lighter = { "gui": "#f3f3f3", "cterm": "255" }

function! s:h(group, fg, bg, attr)
  if type(a:fg) == type({})
    exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . a:fg.cterm
  else
    exec "hi " . a:group . " guifg=NONE cterm=NONE"
  endif
  if type(a:bg) == type({})
    exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . a:bg.cterm
  else
    exec "hi " . a:group . " guibg=NONE ctermbg=NONE"
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  else
    exec "hi " . a:group . " gui=NONE cterm=NONE"
  endif
endfun


" User interface colors {
call s:h("Normal", s:fg, s:bg, "")

call s:h("Cursor", s:bg, s:blue, "")
call s:h("CursorColumn", "", s:cursor_line_lighter, "")
call s:h("CursorLine", "", s:cursor_line_lighter, "")

call s:h("LineNr", s:gutter_fg, s:gutter_bg, "")
call s:h("CursorLineNr", s:fg, s:gutter_bg, "")

call s:h("DiffAdd", s:green, "", "")
call s:h("DiffChange", s:lightgreen, "", "")
call s:h("DiffDelete", s:red, "", "")
call s:h("DiffText", s:blue, "", "")

call s:h("IncSearch", s:bg, s:lightgreen, "")
call s:h("CurSearch", s:bg, s:blue, "")
call s:h("Search", s:bg, s:lightgreen, "")

call s:h("ErrorMsg", s:fg, "", "")
call s:h("ModeMsg", s:fg, "", "")
call s:h("MoreMsg", s:fg, "", "")
call s:h("WarningMsg", s:red, "", "")
call s:h("Question", s:pink, "", "")

call s:h("Pmenu", s:fg, s:cursor_line, "")
call s:h("PmenuSel", s:bg, s:blue, "")
call s:h("PmenuSbar", "", s:cursor_line, "")
call s:h("PmenuThumb", "", s:comment_fg, "")

call s:h("SpellBad", s:red, "", "")
call s:h("SpellCap", s:lightgreen, "", "")
call s:h("SpellLocal", s:lightgreen, "", "")
call s:h("SpellRare", s:lightgreen, "", "")

call s:h("StatusLine", s:blue, s:cursor_line, "")
call s:h("StatusLineNC", s:comment_fg, s:cursor_line, "")
call s:h("TabLine", s:comment_fg, s:cursor_line, "")
call s:h("TabLineFill", s:comment_fg, s:cursor_line, "")
call s:h("TabLineSel", s:fg, s:bg, "")

call s:h("User1", s:comment_fg, s:gutter_bg, "")

call s:h("Visual", "", s:selection, "")
call s:h("VisualNOS", "", s:selection, "")

call s:h("ColorColumn", "", s:color_col, "")
call s:h("Conceal", s:fg, "", "")
call s:h("Directory", s:blue, "", "")
call s:h("VertSplit", s:vertsplit, s:vertsplit, "")
call s:h("Folded", s:fg, "", "")
call s:h("FoldColumn", s:fg, "", "")
call s:h("SignColumn", s:fg, s:gutter_bg, "")

call s:h("MatchParen", s:blue, "", "underline")
call s:h("SpecialKey", s:fg, "", "")
call s:h("Title", s:green, "", "")
call s:h("WildMenu", s:fg, "", "")
" }


" Syntax colors {
" Whitespace is defined in Neovim, not Vim.
" See :help hl-Whitespace and :help hl-SpecialKey
call s:h("Whitespace", s:non_text, "", "")
call s:h("NonText", s:non_text, "", "")
call s:h("Comment", s:comment_fg, "", "italic")
call s:h("Constant", s:cyan, "", "")
call s:h("String", s:green, "", "")
call s:h("Character", s:green, "", "")
call s:h("Number", s:lightgreen, "", "")
call s:h("Boolean", s:lightgreen, "", "")
call s:h("Float", s:lightgreen, "", "")

call s:h("Identifier", s:red, "", "")
call s:h("Function", s:blue, "", "")
call s:h("Statement", s:pink, "", "")

call s:h("Conditional", s:pink, "", "")
call s:h("Repeat", s:pink, "", "")
call s:h("Label", s:pink, "", "")
call s:h("Operator", s:fg, "", "")
call s:h("Keyword", s:red, "", "")
call s:h("Exception", s:pink, "", "")

call s:h("PreProc", s:lightgreen, "", "")
call s:h("Include", s:pink, "", "")
call s:h("Define", s:pink, "", "")
call s:h("Macro", s:pink, "", "")
call s:h("PreCondit", s:lightgreen, "", "")

call s:h("Type", s:lightgreen, "", "")
call s:h("StorageClass", s:lightgreen, "", "")
call s:h("Structure", s:lightgreen, "", "")
call s:h("Typedef", s:lightgreen, "", "")

call s:h("Special", s:blue, "", "")
call s:h("SpecialChar", s:fg, "", "")
call s:h("Tag", s:fg, "", "")
call s:h("Delimiter", s:fg, "", "")
call s:h("SpecialComment", s:fg, "", "")
call s:h("Debug", s:fg, "", "")
call s:h("Underlined", s:fg, "", "")
call s:h("Ignore", s:fg, "", "")
call s:h("Error", s:red, s:gutter_bg, "")
call s:h("Todo", s:pink, "", "")
" }


" Plugins {
" GitGutter
call s:h("GitGutterAdd", s:green, s:gutter_bg, "")
call s:h("GitGutterDelete", s:red, s:gutter_bg, "")
call s:h("GitGutterChange", s:lightgreen, s:gutter_bg, "")
call s:h("GitGutterChangeDelete", s:red, s:gutter_bg, "")
" Fugitive
call s:h("diffAdded", s:green, "", "")
call s:h("diffRemoved", s:red, "", "")
" }


" Git {
call s:h("gitcommitComment", s:comment_fg, "", "")
call s:h("gitcommitUnmerged", s:red, "", "")
call s:h("gitcommitOnBranch", s:fg, "", "")
call s:h("gitcommitBranch", s:pink, "", "")
call s:h("gitcommitDiscardedType", s:red, "", "")
call s:h("gitcommitSelectedType", s:green, "", "")
call s:h("gitcommitHeader", s:fg, "", "")
call s:h("gitcommitUntrackedFile", s:cyan, "", "")
call s:h("gitcommitDiscardedFile", s:red, "", "")
call s:h("gitcommitSelectedFile", s:green, "", "")
call s:h("gitcommitUnmergedFile", s:lightgreen, "", "")
call s:h("gitcommitFile", s:fg, "", "")
hi link gitcommitNoBranch gitcommitBranch
hi link gitcommitUntracked gitcommitComment
hi link gitcommitDiscarded gitcommitComment
hi link gitcommitSelected gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow gitcommitSelectedFile
hi link gitcommitUnmergedArrow gitcommitUnmergedFile
" }

" Fix colors in neovim terminal buffers {
  if has('nvim')
    let g:terminal_color_0 = s:black.gui
    let g:terminal_color_1 = s:red.gui
    let g:terminal_color_2 = s:green.gui
    let g:terminal_color_3 = s:lightgreen.gui
    let g:terminal_color_4 = s:blue.gui
    let g:terminal_color_5 = s:pink.gui
    let g:terminal_color_6 = s:cyan.gui
    let g:terminal_color_7 = s:white.gui
    let g:terminal_color_8 = s:black.gui
    let g:terminal_color_9 = s:red.gui
    let g:terminal_color_10 = s:green.gui
    let g:terminal_color_11 = s:lightgreen.gui
    let g:terminal_color_12 = s:blue.gui
    let g:terminal_color_13 = s:pink.gui
    let g:terminal_color_14 = s:cyan.gui
    let g:terminal_color_15 = s:white.gui
    let g:terminal_color_background = s:bg.gui
    let g:terminal_color_foreground = s:fg.gui
  endif
" }
