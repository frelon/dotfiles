


" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sebdah/vim-delve'

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-highlightedyank'

call plug#end()

" --- Keybindings ---

let mapleader = ' '
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <leader>v :vsplit $MYVIMRC<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>h :Helptags<CR>

" Autosource $MYVIMRC
autocmd bufwritepost init.vim source $MYVIMRC

" Fold

" augroup folding
"   au BufReadPre *.go setlocal foldmethod=indent
" augroup END

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Coc

" format selection
nmap <leader>f  <Plug>(coc-format-selected)
xmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command to organize imports 
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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

    autocmd! BufWritePre *.go call s:autoformat()
augroup END

function s:autoformat()
    call CocAction("format")
    call CocAction('runCommand', 'editor.action.organizeImport')
endfunction

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
set hidden
set mouse=a
set nohlsearch
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

" Cursor
set cursorline
highlight CursorLineNr cterm=NONE ctermbg=236 ctermfg=8 gui=NONE guibg=NONE guifg=NONE
highlight CursorLine cterm=NONE ctermbg=236 ctermfg=NONE gui=NONE guibg=NONE guifg=NONE

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


