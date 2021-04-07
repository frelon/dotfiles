if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'machakann/vim-highlightedyank'
Plug 'christoomey/vim-tmux-navigator'
Plug 'SirVer/ultisnips'
Plug 'akarl/autoformat.nvim'
Plug 'leafgarland/typescript-vim'

call plug#end()

" --- Keybindings ---

let mapleader = ' '
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>d :windo diffthis<CR>
nnoremap <leader>v :vsplit $MYVIMRC<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Gclog<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gcc :Gcommit -m ""<Left>
nnoremap <leader>gco :Git checkout -b 
nnoremap <leader>gca :Git commit --amend --no-edit<CR><CR>
nnoremap <leader>gpp :Git push<CR>
nnoremap <leader>gpf :Git push --force-with-lease<CR>
nnoremap <leader>h :Helptags<CR>
nnoremap <leader>rs :!rm .stamp/*<CR>
nnoremap <leader>c :copen<CR>
nnoremap <leader>mi :Make ECR_TAG=local image tag<CR>
nnoremap <leader>mt :Make test<CR>
nnoremap <leader>mg :Make generate<CR>
nnoremap <leader>ml :call GolangCILint()<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>yp :let @+ = expand("%")<CR>
nnoremap <leader>tf :TestNearest -strategy=neovim -v<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>gtc :!go test -coverprofile c.out ./...; go tool cover -html c.out && rm c.out<CR>

nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>

nnoremap <leader>o :FZF<CR>
nnoremap <leader>s :vnew<CR>
map Y y$

" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader>f :EasyAlign*<Bar><Enter>

" Autosource $MYVIMRC
autocmd bufwritepost init.vim source $MYVIMRC

" Coc

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
"
" Autoformat settings
" use bash as shell... TODO
set shell=/usr/bin/bash
call autoformat#config('go', ['goimports -local "$(go list -m)"', 'gofumpt -s -extra'])
autocmd! BufWritePre * :Autoformat

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
highlight Comment gui=italic

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

" Golang Linting
	" GolangCILint lints the project from the current directory and puts the
	" result inside the quickfix list.
	function! GolangCILint()
		cexpr []

		" Run only the typecheck first.
		let l:errors = system("golangci-lint run --no-config --disable-all -E typecheck --out-format line-number --print-issued-lines=false")

		if l:errors == ""
			let l:errors = system("golangci-lint run --out-format line-number --print-issued-lines=false")
		endif

		if l:errors == ""
			echo "GolangCILint: OK!"
		else
			cexpr l:errors
			copen
		endif
	endfunction
