## Intro ##

**EasyDigraph** makes input special characters with |:digraph| easier.
    
    Normally, You can use i_<Ctrl-K> to input a digraph. but have to press it 
    everytime when input the digraphs.
    With EasyDigraph, you can use |:EasyDigraph| with motion to convert
    characters to digraphs.

    Default mapping is '<leader>bb'
    You can remap it by changing |g:EasyDigraph_nmap|
    Default motion support is 'w\b\e\iw\aw\j\k\vj\vk\h\l'
    
    For example:
    <leader>bbaW on 'a*b*c*d*e*' will convert it to Greek 'αβξδε'
    <leader>bbaw on 'kakikukeko' will convert it to Hiragana 'かきくけこ'
    <leader>bbaW on '(S8S+S3S)S' will convert it to SuperScript '⁽⁸⁺³⁾'
    <leader>bbaW on '(s8s+s3s)s' will convert it to SubScript '₍₈₊₃₎'

    And it will automatically igonre converted characters.
    That is, It will only convert the characters between ASCII 33~126
    so press shortcut on 'αβξδε' will make no change on it.
    
    There is also a mapping in insert mode.
    it's function is change the current WORD.
    Default mapping is '<c-x><c-b>'
    You can remap it by changing |g:EasyDigraph_imap|
    
    A Mapping in Visual Mode.
    Function is change current highlight area.
    Default mapping is '<c-b>'
    You can remap it by changing |g:EasyDigraph_vmap|

    
looking at |:digraph| and |digraphs-default| for digraph details.

You can post issues at https://github.com/Rykka/easydigraph.vim/

Know Issues:

    1. MultiLine action may make the first in a wrong place. 
    2. Multiline action may mix the returned string with origin ones.
