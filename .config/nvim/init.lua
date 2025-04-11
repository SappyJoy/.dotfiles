-- Load user-defined globals, keymaps, and lazy.nvim bootstrap first
require 'sap.globals'
require 'sap.lazy-bootstrap'

-- Associate .ets files with the 'typescript' filetype for syntax highlighting, LSP, etc.
vim.filetype.add {
  extension = {
    ets = 'typescript',
  },
}

-- Define plugin specifications by importing modular files.
-- Consider alphabetical order for easier navigation as the list grows.
local plugins = {
  { import = 'plugins.ai' },
  { import = 'plugins.autocomplete' },
  { import = 'plugins.base' },
  { import = 'plugins.dap' },
  { import = 'plugins.format' },
  { import = 'plugins.git' },
  { import = 'plugins.hydra' },
  { import = 'plugins.images' },
  { import = 'plugins.jupyter' },
  { import = 'plugins.line' },
  { import = 'plugins.lsp' },
  { import = 'plugins.misc' },
  { import = 'plugins.notes' },
  { import = 'plugins.oil' },
  { import = 'plugins.session' },
  { import = 'plugins.telescope' },
  { import = 'plugins.todoist' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.visuals' },
  { import = 'plugins.writing' },
}

require('lazy').setup(plugins, {
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

-- Load main user configuration
require 'sap'
