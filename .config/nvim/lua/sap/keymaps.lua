--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear Search Highlight' }) -- Added desc

vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', { desc = 'Quit' })

-- Diagnostic keymaps
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next { float = { border = 'single' } }
end, { desc = 'Jump to next [D]iagnostic' })

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev { float = { border = 'single' } }
end, { desc = 'Jump to prev [D]iagnostic' })

vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float { border = 'single' }
end, { desc = 'Show diagnostic [E]rror messages' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics (Trouble)"})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics (Trouble)"})

-- Exit terminal mode (keep commented if default <C-\><C-n> works)
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Scroll centering
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down half page', noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up half page', noremap = true })

-- Replace word under cursor
vim.keymap.set('n', '<leader>co', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Change all occurrences (current word)' })
-- WARNING: This visual mode mapping uses register "h". Might conflict with other plugins or workflows.
vim.keymap.set('v', '<leader>co', [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><left>]], { desc = 'Change all occurrences (visual selection)' })

-- Visual mode improvements
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' }) -- Fixed desc
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' }) -- Fixed desc
vim.keymap.set('v', '>', '>gv', { desc = 'Indent line' }) -- Fixed desc
vim.keymap.set('v', '<', '<gv', { desc = 'Unindent line' }) -- Fixed desc

-- Yank highlight (autocommand moved to sap.autocmds or keep here)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Iron (keep commented if not used)
-- vim.keymap.set('n', '<leader>is', '<cmd>IronRepl<cr>')
-- vim.keymap.set('n', '<leader>ir', '<cmd>IronRestart<cr>')
-- vim.keymap.set('n', '<leader>if', '<cmd>IronFocus<cr>')
-- vim.keymap.set('n', '<leader>ih', '<cmd>IronHide<cr>')

-- Gitsigns
-- Use expr = true for conditional mapping based on vim.wo.diff
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() require('gitsigns').next_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = 'Jump to next hunk' })

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() require('gitsigns').prev_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = 'Jump to prev hunk' })
