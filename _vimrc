" vim: fileformat=unix
scriptencoding utf-8

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"-------------------------------------------------------------------------------
function! MySys()
  if has("win16") || has("win32")   || has("win64")    || has("win95")

python << endpython
import sys
import vim

def isVista():
    if getattr(sys, "getwindowsversion", None) is not None:
        (major, minor, build, platform, service_pack) = sys.getwindowsversion()
        if major==6 and platform!=2:
            vim.command("return 'windows7'")
        else:
            vim.command("return 'windows'")
    else:
        vim.command("return 'windows'")
endpython

    python isVista()

"   return "windows"

  elseif has("unix") || has("win32unix")
    return "unix"
  else
    return "mac"
  endif
endfunction

"if MySys()=="windows7"
"    echo 1
"    let root=$HOME
"else
"    echo 2
"    let root=$VIM
"endif
"echo root

let s:MSWIN = has("win16") || has("win32")   || has("win64")    || has("win95")
let s:UNIX  = has("unix")  || has("macunix") || has("win32unix")

"-------------------------------------------------------------------------------
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '"' . $VIMRUNTIME . '\diff"'
      let eq = '""'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

"-------------------------------------------------------------------------------
"set backup            " keep a backup file

function InitBackupDir()
  let separator = "."
  let parent = $HOME .'/' . separator . 'vim/'
  let backup = parent . 'backup/'
  let tmp    = parent . 'tmp/'
  if exists("*mkdir")
    if !isdirectory(parent)
      call mkdir(parent)
    endif
    if !isdirectory(backup)
      call mkdir(backup)
    endif
    if !isdirectory(tmp)
    call mkdir(tmp)
  endif
endif

let missing_dir = 0
if isdirectory(tmp)
  execute 'set backupdir=' . escape(backup, " ") . "/,."
else
  let missing_dir = 1
endif

if isdirectory(backup)
  execute 'set directory=' . escape(tmp, " ") . "/,."
else
  let missing_dir = 1
endif

if missing_dir
  echo "Warning: Unable to create backup directories: ". backup ." and " . tmp
  echo "Try: mkdir -p " . backup
  echo "and: mkdir -p " . tmp
  set backupdir=.
  set directory=.
endif
endfunction

"call InitBackupDir()

"-------------------------------------------------------------------------------
" ~/.viminfo
" Set backup on and directory for backups:
if s:MSWIN
  " ==========  MS Windows  ======================================================
  if MySys()=="windows7"
    " silent execute '!del "'.$VIM.'/vimfiles/temp/*~"'
    set backupdir=$HOME/vimfiles/temp/
    set directory=$HOME/vimfiles/temp/
    "set backupdir=$HOME.'\vimfiles\temp'
    "set directory=$HOME.'\vimfiles\temp'
    set viewdir=$HOME/vimfiles/view/
    set viminfo='100,<50,s10,h,rA:,rB:,n$HOME/vimfiles/_viminfo
  else
    " silent execute '!del "'.$VIM.'/vimfiles/temp/*~"'
    set backupdir=$VIM/vimfiles/temp/
    set directory=$VIM/vimfiles/temp/
    "set backupdir=$VIM.'\vimfiles\temp'
    "set directory=$VIM.'\vimfiles\temp'
    set viewdir=$VIM\vimfiles\view\
    set viminfo='100,<50,s10,h,rA:,rB:,n$VIM/vimfiles/_viminfo
  endif
else
  " ==========  Linux/Unix  ======================================================
  " silent execute '!del "'.$HOME.'/vim/temp/*~"'
  set backupdir=$HOME/.vim/temp
  set directory=$HOME/.vim/temp
  set viewdir=$HOME/.vim/view/
"  set viminfo='100,<50,s10,h,n$HOME/_viminfo
  set viminfo='100,<50,s10,h,n$HOME/.vim/_viminfo
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set scrolloff=2    " Set 7 lines to the curors - when moving vertical..

set number         " Show line numbers
set numberwidth=5  " No of columns for line numbers

set wildmenu       " Turn on WiLd menu

set cmdheight=2    " The commandbar height

set ignorecase     " Ignore case when searching
set smartcase      " overrides ignorecase if uppercase used in search term

set hlsearch       " Highlight search things

set incsearch      " Make search act like search in modern browsers
set nolazyredraw   " Don't redraw while executing macros

set cpoptions=B$   " Show existing content when changing text, and show a '$'
                   " at the end of the content that is to be changed.

set hidden         " Allow switching buffers without saving current buffer

set showmatch      " Show matching bracets when text indicator is over them
set matchtime=2    " How many tenths of a second to blink

set laststatus=2   " Always show the statusline

"set backspace=indent,eol,start " make the backspace key work for indents, work past
"                               " the end of a line, and paste the start of an
"                               " insertion
"set whichwrap+=<,>,h,l         " make left and right movements wrap across lines

" make matching parens readable !
"hi MatchParen ctermfg=5

set cursorline     " Highligh line containing cursor
highlight CursorLine term=underline cterm=underline guibg=Grey40
"highlight CursorLine               ctermbg=lightgray guibg=lightblue

set go+=b          " Add a horizontal scroll bar at the bottom

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show trailing whitespace
"set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
"set listchars=eol:$,tab:→\ ,trail:.,extends:>,precedes:<,nbsp:_
set list listchars=tab:».,trail:·,extends:>,precedes:<,nbsp:_

"set expandtab
"set shiftwidth=2
"set tabstop=2
"set smarttab

"set expandtab shiftwidth=2 tabstop=2 softtabstop=2 autoindent  " Set the tabs to spaces

set columns=140    " Set terminal to 140 columns
set nowrap         " Turn off line-wrapping

autocmd BufEnter * silent! lcd %:p:h   " Change to the directory of the currently open file

"autocmd BufNewFile,BufRead *.xtcl                   setfiletype xtcl

"autocmd FileType *                     setlocal tabstop=8|setlocal shiftwidth=8|setlocal noexpandtab
"autocmd FileType c                     setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent
"autocmd FileType cpp                   setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent
"autocmd FileType java                  setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent
"autocmd FileType python                setlocal tabstop=4|setlocal shiftwidth=4|setlocal expandtab|setlocal softtabstop=4|setlocal autoindent
"autocmd FileType tcl                   setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent
"autocmd FileType verilog_systemverilog setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent
"autocmd FileType vhdl                  setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab|setlocal softtabstop=2|setlocal autoindent

"autocmd BufNewFile,BufRead *.xdc set syntax=xdc

" STG (String Template)
"autocmd BufNewFile,BufRead *.stg set filetype=stringtemplate
"autocmd BufNewFile,BufRead *.g   set syntax=antlr3
"autocmd BufNewFile,BufRead *.g3  set syntax=antlr3
"autocmd BufNewFile,BufRead *.g4  set syntax=antlr3

"autocmd FileType c, cpp setlocal foldenable | setlocal foldmethod=syntax
"autocmd FileType python setlocal foldenable | setlocal foldlevel=1

set foldlevelstart=0
set foldopen=block,hor,jump,mark,percent,quickfix,search,tag,undo

" Folding options
"set foldmethod=marker
set foldcolumn=4
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview
autocmd BufWinLeave * if expand("%") != "" | mkview   | endif
autocmd BufWinEnter * if expand("%") != "" | loadview | endif
"set foldtext=MyFoldText()
"
"if !exists("*MyFoldText")
"   function MyFoldText()
"      let line = getline(v:foldstart)
"      let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
"      return "FOLD (" . (v:foldend - v:foldstart) . ")" . sub
"   endfunction
"" /* }}} - End folding on this function declaration */
"endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map control + movement keys to 'switch to split'
"map <C-H> <C-W>h
"map <C-J> <C-W>j
"map <C-K> <C-W>k
"map <C-L> <C-W>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
nmap <Space>   /
nmap <C-Space> ?
nmap <silent>  <leader><cr> :noh<cr>

" Incremental search
map <C-k> mx
map <C-l> lmy"zy`x/<C-r>z<CR>`y

" Search for word under cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/
"vmap ª "zw:exec "/".@z.""<CR>
"vmap <Leader>s "zyw:exec "/".@z.""<CR>
map <Leader>h "zyw:exe "h ".@z.""<CR>

" This actually doesn't work for v5.8, but only for later versions...
" Set virtualedit to allow you to column select where there are no real characters.
set virtualedit +=block

" Make shift-insert work like in Xterm
"map  <S-Insert> <MiddleMouse>
"map! <S-Insert> <MiddleMouse>

"set mousemodel=extend   " Search forw/back with shift and left/right-click

" Block Indent
" (indent/unindent block in visual/select mode with TAB: keeps last selection!)
"vmap > >gv
"vmap < <gv
vmap <TAB>   :><cr>gv
vmap <S-TAB> :<<cr>gv

" Scroll up/down with ALT+Arrow
nnoremap <M-C-Up>   <C-Y>
nnoremap <M-C-Down> <C-E>

" Delete to end of line
"map  <C-K>    D
"imap <C-K>    <ESC>:d$<CR>
noremap  <C-Del> D
inoremap <C-Del> <C-\><C-O>D

" Yank (copy) to the end of the line
nnoremap Y y$

" Mappings to move lines
nnoremap <A-Down> :m+<CR>==
nnoremap <A-Up>   :m-2<CR>==
inoremap <A-Down> <Esc>:m+<CR>==gi
inoremap <A-Up>   <Esc>:m-2<CR>==gi
vnoremap <A-Down> :m'>+<CR>gv=gv
vnoremap <A-Up>   :m-2<CR>gv=gv

"---------------------------------------------------------------------------------------------------
" Quote a word, using single quotes
" ciw'Ctrl+r"'
" Unquote a word that's enclosed in single quotes
" di'hPl2x
" Change single quotes to double quotes
" va':s/\%V'\%V/"/g
"---------------------------------------------------------------------------------------------------
" Quote a word consisting of letters from iskeyword.
nnoremap <silent> wd :call Quote('"')<CR>
nnoremap <silent> ws :call Quote("'")<CR>
nnoremap <silent> wq :call UnQuote()<CR>
function! Quote(quote)
  normal mz
  exe 's/\(\k*\%#\k*\)/' . a:quote . '\1' . a:quote . '/'
  normal `zl
endfunction

function! UnQuote()
  normal mz
  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
  normal `z
endfunction

"---------------------------------------------------------------------------------------------------
" Uniq - Removing duplicate lines
" http://vim.wikia.com/wiki/Uniq_-_Removing_duplicate_lines
nnoremap \d1 :g/^/kl\|if search('^'.escape(getline('.'),'\.*[]^$/').'$','bW')\|'ld<CR>
nnoremap \d2 :g/^/m0<CR>:g/^\(.*\)\n\_.*\%(^\1$\)/d<CR>:g/^/m0<CR>
nnoremap \d3 :%s/^\(.*\)\(\n\1\)\+$/\1/<CR>
" g/^\(.*\)$\n\1$/d
" g/\%(^\1$\n\)\@<=\(.*\)$/d
"---------------------------------------------------------------------------------------------------

"func! HomeWok()
"  " get current column...
"  let oldcol = col(".")
"  " go to first non-white
"  normal ^
"  " in what column are we now?
"  let newcol = col(".")
"  " not moved (so we already where at first-non-white)?
"  if (oldcol == newcol)
"    normal $
"    let lastcol = col(".")
"    if (newcol == lastcol)
"      " workaround: append one space, when line has only 1 char
"      normal a 0
"    else
"      " go to column '1'
"      normal 0
"    endif
"  " we did move - but forward...
"  elseif ((oldcol != 1) && (newcol > oldcol))
"    " go to column '1'
"    normal 0
"  endif
"endfunc
"if !exists(':HomeWok')
"  command! HomeWok call HomeWok()
"endif
"map  <Home> :call HomeWok()<CR>
"map! <Home> <C-o>:call HomeWok()<CR>

"map  <Home> :SmartHomeKey<CR>
"imap <Home> <C-O>:SmartHomeKey<CR>

"noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0'  : '^')
"noremap  <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$'  : 'g_')
"vnoremap <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$h' : 'g_')
"imap     <Home> <C-o><Home>
"imap     <End>  <C-o><End>

" CTRL-SPACE: keyword completion, like in Visual C++
" * <CTRL><SPACE>        Keyword/Functionname completion (forward)
map  <C-space>   <C-n>
map! <C-space>   <C-n>
" * <CTRL><SHIFT><SPACE> Keyword/Functionname completion (backward)
map  <C-S-space> <C-p>
map! <C-S-space> <C-p>

" Enable 'in-column' up and down motion in INSERT mode on wrapped lines
"imap <silent> <Up>   <C-o>gk
"imap <silent> <Down> <C-o>gj

" Enable 'in-column' up and down motion on wrapped lines
"map <silent> <Up>   gk
"map <silent> <Down> gj

" Map shift up and down to page scrolling
"map <S-Up>   <C-E>
"map <S-Down> <C-Y>

" Move between buffers/tabs
"if !has("gui_running")
  nmap  <C-F6>   :bnext<CR>
  nmap  <C-S-F6> :bprevious<CR>
  map   <C-F6>   :bnext<CR>
  map   <C-S-F6> :bprevious<CR>
  imap  <C-F6>   <ESC>:bnext<CR>
  imap  <C-S-F6> <ESC>:bprevious<CR>
"endif
nmap  <C-F4>   :bd<CR>
nmap  <C-w>    :bd<CR>
"nmap <C-F4>  :Bclose<CR>
map   <C-F4>   :bd<CR>
map   <C-w>    :bd<CR>
"map  <C-F4>   :Bclose<CR>
imap  <C-F4>   <ESC>:bd<CR>
imap  <C-w>    :bd<CR>
"imap <C-F4>   :Bclose<CR>

nmap  <C-S-q>    :qa<CR>
map   <C-S-q>    :qa<CR>
imap  <C-S-q>    :qa<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vnoremap $1 <esc>`>a)<esc>`<i(<esc>
"vnoremap $2 <esc>`>a]<esc>`<i[<esc>
"vnoremap $3 <esc>`>a}<esc>`<i{<esc>
"vnoremap $$ <esc>`>a"<esc>`<i"<esc>
"vnoremap $q <esc>`>a'<esc>`<i'<esc>
"vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
"inoremap $1 ()<esc>i
"inoremap $2 []<esc>i
"inoremap $3 {}<esc>i
"inoremap $4 {<esc>o}<esc>O
"inoremap $q ''<esc>i
"inoremap $e ""<esc>i
"inoremap $t <><esc>i

" Parenthesis matching
"nmap <C-p> m[%v%:sleep 350m<CR>`[
"imap <C-p> <Esc>m[%v%:sleep 350m<CR>`[a
""nmap <C-p> m[vab:sleep 350m<CR>`[
""imap <C-p> <Esc>m[vab:sleep 350m<CR>`[a

"" disable matchparen plugin at startup
"au VimEnter * NoMatchParen
"" enable / disable the matchparen plugin
"command Mp :DoMatchParen
"command Mp0 :NoMatchParen

" Prevent loading parenthesis matching
let g:loaded_matchparen = 1
"unlet loaded_matchparen
"highlight MatchParen ctermbg=blue guibg=lightblue
"highlight MatchParen ctermbg=red guibg=lightred

" Match Brackets
"let g:HiMtchBrktOn=1

" Prevent netrw from loading
"let g:loaded_netrw       = 1
"let g:loaded_netrwPlugin = 1

"-------------------------------------------------------------------------------
" Delete trailing white space
function! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunction

"" Removes trailing spaces
"function TrimWhiteSpace()
"  %s/\s*$//
"  ''
":endfunction

"map <F5> :call TrimWhiteSpace()<CR>
"map! <F5> :call TrimWhiteSpace()<CR>
" Show/Hide hidden Chars
map <silent> <F2> :set invlist<CR>
" Show/Hide found pattern (After search)
map <silent> <F3> :set invhlsearch<CR>
" Replace tab with 2 spaces
map <silent> <F4> :%s/\t/  /g<CR>
" Remove whitespace from end of lines
map <silent> <F5> :%s/\s\+$//g<CR>
" Convert current line into Title caps
map <silent> <F6> :s/\v<(.)(\w*)/\u\1\L\2/g<CR>
" Make F5 reload .vimrc
"map <silent> <F5> :source $VIM/_vimrc<CR>
if s:MSWIN
  " ==========  MS Windows  ======================================================
  if MySys()=="windows7"
    map <leader>rc  :e $HOME/_vimrc<CR>
    map <leader>grc :e $HOME/_gvimrc<CR>
  else
    map <leader>rc  :e $VIM/_vimrc<CR>
    map <leader>grc :e $VIM/_gvimrc<CR>
  endif
else
  " ==========  Linux/Unix  ======================================================
  map <leader>rc  :e $HOME/.vimrc<CR>
  map <leader>grc :e $HOME/.gvimrc<CR>
endif

" Delete buffer without closing window
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

" Code completion enhancements
set completeopt=longest,menuone
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>'  : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Macros {{{1
"if s:MSWIN
"  " ==========  MS Windows  ======================================================
"  execute "source " . $VIMRUNTIME . "/cream/cream-macros.vim"
"  imap <silent> <S-F8> <C-b>:call Cream_macro_record("q")<CR>
"  imap <silent> <F8>   <C-b>:call Cream_macro_play("q")<CR>
"else
"  " ==========  Linux/Unix  ======================================================
"endif
"}}}

"-----------------------------------------------------------------------------
" EnhCommentify
"-----------------------------------------------------------------------------
let g:EnhCommentifyAlignRight      = 'Yes'  " Default: 'No'
let g:EnhCommentifyAltClose        = '+|'   " Default: '+|'
let g:EnhCommentifyAltOpen         = '|+'   " Default: '|+'
let g:EnhCommentifyBindInInsert    = 'Yes'  " Default: 'Yes'
let g:EnhCommentifyBindInNormal    = 'Yes'  " Default: 'Yes'
let g:EnhCommentifyBindInVisual    = 'Yes'  " Default: 'Yes'
let g:EnhCommentifyBindPerBuffer   = 'No'   " Default: 'No'
let g:EnhCommentifyBindUnknown     = 'No'   " Default: 'No'
let g:EnhCommentifyCommentsOp      = 'Yes'  " Default: 'No'
let g:EnhCommentifyIdentString     = ''     " Default: ''
let g:EnhCommentifyIgnoreWS        = 'No'   " Default: 'Yes'
let g:EnhCommentifyMultiPartBlocks = 'Yes'  " Default: 'No'
let g:EnhCommentifyPretty          = 'Yes'  " Default: 'No'
let g:EnhCommentifyRespectIndent   = 'No'   " Default: 'No'
let g:EnhCommentifyUseAltKeys      = 'Yes'  " Default: 'No'
let g:EnhCommentifyUseBlockIndent  = 'No'   " Default: 'No'
let g:EnhCommentifyUseSyntax       = 'No'   " Default: 'No'

let g:EnhCommentifyFirstLineMode   = 'No'   " Default: 'No'
let g:EnhCommentifyTraditionalMode = 'No'   " Default: 'Yes'
let g:EnhCommentifyUserMode        = 'Yes'  " Default: 'No'
let g:EnhCommentifyUserBindings    = 'No'   " Default: 'No'

let g:EnhCommentifyCallbackExists  = 'Yes'  " Default: 'No'
function EnhCommentifyCallback(ft)
  if a:ft == 'verilog_systemverilog'
    let b:ECcommentOpen  = '//'
    let b:ECcommentClose = ''
  endif
endfunction
" <Plug>Comment / <Plug>DeComment
" <Plug>Traditional
" <Plug>FirstLine
"imap <M-c>      <Esc><Plug>Traditionalji
"vmap <Leader>c  <Plug>VisualFirstLine

imap <M-t>      <Esc><Plug>Traditionalji
vmap <M-t>      <Plug>VisualTraditional

" Default mapping
"vmap <M-c>      <Plug>VisualTraditionalj
"nmap <M-c>      <Plug>Traditionalj
"vmap <M-x>      <Plug>VisualTraditional
"nmap <M-x>      <Plug>Traditional

" 4.1 Standard keybindings:
"
"                               Meta-Keys:   <Leader>Keys:
"
" Traditional-mode:
" Traditionial                  <M-x>        <Leader>x
" Traditionial + one line down  <M-c>        <Leader>c
"
" FirstLine-mode:
" FirstLine                     <M-x>        <Leader>x
" FirstLine + one line down     <M-c>        <Leader>c
"
" User-mode:
" Comment                       <M-x>        <Leader>x
" Comment  + one line down      <M-c>        <Leader>c
" DeComment                     <M-y>        <Leader>X
" DeComment + one line down     <M-v>        <Leader>C

"-----------------------------------------------------------------------------
" RegExpRef
"-----------------------------------------------------------------------------
"map <LEADER>re :help regexpref<CR>

"------------------------------------------------------------------------------
" perl-support.vim_-_Perl_IDE
"------------------------------------------------------------------------------
"let g:Perl_LocalTemplateFile = $HOME.'/.vim-addons/perl-support.vim_-_Perl_IDE/perl-support/templates/Templates'
"let g:Perl_CodeSnippets      = $HOME.'/.vim-addons/perl-support.vim_-_Perl_IDE/perl-support/codesnippets/'
"echo g:Perl_LocalTemplateFile
"echo g:pydiction_location

"-------------------------------------------------------------------------------
" VST
"-------------------------------------------------------------------------------
com RP :exec "Vst html" | w! /tmp/test.html | :q | !firefox /tmp/test.html
"com RP :exec "Vst html" | exe "w! " . $TMP . "/test.html" | :q | exe "silent !cmd /c start " . $TMP . "\\test.html"
"com RP Vst html | exe "w! " . $TMP . "/test.html" | :q | exe "silent !cmd /c start " . $TMP . "\\test.html"

" Define error formats
"set errorformat+=**\ Error:\ %f(%l):\ %m
"set errorformat+=#\ OVM_ERROR

"-------------------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------------------
" Include user's local vim config
"if filereadable(expand("~/.vim/vundle.config"))
"  source ~/.vim/vundle.config
"endif

"set nocompatible               " be iMproved
filetype off                   " required!
if s:MSWIN
  " ==========  MS Windows  ======================================================
  if MySys()=="windows7"
    set runtimepath+=$HOME/vimfiles/bundle/vundle/
    call vundle#rc('$HOME/vimfiles/bundle')
  else
    set runtimepath+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc('$VIM/vimfiles/bundle')
  endif
else
  " ==========  Linux/Unix  ======================================================
  set runtimepath+=$HOME/.vim/bundle/vundle/
  call vundle#rc('$HOME/.vim/bundle')
endif
let g:vundle_default_git_proto = 'git'

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
Bundle 'Align'
Bundle 'antlr3.vim'
Bundle 'autohotkey-ahk'
Bundle 'automatic-for-Verilog'

"-------------------------------------------------------------------------------
" MiniBufExplorer
"-------------------------------------------------------------------------------
"Bundle 'minibufexplorerpp'
"Bundle 'bufexplorer.zip'
Bundle 'minibufexpl.vim'

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne=0

"-------------------------------------------------------------------------------
"Bundle 'Tab-Manager'
"let g:TabManager_maxFilesInTab=1

"set showtabline=2         " Always show tabline
"set hidden
"set switchbuf=usetab
"set switchbuf=usetab,newtab
"-------------------------------------------------------------------------------

Bundle 'bugfixes-to-vim-indent-for-verilog'
Bundle 'bwHomeEndAdv.vim'
Bundle 'Conque-Shell'
Bundle 'emacs-like-macro-recorder'
"Bundle 'hdl_plugin'
"Bundle 'jellybeans.vim'
Bundle 'jpythonfold.vim'
"Bundle 'davidhalter/jedi-vim'
"Bundle 'jedi-vim'
Bundle 'mru.vim'
" ~/.vim_mru_files
if s:MSWIN
  " ==========  MS Windows  ======================================================
  if MySys()=="windows7"
    let MRU_File=$HOME.'/vimfiles/_vim_mru_files'
  else
    let MRU_File=$VIM.'/vimfiles/_vim_mru_files'
  endif
else
  " ==========  Linux/Unix  ======================================================
  let MRU_File=$HOME.'/.vim/_vim_mru_files'
endif

"Bundle 'pythonhelper'

"Bundle 'signal_dec_VHDL'

"-------------------------------------------------------------------------------
" SnipMate
"-------------------------------------------------------------------------------
Bundle 'tomtom/tlib_vim'
Bundle 'MarcWeber/vim-addon-mw-utils'

"Bundle 'snipMate'
Bundle 'garbas/vim-snipmate'
let g:snips_author = 'Amal Khailtash'

Bundle 'honza/vim-snippets'
"Bundle 'snipmate-snippets'
"Bundle 'honza/snipmate-snippets'

"-------------------------------------------------------------------------------
" Perforce setup
"-------------------------------------------------------------------------------
"if executable("p4")
"  Bundle 'genutils'
"  Bundle "perforce"
"  runtime perforce/perforceutils.vim
"  runtime perforce/perforcemenu.vim
"  "so ~/.vim/bundle/perforce/perforce/perforceutils.vim
"  "so ~/.vim/bundle/perforce/perforce/perforcemenu.vim
"  let g:p4EnableMenu = 1
"  let g:p4UseExpandedMenu = 1
"  "let g:p4EnablePopupMenu = 1
"  "let g:p4UseExpandedPopupMenu = 1
"  "let g:p4Presets = '
"  "  \10.1.6.23:2004 akhailta_hslm1_mapa_loadd_diag akhailta,
"  "  \10.1.6.23:2004 akhailta_hslm1_mapb_loadd_diag akhailta,
"  "  \10.1.6.23:2004 akhailta_hslm1_mapb_loade_hseib_dev akhailta,
"  "  \10.1.6.23:2004 akhailta_hslm1_otn_loadd_diag akhailta
"  "\'
"  "let g:p4DefaultPreset = 2
"  "PFSettings EnableMenu 1
"  PFInitialize
"endif

"-------------------------------------------------------------------------------
Bundle 'The-NERD-tree'
"map <F2> :NERDTreeToggle<CR>
"map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
"map <leader>d :NERDTreeToggle<CR>
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"-------------------------------------------------------------------------------
"Bundle 'The-NERD-Commenter'

"-------------------------------------------------------------------------------
"Bundle 'amal_khailtash/vim-xdc-syntax'
"Bundle 'amal_khailtash/vim-xtcl-syntax'
Bundle 'vim-xdc-syntax'
Bundle 'vim-xtcl-syntax'

"-------------------------------------------------------------------------------
Bundle 'vlog_inst_gen'
"let g:vlog_inst_gen_mode=0
"        VlogInstGen : generate verilog instance
"        VlogInstMod : change working mode
"        ,ig         : VlogInstGen
"        ,im        : VlogInstMod
"-------------------------------------------------------------------------------

"Bundle 'VhdlNav'
Bundle 'Wombat'
Bundle 'visual-increment'

"-------------------------------------------------------------------------------
Bundle "tComment"
let g:tcommentMaps = 0
"let g:tcommentMapLeader1 = '<M-/>'
"let g:tcommentMapLeader2 = '<M-/>'
"nnoremap // :TComment<CR>
"vnoremap // :TComment<CR>
nnoremap <M-/> :TCommentAs cpp<CR>
vnoremap <M-/> :TCommentAs cpp<CR>
nnoremap <M-?> :TComment<CR>
vnoremap <M-?> :TComment<CR>

"-------------------------------------------------------------------------------
" Taglist
"-------------------------------------------------------------------------------
"Bundle "taglist.vim"

" --links=no --languages=Verilog,VHDL,Perl --options=$(CTAG_DIR)/extensions/system_verilog.txt
" let Tlist_Ctags_Cmd = 'C:/CygWin/usr/bin/ctags.exe'
" let Tlist_Ctags_Cmd = '/home/akhailta/bin/svtags -vi'
" let Tlist_Auto_Open = 1
let Tlist_Show_Menu = 1
let winManagerWindowLayout = 'FileExplorer|TagList'
nnoremap <silent> <F8> :TlistToggle<CR>

" Tags
"set tag=tags,../tags
set tags=.ctags_vim;

let tlist_verilog_systemverilog_settings='verilog_systemverilog;m:Modules;c:Classes;d:Defines;u:Includes;a:Assignments;e:Typedefs;g:Program;i:Interfaces;P:Parameters;Q:Paramaters;p:Ports;I:Inputs;O:Outputs;N:Outputs;f:Functions;t:Tasks;w:Signals'
"let tlist_verilog_systemverilog_settings='verilog_systemverilog;d:define;c:class;t:task;f:function;m:module;p:program;i:interface;e:typedef'
"let tlist_verilog_settings='verilog;c:constants (define, parameter, specparam);e:events;f:functions;m:modules;n:net data types;p:ports;r:register data types;t:tasks'

let Tlist_perl_settings = 'perl;c:constant;l:label;p:package;s:subroutine;a:attribute'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Show_One_File = 1

"nnoremap <silent> <F7> :TlistToggle<CR>
"nnoremap <leader>tl :TlistToggle<CR>
"-------------------------------------------------------------------------------
" ShowMarks7
"-------------------------------------------------------------------------------
Bundle 'ShowMarks7'

let g:showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1
" update custom highlights
function g:ex_CustomHighlight()
  " For marks a-z
  highlight clear ShowMarksHLl
" highlight ShowMarksHLl term=bold cterm=none ctermbg=LightBlue gui=none guibg=LightBlue
" highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
  highlight ShowMarksHLl ctermbg=Yellow ctermfg=Black guibg=#FFDB72 guifg=Black
  " For marks A-Z
  highlight clear ShowMarksHLu
" highlight ShowMarksHLu term=bold cterm=bold ctermbg=LightRed ctermfg=DarkRed gui=bold guibg=LightRed guifg=DarkRed
" highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
  highlight ShowMarksHLu ctermbg=Magenta ctermfg=Black guibg=#FFB3FF guifg=Black
  " For all other marks
  highlight clear ShowMarksHLo
" highlight ShowMarksHLo term=bold cterm=bold ctermbg=LightYellow ctermfg=DarkYellow gui=bold guibg=LightYellow guifg=DarkYellow
  highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
  " For multiple marks on the same line.
  highlight clear ShowMarksHLm
" highlight ShowMarksHLm term=bold cterm=none ctermbg=LightBlue gui=none guibg=SlateBlue
  highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen
endfunction
nmap <silent> <leader>mk :MarksBrowser<cr>
"-------------------------------------------------------------------------------
" Indent-Guides
"-------------------------------------------------------------------------------
Bundle 'Indent-Guides'

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
"let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
let g:indent_guides_color_change_percent = 10
nmap <Leader>ie :IndentGuidesEnable<CR>
nmap <Leader>id :IndentGuidesDisable<CR>
"-------------------------------------------------------------------------------
" MarVim ()
"-------------------------------------------------------------------------------
Bundle 'marvim'

if s:MSWIN
  if MySys()=="windows7"
"   let marvim_store    = $HOME.'/vim-addons/marvim/repository'
    let marvim_store    = $HOME.'/vimfiles/bundle/marvim/repository'
  else
"   let marvim_store    = $VIM.'/vim-addons/marvim/repository'
    let marvim_store    = $VIM.'/vimfiles/bundle/marvim/repository'
  endif
else
" let marvim_store    = '/home/akhailta/.vim-addons/marvim/repository'
  let marvim_store    = $HOME.'/.vim/bundle/marvim/repository'
endif
let  marvim_find_key  = '<S-F12>'   " change find key from <F2> to 'space'
let  marvim_store_key = '<S-F11>'   " change store key from <F3> to 'ms'
"let marvim_register  = 'c'         " change used register from 'q' to 'c'
let  marvim_prefix    = 0           " disable default syntax based prefix
nnoremap <F12> :exec "normal @q"<CR>

"-------------------------------------------------------------------------------
" vim-machit
"-------------------------------------------------------------------------------
"Bundle "tsaleh/vim-matchit"
Bundle "vim-matchit"

set matchpairs+=<:>

"-------------------------------------------------------------------------------
" Solarized
"-------------------------------------------------------------------------------
"Bundle 'altercation/vim-colors-solarized'
"Bundle 'Solarized'

"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
"let g:solarized_hitrail=1
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
""set background=dark
"if has('gui_running')
"  set background=light
"else
"  set background=dark
"endif
"colorscheme solarized
"call togglebg#map("<F9>")
"-------------------------------------------------------------------------------
" PowerLine
"-------------------------------------------------------------------------------
"Bundle 'vim-powerline'
Bundle 'Lokaltog/vim-powerline'

let g:Powerline_symbols = 'fancy'
set encoding=utf-8   " Necessary to show unicode glyphs
"-------------------------------------------------------------------------------
" Python
"-------------------------------------------------------------------------------
" pyflakes
"-------------------------------------------------------------------------------
"Bundle 'pyflakes.vim'

"-------------------------------------------------------------------------------
" Python-mode
"-----------------------------------------------------------------------------
if s:MSWIN
  " ==========  MS Windows  ======================================================
  "Bundle 'Python-mode-klen'
  "Bundle 'klen/python-mode'
else
  " ==========  Linux/Unix  ======================================================
endif
"-------------------------------------------------------------------------------
" Python auto-complete
"-------------------------------------------------------------------------------
if s:MSWIN
  " ==========  MS Windows  ======================================================
"  Bundle 'davidhalter/jedi-vim'
else
  " ==========  Linux/Unix  ======================================================
endif
"-------------------------------------------------------------------------------
" Pydiction
"-----------------------------------------------------------------------------
Bundle 'Pydiction'

if s:MSWIN
  " ==========  MS Windows  ======================================================
  if MySys()=="windows7"
"   let g:pydiction_location = $HOME.'/.vim-addons/Pydiction/complete-dict'
    let g:pydiction_location = $HOME.'/vimfiles/bundle/Pydiction/complete-dict'
  else
"   let g:pydiction_location = $VIM.'/.vim-addons/Pydiction/complete-dict'
    let g:pydiction_location = $VIM.'/vimfiles/bundle/Pydiction/complete-dict'
  endif
  "let g:pydiction_menu_height = 20
else
  " ==========  Linux/Unix  ======================================================
" let g:pydiction_location = $HOME.'/.vim-addons/Pydiction/complete-dict'
  let g:pydiction_location = $HOME.'/.vim/bundle/Pydiction/complete-dict'
  "let g:pydiction_menu_height = 20
endif
"-----------------------------------------------------------------------------
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

"Bundle 'ScopeVerilog'
"#set statusline+=%{Verilog_get_hierarchy()}
"set statusline=%!Pl#Statusline(0,0)

filetype plugin indent on     " required!
syntax on

"-------------------------------------------------------------------------------
"       \ 'Align294',
"       \ 'EnhCommentify',
"       \ 'HiMtchBrkt',
"       \ 'Lite_Tab_Page',
"       \ 'Marks_Browser',
"       \ 'Tab_Menu',
"       \ 'Tagbar',
"       \ 'VST',
"       \ 'compilerpython3044',
"       \ 'genutils',
"       \ 'noused',
"       \ 'python790',
"       \ 'python_match',
"       \ 'reorder_tabs',

"let g:MyVimTips="off"
"function! ToggleVimTips()
"  if g:MyVimTips == "on"
"    let g:MyVimTips="off"
"    pclose
"  else
"    let g:MyVimTips="on"
"    pedit ~/vimtips.txt
"  endif
"endfunction
"nnoremap <F9> :call ToggleVimTips()<CR>
