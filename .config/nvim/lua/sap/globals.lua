-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Python Provider configuration (using dedicated conda env)
vim.g.python_host_prog = vim.fn.expand '$HOME' .. '/.conda/envs/nvim/bin/python'
vim.g.python3_host_prog = vim.fn.expand '$HOME' .. '/.conda/envs/nvim/bin/python3'

package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?.lua;'

-- Standard Global Border Definition
vim.g.Border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_node_provider = 0
