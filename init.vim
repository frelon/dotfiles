" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdTree'
Plug 'fatih/vim-go'

Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'sebdah/vim-delve'

Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'hashivim/vim-terraform'

call plug#end()

" --- Keybindings ---

" NERD Tree
nmap <C-n> :NERDTreeToggle<CR>

" FZF
nmap <C-o> :FZF<CR>
nmap <C-f> :Lines<CR> 

" Window management
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
tmap <C-h> <C-w>h
tmap <C-j> <C-w>j
tmap <C-k> <C-\><C-n><C-w>k
tmap <C-l> <C-w>l

" Terminal
autocmd TermOpen * setlocal nonumber norelativenumber nocursorline

" Split to terminal
nmap <C-s>t :split<CR><C-j>:resize 15<CR>:terminal<CR>i

" Close terminal
" tmap <Esc> <C-\><C-n>:q<CR>
tmap <Esc> <C-\><C-n>


" --- Settings ---
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$']

let g:go_fmt_command="goimports"

" Cursor
set cursorline
highlight CursorLineNr cterm=NONE ctermbg=2 ctermfg=8 gui=NONE guibg=NONE guifg=NONE
highlight CursorLine cterm=NONE ctermbg=2 ctermfg=8 gui=NONE guibg=NONE guifg=NONE

" Debug go (delve)

nmap <F5> :DlvDebug<CR>
nmap <F9> :DlvToggleBreakpoint<CR>

" terraform

let g:terraform_fmt_on_save=1

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" Close preview window
set completeopt-=preview

set number
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" add Jenkinsfile
au! BufNewFile,BufReadPost Jenkinsfile set filetype=groovy

" Hide status line when open fzf window
augroup fzf_hide_statusline
    autocmd!
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END
