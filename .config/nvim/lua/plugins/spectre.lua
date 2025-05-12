return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup()
      -- Example keymaps:
      vim.keymap.set('n', '<leader>S', '<cmd>Spectre<CR>', { desc = 'Spectre: Open project search/replace' })
      -- To prefill with word under cursor:
      vim.keymap.set('n', '<leader>rw', function()
        require('spectre').open_visual { select_word = true }
      end, { desc = 'Spectre: Replace word under cursor project-wide' })
      -- To prefill with visual selection:
      vim.keymap.set('v', '<leader>s', function()
        -- Nvim-spectre automatically uses visual selection if available when opening.
        -- Or more explicitly:
        -- local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        -- vim.api.nvim_feedkeys(esc, "nx", false) -- Exit visual mode
        require('spectre').open_visual()
      end, { desc = 'Spectre: Replace visual selection project-wide' })
    end,
  },
}
