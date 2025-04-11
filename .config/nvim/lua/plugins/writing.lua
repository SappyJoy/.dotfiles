return {
  {
    'Wansmer/langmapper.nvim',
    lazy = false, -- Load early for keymap wrapping
    priority = 1, -- Before which-key potentially
    config = function()
      local langmapper = require('langmapper')
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
    opts = {
      -- Configure zen-mode options if needed
    },
  },
  {
    'folke/twilight.nvim',
    cmd = 'Twilight', -- Lazy load on command
    opts = {
      -- Configure twilight options if needed
    },
  },
  -- { 'junegunn/goyo.vim' },
}
