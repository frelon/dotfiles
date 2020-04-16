


" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sebdah/vim-delve'

Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'hashivim/vim-terraform'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-highlightedyank'

call plug#end()

" --- Keybindings ---

let mapleader = ' '
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <leader>v :vsplit $MYVIMRC<CR>

" Autosource $MYVIMRC
autocmd bufwritepost init.vim source $MYVIMRC

" Fold

augroup folding
  au BufReadPre *.go setlocal foldmethod=indent
augroup END

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

" Go

let g:go_def_mapping_enabled = 0
let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 1
let g:go_asmfmt_autosave = 0
let g:go_metalinter_autosave = 0
let g:go_code_completion_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_fmt_command="goimports"

augroup autoformat
    autocmd!

    autocmd! BufWritePre *.go call s:autoFormat(expand("<abuf>"), 'goimports -local "(go list -m)"', 'gofmt -s')
augroup END

" Window management
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
tmap <C-h> <C-w>h
tmap <C-j> <C-w>j
tmap <C-k> <C-\><C-n><C-w>k
tmap <C-l> <C-w>l


nmap <leader>tn :tabn<CR>
nmap <leader>tp :tabp<CR>

nmap td :tabclose<CR>
nmap to :FZF<CR>
nmap <leader>t :split<CR><C-j>:resize 15<CR>:terminal<CR>i
nmap tn :tabnew<CR>
nmap <leader>o :FZF<CR>
nmap <leader>s :vsplit<CR>

nmap <C-f> :Lines<CR> 
nmap <C-a> ggVG

" Terminal
autocmd TermOpen * setlocal nonumber norelativenumber nocursorline

" Close terminal
tmap <Esc> <C-\><C-n>

" --- Settings ---
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$']

set hidden
set mouse=a
set nohlsearch
set clipboard=unnamedplus
set inccommand=nosplit
set incsearch
set splitbelow
set splitright

" Cursor
set cursorline
highlight CursorLineNr cterm=NONE ctermbg=236 ctermfg=8 gui=NONE guibg=NONE guifg=NONE
highlight CursorLine cterm=NONE ctermbg=236 ctermfg=NONE gui=NONE guibg=NONE guifg=NONE

" Comments and italics
highlight Comment cterm=italic

" Debug go (delve)

" nmap <leader>gd :DlvDebug<CR>
" nmap <leader>gb :DlvToggleBreakpoint<CR>

" terraform

let g:terraform_fmt_on_save=1

let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
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


" autoformat current buffer
function! s:autoFormat(bufnr_str, ...)
        let l:view = winsaveview()
        let l:bufnr = str2nr(a:bufnr_str)
        let l:col = col('.')

        let l:result = nvim_buf_get_lines(l:bufnr, 0, line('$'), 0)

        if len(l:result) == 0
            return
        endif

        for formatter in a:000
            let l:result = systemlist(formatter . ' 2> /tmp/vim.log', l:result)
        endfor

        if len(l:result) == 0
            return
        endif

        let l:offset = len(l:result) - line('$')

        call nvim_buf_set_lines(l:bufnr, 0, line('$'), 0, l:result)

        call winrestview(l:view)

        if l:bufnr != bufnr()
            return
        endif

        call cursor(line('.') + l:offset, l:col)
    endfunction
