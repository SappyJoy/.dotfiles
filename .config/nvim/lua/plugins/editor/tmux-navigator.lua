return {
  {
    'christoomey/vim-tmux-navigator',
    -- Lazy load when one of the navigation commands is invoked
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    -- Define keybindings for navigation
    keys = {
      { '<c-m>', '<Cmd><C-U>TmuxNavigateLeft<CR>', desc = 'Tmux Nav Left' },
      { '<c-n>', '<Cmd><C-U>TmuxNavigateDown<CR>', desc = 'Tmux Nav Down' },
      { '<c-e>', '<Cmd><C-U>TmuxNavigateUp<CR>', desc = 'Tmux Nav Up' },
      { '<c-i>', '<Cmd><C-U>TmuxNavigateRight<CR>', desc = 'Tmux Nav Right' },
      { '<c-\\>', '<Cmd><C-U>TmuxNavigatePrevious<CR>', desc = 'Tmux Nav Previous' },
    },
    config = function()
      -- Add terminal-mode mappings to escape and navigate seamlessly
      vim.keymap.set('t', '<C-h>', [[<C-\><C-n><Cmd>TmuxNavigateLeft<CR>]])
      vim.keymap.set('t', '<C-j>', [[<C-\><C-n><Cmd>TmuxNavigateDown<CR>]])
      vim.keymap.set('t', '<C-k>', [[<C-\><C-n><Cmd>TmuxNavigateUp<CR>]])
      vim.keymap.set('t', '<C-l>', [[<C-\><C-n><Cmd>TmuxNavigateRight<CR>]])
      vim.keymap.set('t', '<C-\\>', [[<C-\><C-n><Cmd>TmuxNavigatePrevious<CR>]])
    end,
  },
}
