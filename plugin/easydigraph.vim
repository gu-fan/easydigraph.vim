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
    if c =~ "\<Esc>\|\<C-C>\|\0"
        return ""
    else
        return c
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XXX: if the string length is too long , the returned one will mixed with
"      origin strings
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
                silent exec "normal! :let s .= '\<c-k>".s1.s2."'\<cr>"
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

" FIXED: wrong position with multi words motion
" FIXED: some char reappended
" XXX: sometimes iw may get wrong position
function! s:read_motion(m)
    " FIXED: if it's the only word of the line. still wrong pos.
    " FIXED: if have have ' <eol>' after word,
    "        diW will put cursor at the last space not the previous one.
    "        but it's still the last character of line
    let l = getline('.')
    let w1 = l[col('$') - 1]
    let w2 = l[col('$') - 2]
    " FIXED: even if it's not a whitespace should be change with 'word' motion
    let c1 = l[col('.') - 1 : ]
    if (w1 == " " && w2 != " " )|| (a:m=~'w\|e' && c1 !~ '^\k\+$' )
        let w = 1
    else
        let w = 0
    endif

    " if ' ' under cursor, left move one word for deleting
    if l[col('.')-1] =~ '\s'
        exec 'normal! b'
    endif

    exec "normal! \"zd".a:m
    let @z = s:digraph(@z)

    " FIXED: deleting the word not in the end will change the cursor pos
    if col('.') == col('$')-1 && ( ( a:m =~? '^\d*w$')
        \ || ( a:m =~? 'e' && w == 0 )
        \ || ( a:m =~? 'iw' && w == 0 )
        \ || ( a:m =~? 'aw' ) )
        exec "normal! \"zp"
    else
        exec "normal! \"zP"
    endif
endfunction

" XXX: if multiline and select the eol of last line, will make 
"      the first insert line start with a new line.
function! s:easy_digraph_v()
    exec "normal! gv\"zd"
    let @z = s:digraph(@z)
    if col('.') == col('$')-1
        exec "normal! \"zp"
    else
        exec "normal! \"zP"
    endif
endfunction
function! s:easy_digraph()
    let m = s:inputtarget()
    if m == ""
        return -1
    elseif m !~? '^\d*\(w\|aw\|iw\|vj\|vk\|b\|e\|l\|h\|j\|k\)$'
        let m = 'aW'
    endif
    call s:read_motion(m)
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0  EasyDigraph call <SID>easy_digraph()
command! -nargs=0  EasyDigraphV call <SID>easy_digraph_v()

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
    silent! exec "nmap <unique> <silent> ".g:EasyDigraph_nmap." :EasyDigraph<CR>"
endif
" FIXED: imap only can be used in the end of line
" FIXED: imap if not in the end of line , it should shift right one pace.
silent! exec "imap <unique> <silent> ".g:EasyDigraph_imap." <c-o>:EasyDigraph<CR>aW"

if !hasmapto("EasyDigraphV")
    silent! exec "vmap <unique> <silent> ".g:EasyDigraph_vmap." :EasyDigraphV<CR>"
endif
let &cpo = s:save_cpo
unlet s:save_cpo
