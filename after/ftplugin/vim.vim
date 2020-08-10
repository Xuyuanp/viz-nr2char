if exists('b:loaded_viz_nr2char')
    finish
endif
let b:loaded_viz_nr2char = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:VizNr2char() range abort
    setlocal conceallevel=1
    setlocal concealcursor=n
    for l:ln in range(a:firstline, a:lastline)
        let code = matchstr(getline(l:ln), '\mnr2char(\s*\zs\S\+\ze\s*)')
        if strlen(code)
            execute 'silent! syntax match VizNr2char /\mnr2char(\s*' . code . '\s*)/hs=s+8,he=e-1 containedin=ALL conceal cchar=' . nr2char(code)
        endif
    endfor
endfunction

function! s:VizNr2charAll() abort
    let currln = line('.')
    let currcol = col('.')
    1,$call s:VizNr2char()
    call cursor(currln, currcol)
endfunction

" define commands
command! -nargs=0 -range -bang -buffer VizNr2char :<line1>,<line2>call <SID>VizNr2char()
command! -nargs=0 -bang -buffer VizNr2charAll :call <SID>VizNr2charAll()
command! -nargs=0 -bang -buffer VizNr2charClear :silent! syntax clear VizNr2char

" define keymappings
nnoremap <buffer><unique><silent> <Plug>(VizNr2charNormal) :<C-u>VizNr2char<CR>
xnoremap <buffer><unique><silent> <Plug>(VizNr2charVisual) :<C-u>'<,'>VizNr2char<CR>
noremap  <buffer><unique><silent> <Plug>(VizNr2charClear)  :<C-u>VizNr2charClear<CR>
nnoremap <buffer><unique><silent> <Plug>(VizNr2charAll)    :<C-u>VizNr2charAll<CR>

for [name, keys, kmode] in [
            \ ['Normal', 'vn', 'n'],
            \ ['Visual', 'vn', 'x'],
            \ ['Clear',  'vc', ''],
            \ ['All',    'va', 'n'],
            \]
    let fullname = '<Plug>(VizNr2char' . name . ')'
    if !hasmapto(fullname) && empty(maparg('<leader>' . keys, kmode))
        call execute('' . kmode . 'map <buffer> <unique> <leader>' . keys . ' ' . fullname)
    endif
endfor

let &cpoptions = s:save_cpo
unlet s:save_cpo
