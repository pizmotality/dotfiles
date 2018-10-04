augroup highlight
    autocmd!
    autocmd OptionSet hlsearch call <SID>Toggle(v:option_old, v:option_new)
augroup END

function! s:Start()
    silent! if !search('\%#\zs'.@/,'cnW')
        call <SID>Stop()
    endif
endfunction

function! s:Stop()
    if !v:hlsearch || mode() isnot 'n'
        return
    else
        silent call feedkeys("\<Plug>(Stop)", 'm')
    endif
endfunction

function! s:Toggle(old, new)
    if a:old == 0 && a:new == 1
        noremap <silent> <Plug>(Stop) :<C-u>nohlsearch<CR>
        noremap! <expr> <Plug>(Stop) execute('nohlsearch')[-1]

        autocmd highlight CursorMoved * call <SID>Start()
        autocmd highlight InsertEnter * call <SID>Stop()
    elseif a:old == 1 && a:new == 0
        nunmap <Plug>(Stop)
        unmap! <expr> <Plug>(Stop)

        autocmd! highlight CursorMoved
        autocmd! highlight InsertEnter
    else
        return
    endif
endfunction

call <SID>Toggle(0, &hlsearch)
