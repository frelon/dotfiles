if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'janko/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'psliwka/vim-smoothie'
Plug 'christoomey/vim-tmux-navigator'
Plug 'akarl/autoformat.nvim'
Plug 'leafgarland/typescript-vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/refactoring.nvim'

" Debug
Plug 'puremourning/vimspector'

call plug#end()

let g:test#go#gotest#options = '-race'

" Highlighted yank
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" Vimspector mappings
let g:vimspector_base_dir=expand( '$HOME/.config/vimspector' )
let g:vimspector_enable_mappings = 'HUMAN'

" Set makeprg for rust buffers to cargo-make
augroup rustmake
    autocmd!
    autocmd FileType rust set makeprg=cargo\ make
augroup END

" Align GitHub-flavored Markdown tables
au FileType markdown vmap <leader>f :EasyAlign*<Bar><Enter>

" Go
"
" Autoformat settings
" use bash as shell... TODO
set shell=/usr/bin/bash
call autoformat#config('go', ['goimports -local "$(go list -m)"', 'gofumpt -s -extra'])
autocmd! BufWritePre * :Autoformat

" Terminal
autocmd TermOpen * setlocal nonumber norelativenumber nocursorline

colorscheme nord
" Comments and italics
highlight Comment gui=italic

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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
    endif
endfunction

" Start debug session using vimspector on the current test.
function! DebugCurrentTest()
    let start_cursor_pos = getcurpos()
    let test_start_line = search('func Test', 'b')
    if test_start_line == 0
        echo "No test found"
        return
    endif

    let testname = split(getline(test_start_line)[5:], '(')[0]

    echo "Running " . testname
    call vimspector#LaunchWithSettings(#{configuration: "test", TestName: testname})

    call cursor(start_cursor_pos[1:])
endfunction

sign define LspDiagnosticsSignError text=🔴
sign define LspDiagnosticsSignWarning text=🟠
sign define LspDiagnosticsSignInformation text=🔵
sign define LspDiagnosticsSignHint text=🟢

lua require('lsp')
lua require('refactor')
lua require('settings')

