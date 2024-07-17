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
          { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
        },
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
