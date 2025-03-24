vim.api.nvim_set_option('grepprg', "rg --vimgrep ")
vim.api.nvim_set_option('mouse', 'a')
vim.api.nvim_set_option('hlsearch', true)
vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('tabstop', 4)
vim.api.nvim_set_option('shiftwidth', 4)
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('signcolumn', 'yes')
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('swapfile', false)

-- Colors
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('cursorline', true)

-- KEYMAPPINGS
vim.g.mapleader=' '

local map = vim.api.nvim_set_keymap
map('n', '<Leader>w', ':write<CR>', {noremap = true})
map('n', '<Leader>q', ':quit<CR>', {noremap = true})
map("n", "<Leader>c", [[ <Esc><Cmd>:Telescope quickfix<CR>]], {noremap = true, silent = true, expr = false})

map('n', '<leader>v', ':vsplit $MYVIMRC<CR>', {noremap=true})
map('n', '<leader>b', ':Buffers<CR>', {noremap=true})
map('n', '<leader>gs', ':Git<CR>', {noremap=true})
map('n', '<leader>gb', ':Git blame<CR>', {noremap=true})
map('n', '<leader>gl', ':Gclog<CR>', {noremap=true})
map('n', '<leader>ga', ':Git add .<CR>', {noremap=true})
map('n', '<leader>gcc', ':Git commit<CR>', {noremap=true})
map('n', '<leader>gca', ':Git commit --amend --no-edit<CR>', {noremap=true})
map('n', '<leader>gpp', ':Git push<CR>', {noremap=true})
map('n', '<leader>gpf', ':Git push --force-with-lease<CR>', {noremap=true})
map('n', '<leader>rs', ':!rm .stamp/*<CR>', {noremap=true})
map('n', '<leader>ml', ':call GolangCILint()<CR>', {noremap=true})
map('n', '<leader>yp', ':let @+ = expand("%")<CR>', {noremap=true})
map('n', '<leader>tf', ':TestNearest -strategy=neovim -v<CR>', {noremap=true})
map('n', '<leader>tl', ':TestLast<CR>', {noremap=true})
map('n', '<leader>ts', ':TestSuite<CR>', {noremap=true})
map('n', '<leader>cov', ':Coverage<CR>', {noremap=true})
map('n', '<leader>gtc', ':!go test -coverprofile c.out ./...; go tool cover -html c.out && rm c.out<CR>', {noremap=true})

-- Format json
map('n', '<leader>fj', ':%!jq .<CR>', {noremap=true})

map('n', '<C-n>', ':cnext<CR>', {noremap=true})
map('n', '<C-p>', ':cprev<CR>', {noremap=true})

map('n', '<leader>s', ':vnew<CR>', {noremap=true})

map('', 'Y', 'y$', {noremap=true})

-- Telescope mappings
map('n', '<leader>o', '<cmd>Telescope find_files<cr>', {noremap=true})
map('n', '<leader>f', '<cmd>Telescope live_grep<cr>', {noremap=true})
map('n', '<leader>b', '<cmd>Telescope buffers<cr>', {noremap=true})
map('n', '<leader>h', '<cmd>Telescope help_tags<cr>', {noremap=true})


-- Auto format go files
vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.go",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !goimports -local (go list -m) -w %")
            vim.cmd("edit")
        end,
    }
)

vim.api.nvim_create_augroup("highlight_yank", {})
vim.api.nvim_create_autocmd(
    "TextYankPost",
    {
        pattern = "*",
        group = "highlight_yank",
        callback = function()
            vim.highlight.on_yank{higroup="IncSearch", timeout=700}
        end,
    }
)

