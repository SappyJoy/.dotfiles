return {
  {
    'GeorgesAlkhouri/nvim-aider',
    cmd = { 'Aider', 'AiderOpen' },
    dependencies = {
      { 'folke/snacks.nvim', version = '>=2.24.0' },
      -- Optional integration: if you have neo-tree, this adds mappings
      'nvim-neo-tree/neo-tree.nvim',
    },
    keys = {
      { '<leader>a/', '<cmd>Aider toggle<cr>', desc = 'Toggle Aider' },
      { '<leader>as', '<cmd>Aider send<cr>', desc = 'Send to Aider', mode = { 'n', 'v' } },
      { '<leader>ac', '<cmd>Aider command<cr>', desc = 'Aider Commands' },
      { '<leader>ab', '<cmd>Aider buffer<cr>', desc = 'Send Buffer' },
      { '<leader>a+', '<cmd>Aider add<cr>', desc = 'Add File' },
      { '<leader>a-', '<cmd>Aider drop<cr>', desc = 'Drop File' },
      { '<leader>ar', '<cmd>Aider add readonly<cr>', desc = 'Add Read-Only' },
      { '<leader>aR', '<cmd>Aider reset<cr>', desc = 'Reset Session' },
    },
    opts = {
      aider_cmd = 'aider',
      args = {
        '--no-auto-commits',
        '--pretty',
      },
      auto_reload = true,
      theme = {
        user_input_color = '#86B300',       -- ayu string
        tool_output_color = '#399EE6',      -- ayu entity
        tool_error_color = '#E65050',       -- ayu error
        tool_warning_color = '#FA8D3E',     -- ayu warning
        assistant_output_color = '#A37ACC', -- ayu constant
        completion_menu_color = '#5C6166',  -- ayu fg
        completion_menu_bg_color = '#F3F4F5', -- ayu panel_bg
        completion_menu_current_color = '#5C6166', -- ayu fg
        completion_menu_current_bg_color = '#D3E1F5', -- ayu selection_bg
      },
      config = {
        os = { editPreset = 'nvim-remote' },
        gui = { nerdFontsVersion = '3' },
      },
      win = {
        wo = { winbar = 'Aider' },
        style = 'nvim_aider',
        position = 'right',
      },
    },
    config = function(_, opts)
      require('nvim_aider').setup(opts)
    end,
  },
}
