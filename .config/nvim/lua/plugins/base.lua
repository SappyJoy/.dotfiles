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
        config = function()
            -- Add terminal-mode mappings to escape and navigate seamlessly
            vim.keymap.set('t', '<C-h>', [[<C-\><C-n><Cmd>TmuxNavigateLeft<CR>]])
            vim.keymap.set('t', '<C-j>', [[<C-\><C-n><Cmd>TmuxNavigateDown<CR>]])
            vim.keymap.set('t', '<C-k>', [[<C-\><C-n><Cmd>TmuxNavigateUp<CR>]])
            vim.keymap.set('t', '<C-l>', [[<C-\><C-n><Cmd>TmuxNavigateRight<CR>]])
            vim.keymap.set('t', '<C-\\>', [[<C-\><C-n><Cmd>TmuxNavigatePrevious<CR>]])
        end,
    },

    -- Multiple Cursors / Selections Feature
    {
        'mg979/vim-visual-multi',
    },
}
