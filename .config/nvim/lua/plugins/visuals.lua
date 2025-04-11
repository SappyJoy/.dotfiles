return {
  { -- which-key setup
    'folke/which-key.nvim',
    event = 'VimEnter',
    dependencies = {
      'Wansmer/langmapper.nvim', -- Ensure langmapper is loaded first
    },
    config = function()
      -- Wait for langmapper to potentially finish its setup if needed
      vim.schedule(function()
        pcall(function() -- Wrap in pcall in case langmapper isn't fully ready
          local lmu = require 'langmapper.utils'
          local view = require 'which-key.view'
          local execute = view.execute

          -- Wrap `execute()` to translate sequence back for non-EN layouts
          view.execute = function(prefix_i, mode, buf)
            -- Translate back to English characters if needed
            prefix_i = lmu.translate_keycode(prefix_i, 'default', 'ru') -- Adapt 'ru' if needed
            execute(prefix_i, mode, buf)
          end
        end)

        require('which-key').setup {
          -- Add any which-key specific options here
          -- e.g., window options, triggers, etc.
        }

        -- Document existing key chains (add more as you define them)
        require('which-key').add {
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>g', group = '[G]it' },
          { '<leader>h', group = '[H]unk (GitSigns)' }, -- Map group for gitsigns actions
          { '<leader>o', group = '[O]ptions' }, -- Map group for hydra/oil actions
          { '<leader>r', group = '[R]ename/[R]epl' },
          { '<leader>f', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          -- Hide placeholders for missing keys within groups
          { '<leader>c_', hidden = true },
          { '<leader>d_', hidden = true },
          { '<leader>f_', hidden = true },
          { '<leader>g_', hidden = true },
          -- ... and so on
        }
      end)
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

  {
    'Shatur/neovim-ayu',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      vim.cmd.colorscheme 'ayu-light'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' }, -- Load when a buffer is ready
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false, -- Keep your preference
      -- keywords = { ... } -- Customize keywords if needed
    },
  },
  {
    'RRethy/vim-illuminate',
    lazy = false,
  },
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPost', 'BufNewFile' }, -- Can be lazy-loaded
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        relculright = true,
        segments = {
          -- GitSigns
          {
            sign = { namespace = { 'gitsigns' }, name = { '.*' }, maxwidth = 1, colwidth = 1, auto = true }, -- Adjusted maxwidth
            click = 'v:lua.ScSa', -- Or use gitsigns actions directly?
          },
          -- Diagnostics (use icons?)
          {
            sign = { name = { 'Diagnostic' }, maxwidth = 1, colwidth = 1, auto = true }, -- Adjusted maxwidth
            click = 'v:lua.ScSa', -- Or use diagnostic actions?
          },
          -- Line Number
          { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' }, -- Added click action
          -- Fold Column
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
        -- markdown = custim,
        quarto = vim.tbl_deep_extend('force', require('headlines').config.markdown, qmd),
        -- norg = norg,
      }
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' }, -- Can be lazy-loaded
    config = function()
      require('colorizer').setup {
        '*', -- Highlight all filetypes
        -- Or specify filetypes: { 'css', 'javascript', 'lua' }
        user_default_options = {
          RGB = true, -- Enable RGB display
          RRGGBB = true, -- Enable RRGGBB display
          names = false, -- Disable color names
          tailwind = true, -- Enable tailwindcss colors
          sass = { enable = true, parsers = { 'css' } }, -- Enable sass colors
          css = true, -- Enable নিঃসcss colors
          mode = 'background', -- Highlight the background
        },
      }
    end,
  },
}
