## Intro ##

**EasyDigraph**  tries to make inputting special characters easier.

    
Normally, With |:digraphs|, 
i_<Ctrl-K> can be used to input a special character. 
but to press it everycharacter is bothering.
With EasyDigraph, you can use mapping with |motion| to convert
range of special characters.

Default mapping of Normal Mode is '<leader>bb'.
(You can remap it by changing |g:EasyDigraph_nmap|)
Then you can input {motion} to change a specific area.
    
For example:

    aW on 'a*b*c*d*e*' to Greek letter 'αβξδε'
    2w on 'o5hayou5 gozai5masu' to Hiragana 'おはよう ございます'
    i{ in '{(S8S+S3SnS)S}' to SuperScript {⁽⁸⁺³ⁿ⁾}' 
    it in '<p>\n3S >* \n2S </p>' to '<p>n³≫ n² </p>'

EasyDigraph will automatically igonre converted characters.
That is, only convert the characters between ASCII 33~126
so press shortcut on 'αβξδε' will make no change on it.
    
And when Converting, Vim digraph will ignore '\' with char after.
so '\1\+\2' will became '1+2'. 
The only exception is '/'. (Until vim 7.3 )
    
A Insert Mode mapping and Visual Mode mapping are avaliable.
Change at |g:EasyDigraph_vmap|, |g:EasyDigraph_imap|.

with |g:EasyDigraph_subs| and |g:EasyDigraph_cpunc| set to 1.
some more addition digraphs are defined. (default is 1)

    " subscripts and superscripts g:EasyDigraph_subs
    `0 ⁰  `+ ⁺ ... ( 0-9 + - ( ) / ^ . , > < )
    `a ᵃ  `A ᴬ ... ( a-z except q , Some of A-Z)
    _0 ₀  _+ ₊ ... ( 0-9 + - ( ) / ^ )
    _a ₐ  _e ₑ ... (a e h i k l m n o p r s t u v x)

    and XO is defined to ⊕ (XOR)

    " some chinese punctuations. g:EasyDigraph_cpunc
    " ,, ， ,.  。 ,! ！ ,? ？ ,( （ ,) ） ,$ ￥ ,^ …  ,_ — ,\  、 ,; ；
    " NOTE: some are already defined.
    " bracket   :  <+ 《 <' 「 <" 『 (" 【 (I 〖
    " quotation : '6 ‘ '9 ’ "6 “ "9 ”

    Chinese PinYin: v- ǖ   v' ǘ    v< ǚ    v` ǜ

looking at |:digraph| and |digraphs-default| for digraph details.

You can post issues at https://github.com/Rykka/easydigraph.vim/

There is an article that classified the vim digraphs roughly at
http://rykka.is-programmer.com/posts/31752 (Chinese) 


