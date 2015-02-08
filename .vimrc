" Luciano Fiandesio
" http://fiandes.io
"

" ---------- VERY IMPORTANT -----------
" To install plugin the first time:
" > vim +BundleInstall +qall
" -------------------------------------

call plug#begin('~/.vim/plugged')


Plug 'altercation/vim-colors-solarized' " solarized colorscheme
Plug 'neocomplcache'                    " completion during typing

Plug 'ntpeters/vim-better-whitespace'   " Right way to handle trailing-whitespace

Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
Plug 'scrooloose/syntastic'             " syntax checker

call plug#end()

" leader
let mapleader=","

" =============
" Plugin config
" =============

" -----------------
" THEME
" -----------------

" -- solarized theme
set background=dark
try
colorscheme solarized
catch
endtry

" ----------------------------
" File Management
" ----------------------------
let g:unite_source_history_yank_enable = 1
try
let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry

" use ag for search in files
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
\ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ' .
\ '--ignore ''**/*.pyc'''

" search a file in the filetree
nnoremap <leader>n :<C-u>Unite -start-insert -default-action=split file_rec/async:!<CR>
" search a file in the filetree / no subdirectories
nnoremap <leader>nn :<C-u>Unite -start-insert -default-action=split file/async<CR>
" search a file in the filetree / no subdirectories
nnoremap <leader>l :<C-u>Unite -default-action=split grep:.<CR>
nnoremap <leader>e :<C-u>Unite -buffer-name=mru -start-insert -default-action=split file_mru<CR>

" neocomplcache (advanced completion)
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_dictionary_filetype_lists = {
\ 'default' : '',
\ 'vimshell' : $HOME.'/.vimshell_hist',
\ 'scheme' : $HOME.'.ghosh_completions'
\ }
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" syntastic
let g:syntastic_mode_map = { 'mode': 'active',
    \ 'active_filetypes': [] }
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'


" ==========
" VIM CONFIG
" ==========


set nocompatible                " Make Vim more useful, keep at the beginning
set clipboard=unnamed           " Use the OS clipboard by default (on versions compiled with `+clipboard`)
set wildmenu                    " Enhance command-line completion
set backspace=indent,eol,start  " Allow backspace in insert mode
set ttyfast                     " Optimize for fast terminal connections
set gdefault                    " Add the g flag to search/replace by default
set binary
set noeol                       " Don’t add empty newlines at the end of files
set modeline                    " Respect modeline in files
set ignorecase                  " Ignore case of searches
set hlsearch                    " Highlight searches
set smartindent
set fileencoding=utf-8          " Use UTF-8 without BOM
set encoding=utf-8 nobomb
set incsearch                   " Highlight dynamically as pattern is typed
set showmatch
set relativenumber              " Show relative numbers too (hybrid mode)
set number                      " Show line numbers
set nobackup
set noswapfile
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                       " Show the filename in the window titlebar
set visualbell                  " do not beep
set noerrorbells
set nostartofline               " Don’t reset cursor to start of line when moving around.
syntax on                       " Enable syntax highlighting
set cursorline                  " Highlight current line
set tabstop=4                   " Make tabs as wide as two spaces
set shiftwidth=4
set expandtab
set shortmess=atI               " Don’t show the intro message when starting Vim
set ruler                       " Show the cursor position
set showmode                    " Show the current mode
set modelines=4
set t_Co=256                    " Set 256 colors


filetype on
filetype indent on
filetype plugin on


" disable arrow keys
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <C-j> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Get output of shell commands
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>"


noremap <leader>ss :StripWhitespace<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" set font
set guifont=Menlo\ Regular:h14

" compile gradle
map <F4> :w<CR> :compiler gradle<CR> :make test<CR>:cw 4<CR>

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

" highlight 81 chars (tip from Damian Conway)
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

function! HLNext (blinktime)
    highlight WhiteOnRed ctermfg=white ctermbg=red

    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" Use space to jump down a page (like browsers do)...
nnoremap <Space> <PageDown>

" Spellchecking
if has("spell") " if vim support spell checking
  " Download dictionaries automatically
  if !filewritable($HOME."/.vim/spell")
    call mkdir($HOME."/.vim/spell","p")
  endif
  set spellsuggest=10 " z= will show suggestions (10 at most)
  " spell checking for text, HTML, LaTeX, markdown and literate Haskell
  autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spell
  autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spelllang=fr,en
  " better error highlighting with solarized
  highlight clear SpellBad
  highlight SpellBad term=standout ctermfg=2 term=underline cterm=underline
  highlight clear SpellCap
  highlight SpellCap term=underline cterm=underline
  highlight clear SpellRare
  highlight SpellRare term=underline cterm=underline
  highlight clear SpellLocal
  highlight SpellLocal term=underline cterm=underline
endif