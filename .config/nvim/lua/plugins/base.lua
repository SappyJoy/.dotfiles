return {
  -- Undo Tree Visualization
  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        -- Chain commands: Toggle the undotree window AND focus it immediately
        '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>',
        desc = '[U]ndo Tree Toggle & Focus',
        silent = true,
        noremap = true, -- Good practice for custom mappings
      },
    },
    cmd = { 'UndotreeToggle', 'UndotreeFocus' }, -- Lazy load on command
  },

  -- Seamless Navigation between Neovim and Tmux Panes
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
      { '<c-h>', '<Cmd><C-U>TmuxNavigateLeft<CR>', desc = 'Tmux Nav Left' },
      { '<c-j>', '<Cmd><C-U>TmuxNavigateDown<CR>', desc = 'Tmux Nav Down' },
      { '<c-k>', '<Cmd><C-U>TmuxNavigateUp<CR>', desc = 'Tmux Nav Up' },
      { '<c-l>', '<Cmd><C-U>TmuxNavigateRight<CR>', desc = 'Tmux Nav Right' },
      { '<c-\\>', '<Cmd><C-U>TmuxNavigatePrevious<CR>', desc = 'Tmux Nav Previous' },
    },
  },

  -- Multiple Cursors / Selections Feature
  {
    'mg979/vim-visual-multi',
  },
}
