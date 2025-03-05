return {
  {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1,
    config = function()
      require('langmapper').setup {
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
    end,
  },
  { 'folke/zen-mode.nvim' },
  { 'folke/twilight.nvim' },
  -- { 'junegunn/goyo.vim' },
}
