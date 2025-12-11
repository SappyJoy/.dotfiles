--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear Search Highlight' }) -- Added desc

vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', { desc = 'Quit' })

vim.keymap.set('n', '<C-t>', '<cmd>tabnew<CR>', { desc = 'New Tab' })

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

-- Toggle Virtual Text Diagnostics
vim.keymap.set('n', '<leader>E', function()
  local current_vt = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = not current_vt }
end, { desc = 'Toggle Virtual Text Diagnostics' })

vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode (keep commented if default <C-\><C-n> works)
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

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

-- Copy file path
vim.keymap.set('n', '<leader>cf', function()
  local file_path = vim.fn.expand('%')
  vim.fn.setreg('+', file_path)
  vim.notify("Copied file path to clipboard: " .. file_path)
end, { desc = 'Copy file path to clipboard' })
