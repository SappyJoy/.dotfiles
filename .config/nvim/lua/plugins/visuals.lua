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
  {
    'luukvbaal/statuscol.nvim',
    -- cond = not MarkdownMode(),
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        -- configuration goes here, for example:
        relculright = true,
        segments = {
          {
            sign = { namespace = { 'gitsigns' }, name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true },
            click = 'v:lua.ScSa',
          },
          {
            sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.lnumfunc } },
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { enabled = false },
    },
  },
  {
    'lukas-reineke/headlines.nvim',
    -- enabled = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      -- Theses highlights turned out really bad.

      -- local function ser(c)
      --   local function h(n)
      --     return string.format("%02x", n)
      --   end
      --   return "#" .. h(c.r) .. h(c.g) .. h(c.b)
      -- end
      --
      -- local function de(color)
      --   return {
      --     r = tonumber(string.sub(color, 2, 3), 16),
      --     g = tonumber(string.sub(color, 4, 5), 16),
      --     b = tonumber(string.sub(color, 6, 6), 16),
      --   }
      -- end
      --
      -- local function darken(c, percent)
      --   return {
      --     r = c.r * (1 - percent),
      --     g = c.g * (1 - percent),
      --     b = c.b * (1 - percent),
      --   }
      -- end
      --
      -- local colors = require("moonfly").palette
      -- local highlights = {
      --   colors.crimson,
      --   colors.blue,
      --   colors.khaki,
      --   colors.orchid,
      --   colors.coral,
      --   colors.emerald,
      -- }
      --
      -- for i, color in ipairs(highlights) do
      --   local hl = "Headlines" .. i
      --   vim.api.nvim_set_hl(0, hl, { bg = ser(darken(de(color), 0.85)) })
      -- end

      local custom = {
        codeblock_highlight = false,
        dash_string = '━',
        -- headline_highlights = {
        --   "Headlines1",
        --   "Headlines2",
        --   "Headlines3",
        --   "Headlines4",
        --   "Headlines5",
        --   "Headlines6",
        -- },
      }
      local qmd = vim.tbl_deep_extend('force', custom, { treesitter_language = 'markdown' })
      -- local norg = vim.tbl_deep_extend('force', custom, {
      --   query = vim.treesitter.query.parse(
      --     'norg',
      --     [[
      --           [
      --               (heading1_prefix)
      --               (heading2_prefix)
      --           ] @headline
      --
      --           (weak_paragraph_delimiter) @dash
      --           (strong_paragraph_delimiter) @doubledash
      --
      --           ([(ranged_tag
      --               name: (tag_name) @_name
      --               (#eq? @_name "code")
      --           )
      --           (ranged_verbatim_tag
      --               name: (tag_name) @_name
      --               (#eq? @_name "code")
      --           )] @codeblock (#offset! @codeblock 0 0 1 0))
      --
      --           (quote1_prefix) @quote
      --       ]]
      --   ),
      -- })

      require('headlines').setup {
        markdown = custom,
        quarto = vim.tbl_deep_extend('force', require('headlines').config.markdown, qmd),
        -- norg = norg,
      }
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    opts = {
      '*';
    }
  },
}
