return {
  {
    'ggandor/leap.nvim',
    config = function(_, opts)
      local leap = require 'leap'

      -- Configure leap options if needed before setting mappings
      -- Example: make targets in visual selections work automatically
      -- leap.opts.safe_labels = {} -- Set to empty table to enable auto-labeling everywhere

      -- Set up the default mappings ('s', 'S')
      -- If you prefer custom mappings, define them manually using
      -- vim.keymap.set({'n', 'x', 'o'}, '<your_key>', '<Plug>(leap-forward-to)') etc.
      -- *instead* of calling add_default_mappings().
      leap.add_default_mappings()

      -- Add support for visual selections (optional, but recommended)
      -- This requires setting leap.opts.safe_labels = {} or configuring specific labels
      -- leap.add_visual_multiselect_mappings()

      -- Integrate with other plugins (optional examples)
      -- require('leap').add_repeat_mappings() -- Requires 'tpope/vim-repeat'

      -- Pass any top-level `opts` defined for the plugin spec
      -- (useful if you define `opts = { ... }` at the top level of this spec)
      -- leap.setup(opts)
    end,
    -- Optional dependencies:
    -- dependencies = {
    --   -- Improves repeating leap motions with '.'
    --   'tpope/vim-repeat',
    -- },
  },
}
