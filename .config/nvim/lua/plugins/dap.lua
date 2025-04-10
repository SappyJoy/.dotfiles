return {
  -- Debug Adapter Protocol Core Implementation
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Required for the Lua debug adapter (nlua)
      'jbyuki/one-small-step-for-vimkind', -- Provides the nlua debug adapter
      -- UI for DAP
      'rcarriga/nvim-dap-ui',
      -- Virtual text for DAP info
      'theHamsta/nvim-dap-virtual-text',
      -- Mason integration for managing adapters
      'jay-babu/mason-nvim-dap.nvim',
    },
    -- Define keybindings for core DAP actions
    keys = {
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<leader>B', function()
          local dap = require 'dap'
          -- Use vim.ui.input for conditional breakpoint input
          vim.ui.input({ prompt = 'Breakpoint Condition: ' }, function(condition)
            if condition and condition ~= '' then
              dap.toggle_breakpoint(condition)
            else
              dap.toggle_breakpoint() -- Toggle regular breakpoint if input is empty
            end
          end)
        end, desc = 'Toggle Conditional Breakpoint' },
      { '<F1>', function() require('dap').step_into() end, desc = 'Debug Step Into' },
      { '<F2>', function() require('dap').step_over() end, desc = 'Debug Step Over' },
      { '<F3>', function() require('dap').step_out() end, desc = 'Debug Step Out' },
      { '<F5>', function() require('dap').continue() end, desc = 'Debug Continue' },
      { '<F6>', function() require('dap').terminate() end, desc = 'Debug Terminate' },
      { '<F10>', function() require('osv').launch { port = 8086 } end, desc = 'Launch OSV Nvim Debugger' }, -- OSV for debugging Neovim itself
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui' -- Require dapui here for setup

      -- Automatically open DAP UI when a debug session starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      -- Automatically close DAP UI when a debug session ends
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Define the Lua Debug Adapter ('nlua') provided by one-small-step-for-vimkind
      dap.adapters.nlua = function(callback, config)
        -- This function tells DAP how to connect to the nlua debug server
        callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
      end

      -- Define DAP configuration for Lua files (using the 'nlua' adapter)
      dap.configurations.lua = {
        {
          type = 'nlua', -- Use the adapter defined above
          request = 'attach', -- Attach to a running process
          name = 'Attach to running Neovim instance',
          -- host and port can be overridden here if needed, otherwise defaults from adapter function are used
        },
        -- Add 'launch' configurations here if needed
      }

      -- Custom DAP signs (requires Nerd Font)
      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '❓', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '🪵', texthl = 'DiagnosticInfo', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DiagnosticHint', linehl = 'Visual', numhl = '' }) -- Use Visual for line highlight

      -- Custom DAP highlights (linking to theme colors - ensure these hl groups exist in your colorscheme)
      -- You might need to adjust these links based on 'ayu-light' or create custom highlights
      -- vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'MoonflyRed' }) -- Example link
      -- vim.api.nvim_set_hl(0, 'DapLogPoint', { link = 'MoonflyCrimson' }) -- Example link
      -- vim.api.nvim_set_hl(0, 'DapStopped', { link = 'MoonflyEmerald' }) -- Example link

      -- Setup DAP UI (moved from dapui plugin spec for better cohesion)
      dapui.setup {
        -- Customize UI element mappings
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        -- Define UI layout (elements on left, repl/watches at bottom)
        layouts = {
          { elements = { 'breakpoints', 'stacks', 'scopes' }, size = 0.30, position = 'left' }, -- Give size proportion
          { elements = { 'repl', 'watches' }, size = 0.25, position = 'bottom' }, -- Give size proportion
        },
        -- Configure floating window behavior (if used)
        floating = {
          max_height = nil, -- Use default
          max_width = nil, -- Use default
          border = 'rounded', -- Use rounded borders for float
          mappings = { close = { 'q', '<Esc>' } },
        },
        -- Enable controls in the REPL element (requires Nerd Font icons)
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            pause = '',
            play = '',
            step_into = '󰆹', -- Updated icon
            step_over = '󰆷', -- Updated icon
            step_out = '󰆸', -- Updated icon
            step_back = '󰮏', -- Updated icon
            run_last = '↻',
            terminate = '󰓙', -- Updated icon
          },
        },
        -- Enable virtual text display (moved from nvim-dap-virtual-text spec)
        render = {
          max_value_lines = 100, -- Max lines for variable value display
          indent = 1, -- Indentation level for hierarchies
        },
      }

      -- Setup virtual text (moved from nvim-dap-virtual-text spec)
      require('nvim-dap-virtual-text').setup {
        enabled = true, -- Ensure it's enabled
        enabled_commands = true, -- Enable commands like :DapVirtualTextToggle
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false, -- Display info uncommented
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false, -- Keep virtual text when continuing
        -- Customize display options
        display_options = {
          colorscheme = "dark", -- Adjust if needed for ayu-light
          variable = 'fg=DiagnosticInfo', -- Example highlight group
          reference = 'fg=DiagnosticHint', -- Example highlight group
          current_reference = 'fg=DiagnosticWarn', -- Example highlight group
        }
      }
    end,
  },

  -- UI for DAP - Configuration moved into nvim-dap's config function
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    -- Define keybinding for toggling the UI
    keys = {
      { '<F7>', function() require('dapui').toggle() end, desc = 'Toggle Debug UI' },
    },
    -- Config is now handled within nvim-dap's config for better initialization order
  },

  -- Virtual Text for DAP - Configuration moved into nvim-dap's config function
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    -- Config is now handled within nvim-dap's config
  },

  -- Mason Integration for DAP Adapters
  {
    'jay-babu/mason-nvim-dap.nvim',
    -- Load after nvim-dap and mason
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    -- Trigger lazy-loading when a DAP command is used
    cmd = {
      'DapContinue', 'DapToggleBreakpoint', 'DapStepInto', 'DapStepOver',
      'DapStepOut', 'DapTerminate', 'DapInstall', 'DapUninstall'
    },
    opts = {
      -- Ensure specific adapters are installed automatically by mason-nvim-dap
      ensure_installed = {
        'bash-debug-adapter', -- Installs bashdb
        'codelldb', -- LLDB adapter (for C++, Rust, etc.)
        'debugpy', -- Python adapter
        -- Add other adapters you use, e.g.: 'node-debug2-adapter', 'java-debug-adapter', 'php-debug-adapter'
      },
      -- Define handlers for specific adapters if needed (e.g., custom setup)
      handlers = {
        -- Example: Custom setup for python using the installed debugpy path
        ['python'] = function(config)
          local mason_registry = require 'mason-registry'
          local debugpy_path = mason_registry.get_package('debugpy'):get_install_path()
          config.adapters.python = {
            type = 'executable',
            command = debugpy_path .. '/venv/bin/python', -- Path to venv python within mason package
            args = { '-m', 'debugpy.adapter' },
          }
          -- No need to call dap.configurations.python = { ... } here,
          -- nvim-dap-python plugin (below) should handle that.
        end,
        -- Add handlers for other adapters if complex setup is required
      },
      -- Automatic installation settings (optional)
      -- automatic_installation = {
      --   exclude = {}, -- List adapters NOT to install automatically if detected
      -- },
      -- automatic_setup = true, -- Automatically calls dap.adapters.* and dap.configurations.*
    },
  },

  -- Python specific DAP configuration using debugpy
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python', -- Load when a python file is opened
    dependencies = { 'mfussenegger/nvim-dap', 'jay-babu/mason-nvim-dap.nvim' },
    config = function()
      -- The path setup is now handled by mason-nvim-dap's handler
      -- We just need to tell nvim-dap-python where to find the debugpy launcher.
      -- It often figures this out automatically if 'debugpy' is in the path
      -- or configured correctly by mason-nvim-dap.
      local mason_registry = require 'mason-registry'
      -- Ensure debugpy is installed before getting the path
      if mason_registry.has_package('debugpy') then
          local python_debugger_path = mason_registry.get_package('debugpy'):get_install_path() .. '/venv/bin/python'
          -- The setup function typically configures dap.configurations.python
          require('dap-python').setup(python_debugger_path)
          -- print("nvim-dap-python setup completed using: " .. python_debugger_path)
      else
          -- vim.notify("nvim-dap-python: 'debugpy' not found via Mason. Please install it.", vim.log.levels.WARN)
      end
      -- You can add custom python launch configurations here if needed, e.g.,
      -- require('dap-python').test_runner = 'pytest'
      -- require('dap').configurations.python = vim.tbl_deep_extend('force', require('dap').configurations.python or {}, {
      --   {
      --     type = 'python', -- Automatically managed by dap-python after setup
      --     request = 'launch',
      --     name = "Launch file with args",
      --     program = "${file}",
      --     args = function() return vim.fn.input('Arguments: ') end, -- Prompt for args
      --   }
      -- })
    end,
  },
}
