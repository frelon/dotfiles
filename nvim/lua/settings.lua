vim.api.nvim_set_option('grepprg', "rg --vimgrep ")
vim.api.nvim_set_option('mouse', 'a')
vim.api.nvim_set_option('hlsearch', true)
vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('tabstop', 4)
vim.api.nvim_set_option('shiftwidth', 4)
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('t_Co', '256')
vim.api.nvim_set_option('signcolumn', 'yes')
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('swapfile', false)

-- set termguicolors
-- set cursorline
-- colorscheme simple-dark

vim.api.nvim_set_keymap("n", "<Leader>c", [[ <Esc><Cmd>:Telescope quickfix<CR>]], {noremap = true, silent = true, expr = false})

