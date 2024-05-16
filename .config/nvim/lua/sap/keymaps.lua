--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-S>', '<cmd>w<CR>', { desc = 'Save' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll down half page', noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll up half page', noremap = true })
vim.keymap.set('n', '<leader>co', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Change all occurances' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move up' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent' })
vim.keymap.set('v', '<', '<gv', { desc = 'Indent' })
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Iron
vim.keymap.set('n', '<leader>is', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<leader>ir', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<leader>if', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<leader>ih', '<cmd>IronHide<cr>')

-- Gitsign
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require('gitsigns').next_hunk()
  end)
  return '<Ignore>'
end, { desc = 'Jump to next hunk' })

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require('gitsigns').prev_hunk()
  end)
  return '<Ignore>'
end, { desc = 'Jump to prev hunk' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next { float = { border = 'single' } }
end, { desc = 'Jump to next diagnostic' })

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev { float = { border = 'single' } }
end, { desc = 'Jump to prev diagnostic' })

vim.keymap.set('n', '<leader>rh', function()
  require('gitsigns').reset_hunk()
end, { desc = 'Reset hunk' })

vim.keymap.set('n', '<leader>ph', function()
  require('gitsigns').preview_hunk()
end, { desc = 'Preview hunk' })

vim.keymap.set('n', '<leader>td', function()
  require('gitsigns').toggle_deleted()
end, { desc = 'Toggle deleted' })

-- Telescope
vim.keymap.set('n', '<leader>sr', '<cmd> Telescope lsp_references <CR>', { desc = 'Search LSP references' })
vim.keymap.set('n', '<leader>ss', '<cmd> Telescope lsp_dynamic_workspace_symbols <CR>', { desc = 'Search dynamic workspace symbols' })
vim.keymap.set('n', '<leader>ss', '<cmd> Telescope lsp_dynamic_workspace_symbols <CR>', { desc = 'Search dynamic workspace symbols' })
