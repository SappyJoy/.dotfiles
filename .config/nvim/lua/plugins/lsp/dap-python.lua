return {
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = { 'mfussenegger/nvim-dap', 'jay-babu/mason-nvim-dap.nvim' },
    config = function()
      local mason_registry = require 'mason-registry'
      if mason_registry.has_package('debugpy') then
          local python_debugger_path = mason_registry.get_package('debugpy'):get_install_path() .. '/venv/bin/python'
          require('dap-python').setup(python_debugger_path)
      end
    end,
  },
}
