" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" === VUNDLE ===

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Required
Plugin 'VundleVim/Vundle.vim'

" Behavior
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'justinmk/vim-dirvish'
Plugin 'majutsushi/tagbar'
Plugin 'ajh17/VimCompletesMe'
Plugin 'freitass/todo.txt-vim'

" UI
Plugin 'maxluzuriaga/vim-hybrid'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/syntastic'
Plugin 'ap/vim-buftabline'

" Languages
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'jvirtanen/vim-octave'
Plugin 'justinmk/vim-syntax-extra'

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
set number             " Show line numbers

" Tab settings
set tabstop=4
set shiftwidth=4
set expandtab

" Smarter wrapping
set nolist wrap linebreak breakat&vim
if has("breakindent")
    set breakindent
endif

" Show visual break with '->'
set showbreak=->\ 

" Tabs not spaces for Go and Makefiles
au FileType go setlocal noexpandtab
au FileType make setlocal noexpandtab


" === COLORS AND STYLES ===

set background=dark
set t_Co=256
colorscheme hybrid
set colorcolumn=80
" Turn off background color, so it uses terminal's color
hi Normal ctermbg=none

let font='Meslo\ LG\ M\ Regular\ for\ Powerline:'
let smallSize='h12'
let bigSize='h18'
execute ":set guifont=".font.smallSize

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Status bar
set laststatus=2

" === PLUGIN CONFIG ===

" Use Ag over Ack
if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor'
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Buftabline
let g:buftabline_indicators = 1

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

" GitGutter
set updatetime=250


" === KEY BINDINGS ===

let mapleader = "\<Space>"

" Up and down visually
nnoremap j gj
nnoremap k gk

" Backslash hides current search
nnoremap \ :noh<CR>:<backspace>

" Enter selects the highlighted suggestion when auto-completing
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Presentation mode
command! Big :execute "set guifont=".font.bigSize
command! Small :execute "set guifont=".font.smallSize

" Todo.txt editing
function! ToggleFile(file)
    if expand('%:p') == expand(a:file)
        " Only close todo buffer if it's not the last one
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) <= 1
            return
        endif

        let todobufnr = bufnr('%')

        if exists('b:todoprevbufnr')
            " If we know what buffer we came from, go to that one
            execute 'buffer' b:todoprevbufnr
        else
            " Else just go to whatever is previous in buffer list
            bprevious
        endif

        execute 'bdelete' todobufnr
    else
        " Navigate to todo.txt, keeping track of the buffer we came from
        let bufnr = bufnr('%')
        execute 'edit' a:file
        let b:todoprevbufnr = bufnr
    endif
endfunction
command! Todo call ToggleFile('~/todo.txt')

" Split with _ and |, and stop the original window scrolling when splitting
" horizontally
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" Leader keys
nnoremap <Leader>t :CtrlP<CR>
nnoremap <Leader>r :CtrlPTag<CR>
nnoremap <Leader>b :TagbarToggle<CR>
nnoremap <Leader>d :Todo<CR>
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
