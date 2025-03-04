require 'sap.globals'
require 'sap.keymaps'
require 'sap.lazy-bootstrap'

vim.filetype.add {
  extension = {
    ets = 'typescript',
  },
}

local plugins = {
  { import = 'plugins.autocomplete' },
  { import = 'plugins.base' },
  { import = 'plugins.telescope' },
  { import = 'plugins.lsp' },
  { import = 'plugins.ai' },
  { import = 'plugins.dap' },
  -- { import = 'plugins.interactive' },
  { import = 'plugins.visuals' },
  { import = 'plugins.git' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.images' },
  { import = 'plugins.line' },
  -- { import = 'plugins.neorg' },
  { import = 'plugins.jupyter' },
  { import = 'plugins.hydra' },
  { import = 'plugins.oil' },
  { import = 'plugins.notes' },
  { import = 'plugins.misc' },
  { import = 'plugins.writing' },
}

require('lazy').setup(plugins, {
  install = {
    missing = true,
    colorscheme = { 'ayu-light' },
  },
  change_detection = {
    enabled = false,
  },
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    -- icons = vim.g.have_nerd_font and {} or {
    --   cmd = '⌘',
    --   config = '🛠',
    --   event = '📅',
    --   ft = '📂',
    --   init = '⚙',
    --   keys = '🗝',
    --   plugin = '🔌',
    --   runtime = '💻',
    --   require = '🌙',
    --   source = '📄',
    --   start = '🚀',
    --   task = '📌',
    --   lazy = '💤 ',
    -- },
  },
})

require 'sap'
-- Mappings for russian language
require('langmapper').hack_get_keymap()
require('langmapper').automapping { global = true, buffer = true }

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
