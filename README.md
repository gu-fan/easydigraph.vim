## Intro ##

**EasyDigraph** makes inputting special characters easier (+digraphs).
    
    With |:digraphs|, You can use i_<Ctrl-K> to input a special character. 
    but have to press it everytime.
    With EasyDigraph, you can use mapping with {motion} to convert
    to special characters.

    Default mapping in Normal Mode is '<leader>bb'.
    You can remap it by changing |g:EasyDigraph_nmap|
    
    For example:
    <leader>bbaW on 'a*b*c*d*e*' to Greek 'αβξδε'
    <leader>bb2w on 'o5hayou5 gozai5masu' to Hiragana 'おはよう ございます'
    <leader>bbi{ in '{(S8S+S3SnS)S}' to SuperScript {⁽⁸⁺³ⁿ⁾}' 
    <leader>bbit in '<p>\n3S >* \n2S </p>' to '<p>n³≫ n² </p>'

    EasyDigraph will automatically igonre converted characters.
    That is, only convert the characters between ASCII 33~126
    so press shortcut on 'αβξδε' will make no change on it.
    
    And when Converting, Vim digraph will ignore '\' with char after.
    so '\1\+\2' will became '1+2'. 
    The only exception is '/'. (Until vim 7.3 )
    
    A Insert Mode mapping to change the current WORD.
    Default mapping is '<c-x><c-b>'
    You can remap it by changing |g:EasyDigraph_imap|
    
    A Visual Mode mapping to change current highlight area.
    Default mapping is '<c-b>'
    You can remap it by changing |g:EasyDigraph_vmap|
    
    looking at |:digraph| and |digraphs-default| for digraph details.

You can post issues at https://github.com/Rykka/easydigraph.vim/

