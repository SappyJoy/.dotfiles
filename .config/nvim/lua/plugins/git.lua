return {
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' }, -- Load when opening a buffer
    opts = {
      -- Signs configuration (using block characters)
      signs = {
        add = { text = '█' },
        change = { text = '█' },
        delete = { text = '█' },
        topdelete = { text = '▀' },
        changedelete = { text = '▒' },
        untracked = { text = '┆' },
      },
      signcolumn = true, -- Always show the signcolumn
      numhl = false, -- Do not highlight the number column based on sign
      linehl = false, -- Do not highlight the whole line based on sign
      word_diff = false, -- Disable word diff highlighting within changed lines
      watch_gitdir = { -- Improve performance by watching the .git directory
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true, -- Show signs for untracked files
      -- Current line blame configuration
      current_line_blame = true, -- Enable virtual text blame for the current line
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- Show blame at the end of the line
        delay = 100, -- Delay before showing blame (ms) - increased slightly
        ignore_whitespace = false,
        virt_text_priority = 100, -- Rendering priority
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>', -- Blame format string
      sign_priority = 6,
      update_debounce = 100, -- Debounce time for updates (ms)
      status_formatter = nil, -- Use default status formatter for git status component integration (e.g., with statuslines)
      max_file_length = 40000, -- Disable for very large files (lines)
      preview_config = { -- Configuration for hunk preview window
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
    -- Define keymaps using the standard `keys` table for lazy-loading
    keys = {
      -- Hunk Navigation
      -- {
      --   ']h',
      --   function()
      --     require('gitsigns').next_hunk()
      --   end,
      --   mode = 'n',
      --   desc = 'Next Hunk',
      -- },
      -- {
      --   '[h',
      --   function()
      --     require('gitsigns').prev_hunk()
      --   end,
      --   mode = 'n',
      --   desc = 'Previous Hunk',
      -- },

      -- Hunk Actions
      {
        '<leader>hs',
        function()
          require('gitsigns').stage_hunk()
        end,
        mode = { 'n', 'v' },
        desc = 'Stage Hunk',
      },
      {
        '<leader>hr',
        function()
          require('gitsigns').reset_hunk()
        end,
        mode = { 'n', 'v' },
        desc = 'Reset Hunk',
      },
      {
        '<leader>hp',
        function()
          require('gitsigns').preview_hunk()
        end,
        mode = 'n',
        desc = 'Preview Hunk',
      },
      {
        '<leader>hb',
        function()
          require('gitsigns').blame_line { full = true }
        end,
        mode = 'n',
        desc = 'Blame Line',
      },
      {
        '<leader>hS',
        function()
          require('gitsigns').stage_buffer()
        end,
        mode = 'n',
        desc = 'Stage Buffer',
      },
      {
        '<leader>hR',
        function()
          require('gitsigns').reset_buffer()
        end,
        mode = 'n',
        desc = 'Reset Buffer',
      },
      -- Diffing
      {
        '<leader>hd',
        function()
          require('gitsigns').diffthis()
        end,
        mode = 'n',
        desc = 'Diff This',
      },
      {
        '<leader>hD',
        function()
          require('gitsigns').diffthis '~'
        end,
        mode = 'n',
        desc = 'Diff This ~',
      },
      -- Toggles
      {
        '<leader>td',
        function()
          require('gitsigns').toggle_deleted()
        end,
        mode = 'n',
        desc = '[T]oggle [D]eleted Signs',
      },
      {
        '<leader>tb',
        function()
          require('gitsigns').toggle_current_line_blame()
        end,
        mode = 'n',
        desc = '[T]oggle Line [B]lame',
      },
    },
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
      { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it [G]it (Neogit)' },
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
