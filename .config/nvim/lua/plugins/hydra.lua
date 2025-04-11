-- Plugin for creating custom modal keymap layers (Hydras)
return {
  'nvimtools/hydra.nvim',
  event = 'VeryLazy',
  dependencies = {
      -- Nougat is used here specifically to refresh the statusline when entering/exiting a hydra
      'MunifTanjim/nougat.nvim'
  },
  config = function()
    -- Global Hydra configuration options
    require('hydra').setup {
      -- Configuration for the hint window that shows available keys
      hint = {
        -- Show hint in a floating window (alternatives: 'statusline', 'cmdline', 'virtual_text')
        type = 'window',
        -- Do not show the hydra's name in the hint title
        show_name = false,
        -- Position the hint window ('top', 'middle', 'bottom', or specific row/col)
        position = 'middle',
        -- Options passed directly to nvim_open_win for the float
        float_opts = {
          -- Use rounded borders for the hint window
          -- NOTE: 'Border' variable must be defined globally, e.g., in sap.globals
          -- Example definition: Border = "rounded" or Border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
          border = vim.g.Border or 'rounded', -- Use global Border or default to 'rounded'
        },
        -- offset = { 0, 0 }, -- Fine-tune position offset {row, col}
      },
      -- Function called when entering any hydra
      on_enter = function()
        -- Refresh the statusline (provided by nougat.nvim) to potentially show hydra state
        local nougat_ok, nougat = pcall(require, 'nougat')
        if nougat_ok then
          nougat.refresh_statusline(true)
        end
      end,
      -- Function called when exiting any hydra
      on_exit = function()
        -- Schedule the statusline refresh slightly later to ensure exit state is reflected
        vim.schedule(function()
          local nougat_ok, nougat = pcall(require, 'nougat')
          if nougat_ok then
            nougat.refresh_statusline(true)
          end
        end)
      end,
      -- Other global options:
      -- debug = false, -- Enable debug logging
      -- timeout = false, -- Global timeout for all hydras (ms or false)
    }

    -- Load user-defined hydra configurations from separate files
    -- Ensures modularity: each file defines one or more hydra heads.
    require 'sap.hydra.options' -- Assumes this file defines hydras related to options
    require 'sap.hydra.windows' -- Assumes this file defines hydras related to window management
  end,
}
