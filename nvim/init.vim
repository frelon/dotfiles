if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --- Plugins ---

call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'janko/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'machakann/vim-highlightedyank'
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

" --- Keybindings ---

let mapleader = ' '
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>v :vsplit $MYVIMRC<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gl :Gclog<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gcc :Gcommit -m ""<Left>
nnoremap <leader>gco :Git checkout -b 
nnoremap <leader>gca :Git commit --amend --no-edit<CR><CR>
nnoremap <leader>gpp :Git push<CR>
nnoremap <leader>gpf :Git push --force-with-lease<CR>
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

nnoremap <leader>s :vnew<CR>

map Y y$

nnoremap <C-j> :m +1<CR>
nnoremap <C-k> :m -2<CR>

" Telescope mappings
nnoremap <leader>o <cmd>Telescope find_files<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

" Vimspector mappings
let g:vimspector_base_dir=expand( '$HOME/.config/vimspector' )
let g:vimspector_enable_mappings = 'HUMAN'

nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dt :call DebugCurrentTest()<CR>
nnoremap <leader>dd :call vimspector#Continue()<CR>
nnoremap <leader>dcb :call vimspector#ClearBreakpoints()<CR>
nnoremap <leader>dr :call vimspector#Reset()<CR>
nnoremap <leader>dj :call vimspector#StepOver()<CR>
nnoremap <leader>dl :call vimspector#StepInto()<CR>
nnoremap <leader>dk :call vimspector#StepOut()<CR>

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
set number
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set signcolumn=yes
set ignorecase
set noswapfile

" Colors
set termguicolors
set cursorline
colorscheme simple-dark

" Comments and italics
highlight Comment gui=italic

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Colorizer
lua require'colorizer'.setup()

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

" Default config from https://github.com/neovim/nvim-lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls","rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
  }
end

local nvim_refactor = require('config')

EOF
