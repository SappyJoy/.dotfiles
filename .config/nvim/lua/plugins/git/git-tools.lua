return {
  {
    'kdheepak/lazygit.nvim',
    enabled = false,
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
      { '<leader>gl', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  -- Diffview: Enhanced Git Diff Viewer
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' }, -- Lazy load on commands
    dependencies = { 'nvim-lua/plenary.nvim', 'lewis6991/gitsigns.nvim' }, -- Gitsigns is optional but recommended
    keys = {
      { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = '[D]iff [O]pen (Changes)' },
      { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = '[D]iff [C]lose' },
      { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff File [H]istory' }, -- Changed from dr
      { '<leader>dH', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff Repo [H]istory' }, -- Added Repo History
      { '<leader>dm', '<cmd>DiffviewOpen master...<cr>', desc = '[D]iff Against [M]aster' }, -- Use '...' for range diff vs master
      -- Diff line history (uses Gitsigns backend if available)
      {
        '<leader>dl',
        function()
          local current_line = vim.fn.line '.'
          local file = vim.fn.expand '%'
          -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
          local cmd = string.format('DiffviewFileHistory --follow -L%s,%s:%s', current_line, current_line, file)
          vim.cmd(cmd)
        end,
        desc = '[D]iff [L]ine History',
      },
    },
    config = function()
      local wk = require 'which-key'
      wk.add {
        {
          mode = { 'v' },
          { '<leader>dl', "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = 'File History for visual selection' },
        },
      }
      require('diffview').setup {
        -- Configure Diffview options here, e.g., layout, keymaps within diffview
        -- keymaps = { ... }
        -- file_panel = { width = 35 },
        -- enhanced_diff_hl = true,
        -- Use gitsigns for hunk navigation if available
        use_icons = vim.g.have_nerd_font, -- Use icons if nerd fonts are available
        signs = { -- Use gitsigns setting by default
          fold_closed = '',
          fold_open = '',
          line_prefix = '│',
        },
      }
    end,
  },

  -- Neogit: Magit-like Git interface for Neovim
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim', -- Recommended for diff viewing integration
      'nvim-telescope/telescope.nvim', -- Optional for commit searching etc.
    },
    cmd = 'Neogit', -- Lazy load on command
    keys = {
      { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
      -- Git log for current file
      {
        '<leader>gfl',
        function()
          require('neogit').open { 'log', '--', vim.fn.expand '%' }
        end,
        desc = 'Neogit [F]ile [L]og',
      },
      -- Git log for selected lines in visual mode
      {
        '<leader>gl',
        function()
          local file = vim.fn.expand '%'
          -- Ensure we are out of visual mode before getting positions
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
          local line_start = vim.fn.getpos("'<")[2]
          local line_end = vim.fn.getpos("'>")[2]
          -- Use Neogit's action directly if available, otherwise construct command
          require('neogit').open { 'log', ('-L%d,%d:%s'):format(line_start, line_end, file) }
        end,
        desc = 'Neogit [L]ine Log (Visual)',
        mode = 'v',
      },
      -- Add other neogit actions/keymaps if needed
      {
        '<leader>gc',
        function()
          require('neogit').open { 'commit' }
        end,
        desc = 'Neogit [C]ommit',
      },
      {
        '<leader>gs',
        function()
          require('neogit').open()
        end,
        desc = 'Neogit [S]tatus',
      }, -- Same as gg
    },
    config = function()
      require('neogit').setup {
        -- Configure Neogit options here
        integrations = {
          -- Diffview integration is enabled by default if diffview is detected
          diffview = true,
        },
        -- kind = "tab", -- Open in a new tab instead of split
        -- signs = { ... } -- Customize signs
      }
    end,
  },
}
