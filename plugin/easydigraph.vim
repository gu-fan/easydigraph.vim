"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: EasyDigraph
"    File: plugin/easydigraph.vim
" Summary: input special characters with digraph easier
"  Author: Rykka <Rykka10(at)gmail.com>
" Last Update: 2012-01-15
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if !has("digraphs")
    finish
endif

function! s:wstrpart(str, idx,...)
   " using strchars() and byteidx() to deal with multibyte chars
    let widx = byteidx(a:str,a:idx)
    if widx == -1
        return ""
    endif
    if exists("a:1")
        let wlen = a:1
        let wend = byteidx(a:str,a:idx+wlen)
        return strpart(a:str, widx, wend-widx)
    else
        return strpart(a:str, widx)
    endif
endfunction

function! s:getchar()
    let c = getchar()
    if c =~ '^\d\+$'
        let c = nr2char(c)
        echon c
    endif
    return c
endfunction

function! s:inputtarget()
    let c = s:getchar()
    while c =~ '^\d\+$'
        let c .= s:getchar()
    endwhile
    if c =~ 'i\|a\|v'
        let c .= s:getchar()
    endif
    if c =~ '\|\|<BS>\|<Home>\|'
        return ""
    else
        return c
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:digraph(chars)
    let s = ""
    " the string to keep undigraphed part
    let cs = a:chars
    while cs != ""
        let s1 = s:wstrpart(cs, 0, 1)
        " [:graph:] is the same with [!-~] but faster.
        if s1 =~ '[[:graph:]]'
            let s2 = s:wstrpart(cs, 1, 1)
            if s2 =~ '[[:graph:]]'
                " using c_<c-k> as no internal digraph output functions
                try
                    silent exec "normal! :let s .= '\<c-k>".s1.s2."'\<cr>"
                catch /^Vim\%((\a\+)\)\=:E/
                    let s .= s1.s2
                endtry
                let cs = s:wstrpart(cs, 2)
            else
                let s .= s1.s2
                let cs = s:wstrpart(cs, 2)
            endif
        else
            let s .= s1
            let cs = s:wstrpart(cs, 1)
        endif
    endwhile
    return s
endfunction

function! s:read_motion(mode)
    if a:mode == "n"
        echohl WarningMsg
        echo "Input motion:"
        echohl Normal
        let m = s:inputtarget()
        if m == ""
            echon "Esacped motion."
            return -1
        endif
        exec "normal! v".m."\"zy"
    elseif a:mode =="v"
        exec "normal! gv\"zy"
    elseif a:mode =="i"
        "back one WORD to get last WORD changed 
        exec "normal! BvaW\"zy"
    endif

    let @z = s:digraph(@z)
    
    let p = &paste
    set paste
    exec "normal! gvc\<c-r>z"
    if p == 0
        set nopaste
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0  EasyDigraph call <SID>read_motion("n")
command! -nargs=0  EasyDigraphV call <SID>read_motion("v")
command! -nargs=0  EasyDigraphI call <SID>read_motion("i")

if !exists("g:EasyDigraph_imap")
    let g:EasyDigraph_imap = "<c-x><c-b>"
endif
if !exists("g:EasyDigraph_nmap")
    let g:EasyDigraph_nmap = "<leader>bb"
endif
if !exists("g:EasyDigraph_vmap")
    let g:EasyDigraph_vmap = "<c-b>"
endif

if !hasmapto("EasyDigraph")
    silent! exec "nmap <silent> ".g:EasyDigraph_nmap." :EasyDigraph<CR>"
endif
if !hasmapto("EasyDigraphI")
    silent! exec "imap <silent> ".g:EasyDigraph_imap." <c-o>:EasyDigraphI<CR>"
endif
if !hasmapto("EasyDigraphV")
    silent! exec "vmap <silent> ".g:EasyDigraph_vmap." :EasyDigraphV<CR>"
endif

let &cpo = s:save_cpo
unlet s:save_cpo
