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
    commit = '19cb21f513fc2b02f0c66be70107741e837516a1',
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = { 'markdown', 'quarto' },
    config = function()
      local markdown_config = {
        dash_string = '━',
        fat_headlines = true,
      }

      require('headlines').setup {
        -- Apply the base config to standard markdown files
        markdown = markdown_config,

        -- Quarto files use markdown syntax, so apply the same settings.
        -- The `treesitter_language = "markdown"` ensures it uses the correct
        -- underlying parser and queries if the filetype is 'quarto'.
        quarto = vim.tbl_deep_extend('force', markdown_config, {
          treesitter_language = 'markdown',
        }),
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
