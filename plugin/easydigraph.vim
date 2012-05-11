"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: EasyDigraph
"    File: plugin/easydigraph.vim
" Summary: input special characters easier.
"  Author: Rykka <Rykka10(at)gmail.com>
" Version: 0.4
" Last Update: 2012-05-11
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if !has("digraphs")
    finish
endif

function! s:wstridx(str,needle,...) "{{{
    if exists("a:1")
        let wstart = byteidx(a:str,a:1)
    else
        let wstart = 0
    endif
    let i = 0
    for c in split(a:str,'\zs') 
        if  c == a:needle
            return i
        endif
        let i += 1
    endfor
    return -1
endfunction "}}}
function! s:wstrpart(str, idx,...) "{{{
   " using strchars() and byteidx() to deal with multibyte chars
    let widx = byteidx(a:str,a:idx)
    if widx == -1
        return ""
    endif
    if exists("a:1")
        return strpart(a:str, widx, byteidx(a:str,a:idx+a:1)-widx)
    else
        return strpart(a:str, widx)
    endif
endfunction "}}}

function! s:getchar() "{{{
    let c = getchar()
    if c =~ '^\d\+$'
        let c = nr2char(c)
        echon c
    endif
    return c
endfunction "}}}

function! s:inputtarget() "{{{
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
endfunction "}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:digraph(chars) "{{{
    let s = ""
    " the string to keep undigraphed part
    let cs = a:chars
    while cs != ""
        let s1 = s:wstrpart(cs, 0, 1)
        " [:graph:] is the same with [!-~]
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
endfunction "}}}
function! s:read_motion(mode) "{{{
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
endfunction "}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0  EasyDigraph call <SID>read_motion("n")
command! -nargs=0  EasyDigraphV call <SID>read_motion("v")
command! -nargs=0  EasyDigraphI call <SID>read_motion("i")
"
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

if !exists("g:EasyDigraph_cpunc")
    let g:EasyDigraph_cpunc = 1
endif

if g:EasyDigraph_cpunc == 1
    " for PINYIN: v- ǖ    v' ǘ    v< ǚ    v` ǜ
    dig v- 470 v' 472 v< 474 v` 476
    " NOTE: some are already defined.
    " bracket   : <+《 <'「 <"『 ("【 (I〖
    " quotation : '6 ‘ '9 ’ "6 “ "9 ”
    " ,, ， ,.  。 ,! ！ ,? ？ ,( （ ,) ） ,$ ￥ ,^ …  ,_ — ,\  、 ,; ；
    dig ,, 65292 ,. 12290 ,! 65281 ,? 65311 ,( 65288 ,) 65289 ,$ 65509
    dig ,^ 8230  ,_ 8232  ,\ 12289 ,; 65307
endif
if !exists("g:EasyDigraph_subs")
    let g:EasyDigraph_subs = 1
endif

if g:EasyDigraph_subs == 1
" XOR
dig XO 8853

" superscripts "{{{
" `0  ⁰ `1  ¹ `2  ² `3  ³ `4  ⁴ `5  ⁵ `6  ⁶ `7  ⁷ `8  ⁸ `9  ⁹ 
dig `0 8304 `1 185 `2 178 `3 179 `4 8308 `5 8309 `6 8310 `7 8311 `8 8312 `9 8313
" `+  ⁺ `-  ⁻ `<  ˂ `>  ˃ `/  ˊ `^  ˄
dig `+ 8314 `- 8315 `< 706 `> 707 `/ 714 `^ 708 
"  `(  ⁽ `)  ⁾ `. ˙  `, ʾ `=  ˭ 
dig `( 8317 `) 8318 `. 729 `, 702 `= 749
" `a  ᵃ `b  ᵇ `c  ᶜ `d  ᵈ `e  ᵉ `f  ᶠ `g  ᵍ
dig `a 7491 `b 7495 `c 7580 `d 7496 `e 7497 `f 7584 `g 7501 
" `h  ʰ `i  ⁱ `j  ʲ `k  ᵏ `l  ˡ `m  ᵐ `n  ⁿ 
dig `h 688  `i 8305 `j 690  `k 7503 `l 737  `m 7504 `n 8319
" `o  ᵒ `p  ᵖ `r  ʳ `s  ˢ `t  ᵗ 
dig `o 7506 `p 7510 `r 691  `s 738  `t 7511
" `u  ᵘ `v  ᵛ `w  ʷ `x  ˣ `y  ʸ `z  ᶻ 
dig `u 7512 `v 7515 `w 695  `x 739  `y 696  `z 7611
" `A ᴬ `B  ᴮ `D  ᴰ `E  ᴱ `G  ᴳ 
dig `A 7468 `B 7470 `D 7472 `E 7473 `G 7475
" `H ᴴ `I  ᴵ `J  ᴶ `K  ᴷ `L  ᴸ `M  ᴹ `N  ᴺ
dig `H 7476 `I 7477 `J 7478 `K 7479 `L 7480 `M 7481 `N 7482
" `O ᴼ `P  ᴾ `R  ᴿ `T  ᵀ `U  ᵁ `V ⱽ  `W  ᵂ 
dig `O 7484 `P 7486 `R 7487 `T 7488 `U 7489 `V 11389 `W 7490
"}}}
" subscripts {{{
" _0  ₀_1  ₁ _2  ₂ _3  ₃ _4  ₄ _5  ₅ _6  ₆ _7  ₇ _8  ₈ _9  ₉ 
dig _0 8320 _1 8321_2 8322_3 8323_4 8324 _5 8325 _6 8326 _7 8327 _8 8328 _9 8329
" _+  ₊ _-  ₋ _/  ˏ _(  ₍ _)  ₎ _^  ‸ 
dig _+ 8330 _- 8331 _/ 719 _( 8333 _) 8334_^ 8428
" _a  ₐ _e  ₑ _h ₕ _i  ᵢ _k ₖ _l ₗ _m ₘ _n ₙ
dig _a 8336 _e 8337 _h 8341 _i 7522 _k 8342 _l 8343 _m 8344 _n 8345
" _o  ₒ _p ₚ _r  ᵣ _s ₛ _t ₜ _u  ᵤ _v  ᵥ _x  ₓ 
dig  _o 8338 _p 8346 _r 7523 _s 8347 _t  8348 _u 7524 _v 7525 _x 8339
" }}}

endif

let &cpo = s:save_cpo
unlet s:save_cpo
