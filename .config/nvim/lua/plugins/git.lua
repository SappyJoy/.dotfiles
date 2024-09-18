return {
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '█' },
        change = { text = '█' },
        delete = { text = '█' },
        topdelete = { text = '▀' },
        changedelete = { text = '▒' },
        untracked = { text = '┆' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 10,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      -- current_line_blame_formatter_opts = {
      --   relative_time = false,
      -- },
      sign_priority = 6,
      update_debounce = 100,
    },
  },
  {
    'nvim-lua/plenary.nvim',
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
    config = function()
      require('telescope').load_extension 'lazygit'
    end,
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      -- Example mapping to toggle outline
      local wk = require 'which-key'
      wk.add {
        {
          { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
          { '<leader>df', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview Open File History' },
        },
        {
          mode = { 'n', 'v' },
          { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
        }
      }
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
    },
    config = true,
    keys = {
      { '<leader>gg', ':Neogit<cr>', desc = 'Neogit' },
      {
        '<leader>gf',
        function()
          require('neogit').action('log', 'log_current', { '--', vim.fn.expand '%' })()
        end,
        desc = 'Git log for file',
      },
      {
        '<leader>gf',
        function()
          local file = vim.fn.expand '%'
          vim.cmd [[execute "normal! \<ESC>"]]
          local line_start = vim.fn.getpos("'<")[2]
          local line_end = vim.fn.getpos("'>")[2]

          require('neogit').action('log', 'log_current', { '-L' .. line_start .. ',' .. line_end .. ':' .. file })()
        end,
        desc = 'Git log for this range',
        mode = 'v',
      },
    },
    -- config = function()
    --   require('neogit').setup {
    --     auto_refresh = false,
    --     console_timeout = 10000,
    --     disable_context_highlighting = true,
    --     disable_commit_confirmation = false,
    --     disable_builtin_notifications = true,
    --     disable_insert_on_commit = false,
    --     signs = {
    --       -- { CLOSED, OPENED }
    --       section = { '', '' },
    --       item = { '', '' },
    --       hunk = { '', '' },
    --     },
    --     commit_editor = {
    --       kind = 'vsplit',
    --       show_staged_diff = false,
    --     },
    --   }
    --
    --   -- require('helper').nnoremap('<Leader>gg', '<CMD>Neogit<CR>')
    --   local Color = require('neogit.lib.color').Color
    --   local colors = require 'ayu.colors'
    --   colors.generate(false) -- Pass `true` to enable mirage
    --
    --   local base_green = Color.from_hex '#99BF4D'
    --   local base_red = Color.from_hex '#F27983'
    --
    --   local green = base_green:to_css()
    --   local bg_green = base_green:shade(0):to_css()
    --   local line_green = base_green:shade(0):set_saturation(0.2):to_css()
    --
    --   local red = base_red:to_css()
    --   local bg_red = base_red:shade(0):to_css()
    --   local line_red = base_red:shade(0):set_saturation(0.4):to_css()
    --
    --   vim.api.nvim_set_hl(0, 'NeogitDiffAdd', {
    --     bg = line_green,
    --     fg = bg_green,
    --   })
    --
    --   vim.api.nvim_set_hl(0, 'NeogitDiffDelete', {
    --     bg = line_red,
    --     fg = bg_red,
    --   })
    --
    --   vim.api.nvim_set_hl(0, 'NeogitDiffAddHighlight', {
    --     bg = line_green,
    --     fg = green,
    --   })
    --
    --   vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', {
    --     bg = line_red,
    --     fg = red,
    --   })
    -- end,
    --   opts = {
    --     mappings = {
    --       popup = {
    --         ['F'] = 'PullPopup',
    --         ['p'] = false,
    --       },
    --       rebase_editor = {
    --         ['<c-d>'] = 'Abort',
    --         ['<c-c><c-k>'] = false,
    --       },
    --       commit_editor = {
    --         ['<c-d>'] = 'Abort',
    --         ['<c-c><c-k>'] = false,
    --       },
    --     },
    --     console_timeout = 3000,
    --     telescope_sorter = function()
    --       return require('telescope').extensions.fzf.native_fzf_sorter()
    --     end,
    --     fetch_after_checkout = true,
    --     auto_show_console = true,
    --     disable_hint = true,
    --     notification_icon = ' ',
    --     status = {
    --       show_head_commit_hash = false,
    --     },
    --     sections = {
    --       rebase = {
    --         folded = false,
    --       },
    --       recent = {
    --         folded = false,
    --       },
    --     },
    --   },
  },
}
