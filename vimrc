" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" === VUNDLE ===

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Required
Plugin 'VundleVim/Vundle.vim'

Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-unimpaired'
Plugin 'othree/html5.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'majutsushi/tagbar'
Plugin 'ajh17/VimCompletesMe'

call vundle#end()


" === GENERAL CONFIG ===

syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Have Vim jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Have Vim load indentation rules according to the detected filetype. Per
" default Debian Vim only load filetype specific plugins.
if has("autocmd")
    filetype plugin indent on
endif

set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set hlsearch           " Highlight results as searching
set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a            " Enable mouse usage (all modes) in terminals

set number
set ruler
set tabstop=4
set shiftwidth=4
set expandtab
set nolist wrap linebreak breakat&vim
set breakindent

" Show visual break with '->'
set showbreak=->\ 

" Don't show mode (Airline takes care of it)
set noshowmode

" open new split panes to right and bottom, which feels more natural
" set splitbelow
set splitright

" Tabs not spaces for Go
au FileType go setlocal noexpandtab


" === COLORS AND STYLES ===

set background=dark
set t_Co=256
colorscheme hybrid
set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h12

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END


" === PLUGIN CONFIG ===

" Airline
set laststatus=2

if executable('ag')
    " Use Ag over Grep
    let g:ackprg = 'ag --nogroup --nocolor'
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:airline_theme='bubblegum'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
set encoding=utf-8

" Powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" NERDTree settings
let NERDTreeIgnore=['\.pyc$', '\.swp$']
let NERDTreeShowHidden=1

" Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_error_symbol = '❌'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_error_symbol = '☣'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn


" === KEY BINDINGS ===

let mapleader = "\<Space>"

" Don't have to press shift to enter a command :)
nore ; :
" But sometimes I still want to use the ; command
nore , ;

" Up and down visually
nnoremap j gj
nnoremap k gk

" Backslash hides current search
nnoremap \ :noh<CR>:<backspace>

" Enter selects the highlighted suggestion when auto-completing
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Leader keys
nnoremap <Leader>t :CtrlP<CR>
nnoremap <Leader>r :CtrlPTag<CR>
nnoremap <Leader>e :NERDTree<CR>
nnoremap <Leader>b :TagbarToggle<CR>
nnoremap <Leader>w :q<CR>
nnoremap <Leader>s :w<CR>

" Easy switching between splits
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>

" Switch between buffers
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>


" === LOCAL CUSTOMIZATION ==

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
