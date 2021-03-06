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
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'justinmk/vim-dirvish'
Plugin 'majutsushi/tagbar'
Plugin 'ajh17/VimCompletesMe'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'metakirby5/codi.vim'
Plugin 'junegunn/fzf.vim'

" UI
Plugin 'maxluzuriaga/vim-hybrid'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/syntastic'
Plugin 'ap/vim-buftabline'
Plugin 'kien/rainbow_parentheses.vim'

" Languages
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'justinmk/vim-syntax-extra'
Plugin 'fatih/vim-go'
Plugin 'tikhomirov/vim-glsl'

call vundle#end()


" === GENERAL CONFIG ===

syntax on
set encoding=utf-8

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

" cscope config
if has('cscope')
    set cscopetag cscopeverbose

    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help
endif

" === COLORS AND STYLES ===

set background=dark
set t_Co=256
colorscheme hybrid
set colorcolumn=80

" Set cursor shapes by mode
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"
if has("t_SR")
    let &t_SR = "\<Esc>[4 q"
endif

set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h12

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Status Line
set laststatus=2

" Status Function
function! Status(winnum)
    let active = a:winnum == winnr()
    let bufnum = winbufnr(a:winnum)

    let stat = ''

    " this function just outputs the content colored by the
    " supplied colorgroup number, e.g. num = 2 -> User2
    " it only colors the input if the window is the currently
    " focused one
    function! Color(active, num, content)
        if a:active
            return '%' . a:num . '*' . a:content . '%*'
        else
            return a:content
        endif
    endfunction

    " this handles alternative statuslines
    let usealt = 0
    let altstat = Color(active, 2, ' »')

    let type = getbufvar(bufnum, '&buftype')
    let name = bufname(bufnum)

    if type ==# 'help'
        let altstat .= ' ' . fnamemodify(name, ':t:r')
        let usealt = 1
    elseif name ==# '__Gundo__'
        let altstat .= ' Gundo'
        let usealt = 1
    elseif name ==# '__Gundo_Preview__'
        let altstat .= ' Gundo Preview'
        let usealt = 1
    endif

    if usealt
        let altstat .= Color(active, 2, ' «')
        return altstat
    endif

    " file name
    let stat .= Color(active, 2, active ? ' »' : ' «')
    let stat .= ' %<'
    let stat .= Color(active, 4, '%f')
    let stat .= ' ' . Color(active, 2, active ? '«' : '»')

    " file modified
    let modified = getbufvar(bufnum, '&modified')
    let stat .= Color(active, 3, modified ? ' +' : '')

    " read only
    let readonly = getbufvar(bufnum, '&readonly')
    let stat .= Color(active, 3, readonly ? ' ‼' : '')

    " paste
    if active && &paste
        let stat .= ' %2*' . 'P' . '%*'
    endif

    let stat .= ' %#warningmsg#' " switch to warningmsg color
    let stat .= '%{SyntasticStatuslineFlag()}' " show Syntastic flag
    let stat .= '%*' " back to normal color

    " right side
    let stat .= '%='

    if active
        let stat .= '%5*栏%*%c %5*行%*%l/%L' " col and row numbers
    endif

    " git branch
    if exists('*fugitive#head')
        let head = fugitive#head()

        if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
            call fugitive#detect(getcwd())
            let head = fugitive#head()
        endif
    endif

    if !empty(head)
        let stat .= Color(active, 2, ' ← ') . Color(active, 4, head) . ' '
    endif

    return stat
endfunction

" Status AutoCMD
function! s:RefreshStatus()
    for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END


" === PLUGIN CONFIG ===

" Use Ag over Ack
if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor'
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in fzf for listing files
    let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
endif

" Show a preview of each file with fzf with ccat (if installed) or cat
let g:fzf_files_options =
  \ '--preview "(ccat --bg=dark {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" Buftabline
let g:buftabline_indicators = 1

" Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck', 'go']

let g:syntastic_c_checkers = ['make']

let g:syntastic_error_symbol = 'EE'
let g:syntastic_warning_symbol = 'WW'
let g:syntastic_style_error_symbol = 'SE'
let g:syntastic_style_warning_symbol = 'SW'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" GitGutter
set updatetime=250

" Always enable rainbow parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Necessary to enable fzf
set rtp+=/usr/local/opt/fzf


" === KEY BINDINGS ===

let mapleader = "\<Space>"

" More ergonomic escape
inoremap jk <Esc>
inoremap kj <Esc>

" Up and down visually
nnoremap j gj
nnoremap k gk

" Backslash hides current search
nnoremap \ :noh<CR>:<backspace>

" Enter selects the highlighted suggestion when auto-completing
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Split with _ and |, and stop the original window scrolling when splitting
" horizontally
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" Search with fzf
nnoremap <C-p> :Files<CR>

" Leader keys
nnoremap <Leader>t :CtrlP<CR>
nnoremap <Leader>w :q<CR>
nnoremap <Leader>s :w<CR>

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
