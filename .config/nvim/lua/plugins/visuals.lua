return {
  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  -- { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  -- { 'folke/tokyonight.nvim', priority = 1000 },
  -- { 'morhetz/gruvbox', priority = 1000 },
  -- { 'EdenEast/nightfox.nvim', priority = 1000 },
  -- { 'sainnhe/gruvbox-material', priority = 1000 },
  -- { 'sainnhe/everforest', priority = 1000 },
  -- { 'nyoom-engineering/oxocarbon.nvim', priority = 1000 },
  -- { 'ribru17/bamboo.nvim', priority = 1000 },
  -- { 'rose-pine/neovim', priority = 1000 },
  -- { 'navarasu/onedark.nvim', priority = 1000 },
  -- { 'miikanissi/modus-themes.nvim', priority = 1000 },
  -- { 'binhtran432k/dracula.nvim', priority = 1000 },
  -- { 'mofiqul/vscode.nvim', priority = 1000 },
  -- { 'rmehri01/onenord.nvim', priority = 1000 },
  -- { 'cocopon/iceberg.vim', priority = 1000 },
  -- { 'sainnhe/edge', priority = 1000 },
  -- { 'sonph/onehalf', priority = 1000 },
  -- { 'rakr/vim-one', priority = 1000 },
  -- { 'ntbbloodbath/doom-one.nvim', priority = 1000 },
  -- { 'p00f/alabaster.nvim', priority = 1000 },
  -- { 'chriskempson/vim-tomorrow-theme', priority = 1000 },
  -- { 'olimorris/onedarkpro.nvim', priority = 1000 },
  -- { 'nlknguyen/papercolor-theme', priority = 1000 },
  -- { 'hzchirs/vim-material', priority = 1000 },
  -- { 'soft-aesthetic/soft-era-vim', priority = 1000 },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'Shatur/neovim-ayu',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'ayu-light'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'RRethy/vim-illuminate',
    lazy = false,
  },
}
