-- Load user-defined globals first
require 'sap.globals'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Core Configuration
require 'sap.options'
require 'sap.keymaps'
require 'sap.autocmds'

-- Associate .ets files with the 'typescript' filetype for syntax highlighting, LSP, etc.
vim.filetype.add {
  extension = {
    ets = 'typescript',
  },
}

-- Setup Lazy and load plugins from lua/plugins directory
require('lazy').setup({
  { import = 'plugins.ai' },
  { import = 'plugins.coding' },
  { import = 'plugins.editor' },
  { import = 'plugins.git' },
  { import = 'plugins.lang' },
  { import = 'plugins.lsp' },
  { import = 'plugins.ui' },
}, {
  -- Configure lazy.nvim installation options
  install = {
    -- Automatically install missing plugins on startup
    missing = true,
    -- Use 'ayu-light' colorscheme after installation (should be a string)
    colorscheme = { 'ayu-light' },
  },
  -- Configure change detection (automatically check for plugin updates)
  change_detection = {
    -- Disabling this can speed up startup time slightly,
    -- but you'll need to manually run :Lazy sync/update.
    enabled = false,
  },
  -- Configure the user interface of lazy.nvim (:Lazy)
  ui = {
    -- Use Nerd Font icons if available, otherwise fall back to basic symbols.
    -- `vim.g.have_nerd_font` should be set in your `sap.globals` or similar
    -- based on whether you have a Nerd Font installed and configured in your terminal.
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
