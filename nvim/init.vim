if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sebdah/vim-delve'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-highlightedyank'
Plug 'christoomey/vim-tmux-navigator'
Plug 'SirVer/ultisnips'

call plug#end()

" --- Keybindings ---

let mapleader = ' '
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <leader>x :x<CR>
nmap <leader>d :windo diffthis<CR>
nmap <leader>f :grep 
nmap <leader>v :vsplit $MYVIMRC<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>gl :Gclog<CR>
nmap <leader>h :Helptags<CR>
nmap <leader>rs :!rm .stamp/*<CR>
nmap <leader>c :copen<CR>
nmap <leader>mi :make ECR_TAG=local image tag<CR>
nmap <leader>ml :make GOLANGCI_FLAGS="--color=never" lint<CR>
nmap <leader>mt :make test<CR>
nmap <leader>e :Explore<CR>
nmap <leader>yp :let @+ = expand("%")<CR>
nmap <leader>tf :TestNearest -v<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>gc :!go test -coverprofile c.out ./...; go tool cover -html c.out && rm c.out<CR>

nmap <C-n> :cnext<CR>
nmap <C-p> :cprev<CR>

nmap <leader>t :split<CR><C-j>:resize 15<CR>:terminal<CR>i
nmap <leader>o :FZF<CR>
nmap <leader>s :vnew<CR>
nmap <C-a> ggVG
map Y y$

" Autosource $MYVIMRC
autocmd bufwritepost init.vim source $MYVIMRC

" Fold

" augroup folding
"   au BufReadPre *.go setlocal foldmethod=indent
" augroup END

" Coc

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Goto next/prev diagnostic
nmap <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>p <Plug>(coc-diagnostic-prev)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation K
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Go

augroup autoformat
    autocmd!

    autocmd! BufWritePre *.go call CocAction("format") | call CocAction('runCommand', 'editor.action.organizeImport')
augroup END

" Terminal
autocmd TermOpen * setlocal nonumber norelativenumber nocursorline

" Close terminal
tmap <Esc> <C-\><C-n>

" --- Settings ---
set grepprg=rg\ --vimgrep
set hidden
set mouse=a
set hlsearch
set clipboard=unnamedplus
set inccommand=nosplit
set incsearch
set splitbelow
set splitright
set number
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set signcolumn=yes
set ignorecase

" Colors
set termguicolors
set cursorline
colorscheme simple-dark

" Comments and italics
highlight Comment cterm=italic

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab foldmethod=indent

" add Jenkinsfile
au! BufNewFile,BufReadPost Jenkinsfile set filetype=groovy

" Hide status line when open fzf window
augroup fzf_hide_statusline
    autocmd!
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Function to create the custom floating window
function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)

    let height = 20
    let width = float2nr(winwidth(0) * 0.6)
    let horizontal = float2nr((winwidth(0) - width) / 2)
    let vertical = 3

    let opts = {
                \ 'relative': 'win',
                \ 'row': vertical,
                \ 'col': horizontal,
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    " open the new window, floating, and enter to it
    call nvim_open_win(buf, v:true, opts)
endfunction

" Colorizer
lua require'colorizer'.setup()


