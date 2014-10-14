" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set t_Co=256
let mapleader=","

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  set nocp
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Color scheme And Fonts
colorscheme slate
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set guifontset=
set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 11

" Syntax on
syntax on

" Auto cd to current directory
autocmd BufEnter * cd %:p:h

"Toggle Menu and Toolbar
set guioptions-=m
set guioptions-=T
map <silent> <F12> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>

" Line number
set nu

" Line Wrap
set wrap

" Indent
" set cindent
autocmd FileType h,c,cpp set shiftwidth=4 softtabstop=4 tabstop=4 | set cindent | set expandtab
autocmd FileType python set shiftwidth=4 softtabstop=4 tabstop=4 | set expandtab 

" Default file type
" set ft=cpp

" set the menu & the message to English
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Tag list (ctags)
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Sort_Type = "name"
set updatetime=100
nnoremap <silent> <F4> :TlistOpen<CR>

" netrw setting
let g:netrw_winsize = 30
nmap <silent> <leader>fe :e!<CR>

" tab
nmap H :tabprevious<CR>
nmap L :tabnext<CR>
nmap T :tabnew<CR>
nmap W :tabclose<CR>

" OmniCppComplete
set completeopt=longest,menu
set wildmenu
setl omnifunc=nullcomplete#Complete
autocmd FileType * setl omnifunc=nullcomplete#Complete
autocmd FileType python setl omnifunc=pythoncomplete#Complete
autocmd FileType javascript setl omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html setl omnifunc=htmlcomplete#CompleteTags noci
autocmd FileType css setl omnifunc=csscomplete#CompleteCSS noci
autocmd FileType xml setl omnifunc=xmlcomplete#CompleteTags
autocmd FileType php setl omnifunc=phpcomplete#CompletePHP
autocmd FileType c setl omnifunc=ccomplete#Complete
autocmd FileType h setl omnifunc=cppcomplete#Complete
au BufNewFile,BufRead,BufEnter *.tpp,*.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
let OmniCpp_GlobalScopeSearch = 1  " 0 or 1
let OmniCpp_NamespaceSearch = 2   " 0 ,  1 or 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
set tags=~/.vim/plugin/tags/tags
set tags+=~/.vim/plugin/tags/cpptags
set tags+=~/Documents/dev/Projects/redis/redis-2.8.13/tags
set tags+=./tags
map <silent> <F5> :!ctags -R .<CR>

" cscope
cs a cscope.out
set cscopequickfix=s+,c+,d+,i+,t+,e+

" temp file location
set directory=~/.vim/temp/swp/
set backupdir=~/.vim/temp/backup/

" Command mapping
cmap W w
cmap Q q
cmap WQ wq
cmap wQ wq

" Move between logical line
nmap j gj
nmap k gk
nmap <Up> g<Up>
nmap <Down> g<Down>

" Paste mode
let paste_mode = 1
map <silent> <F11> :if paste_mode == 0 <CR>
	\set paste <CR>
	\echo "Enter paste mode" <CR>
	\let paste_mode = 1 <CR>
\else <CR>
	\set nopaste <CR>
	\echo "Leave paste mode" <CR>
	\let paste_mode = 0 <CR>
\endif <CR>

" Highlight search
map <silent> <F3> : nohls <CR>
set smartcase

" Pmenu
hi Pmenu guibg=#B0B0B0
hi PmenuSel guibg=#4169E1

set gcr=a:blinkon800-blinkoff800

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
" let g:Powerline_symbols = 'fancy'

" indentLine
let g:indentLine_color_term = 245

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0


"...............Bundle................."
set nocompatible                " be iMproved
filetype off                    " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

"my Bundle here:
"
" original repos on github
Bundle 'bling/vim-airline'
" Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'davidhalter/jedi-vim'
Bundle 'tpope/vim-fugitive'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Yggdroot/indentLine'
Bundle 'ConflictMotions'
Bundle 'CountJump'
Bundle 'ingo-library'
Bundle 'tpope/vim-repeat'
Bundle 'visualrepeat'
" Bundle 'Valloric/YouCompleteMe'
"..................................
" vim-scripts repos
"..................................
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
"......................................
filetype plugin indent on
