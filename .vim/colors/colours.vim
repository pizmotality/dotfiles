" vi:syntax=vim

" GUI color definitions
let s:gui00 = "2d2d2d"
let s:gui01 = "393939"
let s:gui02 = "515151"
let s:gui03 = "747369"
let s:gui04 = "a09f93"
let s:gui05 = "d3d0c8"
let s:gui06 = "e8e6df"
let s:gui07 = "f2f0ec"
let s:gui08 = "f2777a"
let s:gui09 = "f99157"
let s:gui0A = "ffcc66"
let s:gui0B = "99cc99"
let s:gui0C = "90b4d8"
let s:gui0D = "6699cc"
let s:gui0E = "9999cc"
let s:gui0F = "cdea40"

" Terminal color definitions
let s:cterm00 = "07"
let s:cterm01 = "15"
let s:cterm02 = "14"
let s:cterm03 = "13"
let s:cterm04 = "12"
let s:cterm05 = "09"
let s:cterm06 = "08"
let s:cterm07 = "00"
let s:cterm08 = "01"
let s:cterm09 = "11"
let s:cterm0A = "03"
let s:cterm0B = "02"
let s:cterm0C = "06"
let s:cterm0D = "04"
let s:cterm0E = "05"
let s:cterm0F = "10"

" Theme setup
hi clear
syntax reset
let g:colors_name = "colours"

" Highlighting function
fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
  if a:guisp != ""
    exec "hi " . a:group . " guisp=#" . a:guisp
  endif
endfun

" Vim editor colors
call <sid>hi("Search",        s:gui03, s:gui0A, s:cterm03, s:cterm0A,  "", "")
call <sid>hi("Visual",        "", s:gui05, "", s:cterm05, "", "")

" Remove functions
delf <sid>hi

" Remove color variables
unlet s:gui00 s:gui01 s:gui02 s:gui03  s:gui04  s:gui05  s:gui06  s:gui07  s:gui08  s:gui09 s:gui0A  s:gui0B  s:gui0C  s:gui0D  s:gui0E  s:gui0F
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
