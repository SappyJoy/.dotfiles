require 'sap.globals'
require 'sap.keymaps'
require 'sap.lazy-bootstrap'

-- [[ Configure and install plugins ]]
local plugins = {
  { import = 'plugins.autocomplete' },
  { import = 'plugins.base' },
  { import = 'plugins.telescope' },
  { import = 'plugins.lsp' },
  { import = 'plugins.visuals' },
  { import = 'plugins.git' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.hydra' },
  { import = 'plugins.images' },
  { import = 'plugins.line' },
  { import = 'plugins.neorg' },
  { import = 'plugins.jupyter' },
  { import = 'plugins.oil' },
  { import = 'plugins.misc' },
}

require('lazy').setup(plugins, {
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { 'ayu-light' },
  },
  change_detection = {
    enabled = false,
  },
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
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
})

require 'sap'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
