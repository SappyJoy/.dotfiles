return {
  {
    'Wansmer/langmapper.nvim',
    lazy = false, -- Load early for keymap wrapping
    priority = 1, -- Before which-key potentially
    config = function()
      local langmapper = require 'langmapper'
      langmapper.setup {
        -- Add this to prevent continuous layout checks
        check_layout_interval = 0, -- Disable periodic checks
        os = {
          Linux = {
            get_current_layout_id = function()
              -- Cache the layout result
              local cached_layout = vim.g.langmapper_cached_layout
              if not cached_layout then
                local output = vim.split(vim.trim(vim.fn.system 'xkb-switch'), '\n')
                cached_layout = output[#output]
                vim.g.langmapper_cached_layout = cached_layout
              end
              return cached_layout
            end,
          },
        },
      }
      langmapper.hack_get_keymap() -- Needed for which-key wrapping etc.

      -- Configure automapping here after setup
      require('langmapper').automapping { global = true, buffer = true }
    end,
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode', -- Lazy load on command
    dependencies = {
      -- Twilight is needed for the hooks to work
      'folke/twilight.nvim',
    },
    opts = {
      window = {
        -- width = 0.85, -- Adjust width as needed (percentage)
        options = {
          -- Default zen-mode options:
          -- signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- Configure which plugins zen-mode should interact with
        options = {
          enabled = true,
          ruler = false, -- Turn off vim.o.ruler
          showcmd = false, -- Turn off vim.o.showcmd
          -- laststatus = 0, -- Turn off vim.o.laststatus
        },
        -- twilight = { enabled = true }, -- Automatically handle twilight? Set to true
        -- We'll use hooks for more explicit control below, so keep this false or remove
        twilight = { enabled = false },

        -- Add other plugins if needed, e.g., disabling gitsigns temporarily
        -- gitsigns = { enabled = false }, -- Hides gitsigns statuscol components
      },
      -- Hooks for explicit Twilight control (Recommended over built-in twilight option)
      on_open = function(win)
        -- Enable Twilight when ZenMode opens
        -- Also, you might want to force wrap on for writing
        vim.wo[win].wrap = true
        local ok, twilight = pcall(require, 'twilight')
        if ok then
          twilight.enable()
        else
          vim.notify('Twilight plugin not available', vim.log.levels.WARN)
        end
      end,
      on_close = function()
        -- Disable Twilight when ZenMode closes
        -- Revert wrap setting if desired (or leave it)
        local ok, twilight = pcall(require, 'twilight')
        if ok then
          twilight.disable()
        else
          vim.notify('Twilight plugin not available', vim.log.levels.WARN)
        end
      end,
    },
  },
  {
    'folke/twilight.nvim',
    cmd = 'Twilight', -- Lazy load on command
    opts = {
      -- Default configuration:
      -- dimming = {
      --   alpha = 0.25, -- amount of dimming
      --   color = { "Normal", "#ffffff" },
      --   term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
      --   inactive = false, -- when true, other windows will be fully dimmed (unless they match excluded filetypes)
      -- },
      -- context = 10, -- amount of lines we will try to show around the current line
      -- treesitter = true, -- use treesitter when available for context detection
      -- exclude = {}, -- exclude these filetypes
    },
  },
}
