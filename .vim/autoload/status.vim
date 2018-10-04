function! s:Colour(active, group, content) abort
    if a:active | return '%' . a:group . '*' . a:content
    else | return a:content | endif
endfunction

function! s:Mode() abort
    let m = mode()
    if m ==# 'n' | return 1
    elseif m ==? 'v' | return 4
    elseif mode() ==? "\<C-v>" | return 4
    elseif m ==? 's' | return 5
    elseif mode() ==? "\<C-s>" | return 5
    elseif m ==# 'i' | return 2
    elseif m ==# 'R' | return 3
    else | return 1 | endif
endfunction

function! status#line(win) abort
    let active = a:win == winnr()

    let stat = ''
    let stat .= s:Colour(active, s:Mode(), '%( %3l %)')
    let stat .= s:Colour(active, 6, '%( %<%f%m %r %)')
    let stat .= '%='
    let stat .= s:Colour(active, 6, '%( %{git#branch()} %)')
    let stat .= s:Colour(active, 7, '%( %2c %)')

    return stat
endfunction

function! status#refresh() abort
    for nr in range(1, winnr('$'))
        call setwinvar(nr, '&statusline', '%!status#line(' . nr . ')')
    endfor
endfunction
