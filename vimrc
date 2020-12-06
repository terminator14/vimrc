" ####################
" ##### Vim-Plug #####
" ####################

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!echo Downloading and installing Vim-Plug..."
  silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  silent execute '!echo -e "    Vim-Plug installed\n"'
  silent execute "!sleep 3"
endif

" Define plugins
call plug#begin('~/.vim/plugged')

    " Highlight tabs, and trailing whitespace
    Plug 'jpalardy/spacehi.vim'

    " Nice color scheme
    Plug 'morhetz/gruvbox'

    " NERDTree - a filesystem explorer
    " nerdtree-git-plugin is a NERDTree plugin that adds git markings
    " to NERDTree
    Plug 'preservim/nerdtree' |
        \ Plug 'Xuyuanp/nerdtree-git-plugin'

    " Git integration
    Plug 'airblade/vim-gitgutter'

    " Tagbar
    Plug 'majutsushi/tagbar'

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" #####################
" ##### My config #####
" #####################

" Disable auto-indent enabled by vim-plug
" Note: I'll try getting used to it
"filetype indent off

" Disable incremental search
" Note: I'll try getting used to it
"set noincsearch

" Enable syntax highlighting
" Technically vim-plug already does this automatically
syntax on

" Enable line numbers
set number

" Enable relative line numbers
set relativenumber

" show existing tab with 4 spaces width
set tabstop=4

" When you hit tab to add 4 spaces, with this, backspace will delete 4 spaces
set softtabstop=4

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

" Always show the status bar
set laststatus=2

" Disable auto-comment insertion on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" This disables my accidental hitting of q:
" instead of :q from opening command line history
" (http://vim.wikia.com/wiki/Using_command-line_history)
nnoremap q: <NOP>

" Length of idle time before vim writes to the swapfile
" Also controls how often vim updates git tags in gitgutter bar
set updatetime=100

" #################################
" # Whitespace Highlighter Plugin #
" #################################

" Enable whitespace highlighting plugin
autocmd VimEnter * ToggleSpaceHi

" ############
" # NERDTree #
" ############

" \n will open/close NERDTree
nnoremap <Leader>n :NERDTreeToggle<Enter>

" Fix NerdTree ^G characters on MacOS
let g:NERDTreeNodeDelimiter = "\u00a0"

" Have vim close if nerdtree is open, but you close the last file you're editing
" Without this, if you close the file, NerdTree will still be open on its own
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ###########
" # NumLock #
" ###########

" Fix numpad keys over Putty
inoremap <Esc>Oq 1
inoremap <Esc>Or 2
inoremap <Esc>Os 3
inoremap <Esc>Ot 4
inoremap <Esc>Ou 5
inoremap <Esc>Ov 6
inoremap <Esc>Ow 7
inoremap <Esc>Ox 8
inoremap <Esc>Oy 9
inoremap <Esc>Op 0
inoremap <Esc>On .
inoremap <Esc>OQ /
inoremap <Esc>OR *
inoremap <Esc>Ol +
inoremap <Esc>OS -
inoremap <Esc>OM <Enter>

" Stop Numlock from brining up the help menu in Putty
inoremap OP <NOP>
nnoremap OP <NOP>

" Keys to remap gnome terminal numpad keys when numlock is off
" Works, but also remaps regular buttons, like arrow keys
"inoremap OF 1
"inoremap OB 2
"inoremap [6~ 3
"inoremap OD 4
"inoremap OE 5
"inoremap OC 6
"inoremap OH 7
"inoremap OA 8
"inoremap [5~ 9
"inoremap [2~ 0
"inoremap [3~ .
"inoremap Oo /
"inoremap Oj *
"inoremap Ok +
"inoremap Om -
"inoremap OM <Enter>

" ###########
" # Gruvbox #
" ###########

" Set color scheme
colorscheme gruvbox
set bg=dark

" ##########
" # Tagbar #
" ##########

map <leader>t :TagbarToggle<CR>

" #############
" # Copy Mode #
" #############

" Ctrl-C to enter/exit copy mode
" Useful if you want to copy something to clipboard
" This closes everything that might get in your way
" Note: Copy mode is just something I came up with - not a real thing

function ToggleCopyMode()
    :set number!
    :set relativenumber!
    :GitGutterToggle
    :NERDTreeClose
    :TagbarClose
endfunction

" Create a command that calls the function
" Without this, you'd need to run ":call ToggleCopyMode" in vim
command! ToggleCopyMode call ToggleCopyMode()

" If you click Ctrl+L, run :ToggleLineNumbers
nnoremap <C-C> :ToggleCopyMode<CR>

" ###############################################
" # Ignore Cached Entries in Adobe Animate File #
" ###############################################

" Ctrl-A in vimdiff to use

" I could, but didn't want to make this happen transparently, because
" a diff should always tell me the actual difference, and not ignore
" anything, unless I specifically ask it to. If a vimdiff showed no
" differences between two files that had differences, it would be
" super difficult to figure out that something was being ignored that I
" wasn't expecting

" Ignore CachedBmp lines in Adobe files
let g:diffignore='"CachedBmp.*"'

" Define expression that will be used to generate diff, rather than
" the default 'diff' binary
function MyDiff()
   let opt = ""
   if exists("g:diffignore") && g:diffignore != ""
     let opt = "-I " . g:diffignore . " "
   endif
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-b "
   endif
   silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
    \  " > " . v:fname_out
   redraw!
endfunction

" Define function that will enable the above expression
function AA()
    set diffexpr=MyDiff()
    diffupdate
endfunction

" Create a command that calls the function
" Without this, you'd need to run ":call AA()" in vim
command! AA call AA()

" If you click Ctrl+A, run :AA
nnoremap <C-A> :AA<CR>
