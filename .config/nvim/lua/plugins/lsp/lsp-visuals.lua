return {
  {
    'onsails/lspkind.nvim',
    opts = {},
  },
  {
    'hedyhli/outline.nvim',
    config = function(_, opts)
      require('outline').setup(opts)
      -- Keymap is defined in keys or handled by which-key group settings
      vim.keymap.set('n', '<leader>os', '<cmd>topleft Outline<cr>', { desc = 'Toggle [s]ymbols outline' })
    end,
    opts = {
      outline_window = {
        focus_on_open = false,
        width = 20,
        relative_width = true,
      },
    },
  },
  { -- this is really useful when there are a ton of diagnostics for different parts of a single line
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      local lspl = require 'lsp_lines'
      lspl.setup()
      lspl.toggle()

      local on = false
      vim.keymap.set('n', '<Leader>E', function()
        vim.diagnostic.config { virtual_text = on }
        on = not on
        lspl.toggle()
      end, { desc = 'Toggle lsp_lines' })
    end,
  },
}
