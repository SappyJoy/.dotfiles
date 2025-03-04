-- -- debug.lua
-- --
-- -- Shows how to use the DAP plugin to debug your code.
-- --
-- -- Primarily focused on configuring the debugger for Go, but can
-- -- be extended to other languages as well. That's why it's called
-- -- kickstart.nvim and not kitchen-sink.nvim ;)
--
-- return {
--   -- NOTE: Yes, you can install new plugins here!
--   'mfussenegger/nvim-dap',
--   -- NOTE: And you can specify dependencies as well
--   dependencies = {
--     -- Creates a beautiful debugger UI
--     'rcarriga/nvim-dap-ui',
--     'nvim-neotest/nvim-nio',
--
--     -- Installs the debug adapters for you
--     'williamboman/mason.nvim',
--     'jay-babu/mason-nvim-dap.nvim',
--
--     -- Add your own debuggers here
--     'leoluz/nvim-dap-go',
--   },
--   config = function()
--     local dap = require 'dap'
--     local dapui = require 'dapui'
--
--     require('mason-nvim-dap').setup {
--       -- Makes a best effort to setup the various debuggers with
--       -- reasonable debug configurations
--       automatic_setup = true,
--
--       -- You can provide additional configuration to the handlers,
--       -- see mason-nvim-dap README for more information
--       handlers = {},
--
--       -- You'll need to check that you have the required things installed
--       -- online, please don't ask me how to install them :)
--       ensure_installed = {
--         -- Update this to ensure that you have the debuggers for the langs you want
--         -- 'delve',
--       },
--     }
--
--     -- Basic debugging keymaps, feel free to change to your liking!
--     vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
--     vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
--     vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
--     vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
--     vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
--     vim.keymap.set('n', '<leader>B', function()
--       dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
--     end, { desc = 'Debug: Set Breakpoint' })
--
--     -- Dap UI setup
--     -- For more information, see |:help nvim-dap-ui|
--     dapui.setup {
--       -- Set icons to characters that are more likely to work in every terminal.
--       --    Feel free to remove or use ones that you like more! :)
--       --    Don't feel like these are good choices.
--       icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
--       controls = {
--         icons = {
--           pause = '⏸',
--           play = '▶',
--           step_into = '⏎',
--           step_over = '⏭',
--           step_out = '⏮',
--           step_back = 'b',
--           run_last = '▶▶',
--           terminate = '⏹',
--           disconnect = '⏏',
--         },
--       },
--     }
--
--     -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
--     vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
--
--     dap.listeners.after.event_initialized['dapui_config'] = dapui.open
--     dap.listeners.before.event_terminated['dapui_config'] = dapui.close
--     dap.listeners.before.event_exited['dapui_config'] = dapui.close
--
--     -- Install golang specific config
--     require('dap-go').setup()
--   end,
-- }

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'jbyuki/one-small-step-for-vimkind',
    },
    config = function()
      local dap = require 'dap'
      -- open dap automatically (auto close was missfiring, use <leader>.u to toggle ui)
      dap.listeners.after.event_initialized['dapui_config'] = function()
        require('dapui').open()
      end

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = 'Attach to running Neovim instance',
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
      end

      -- highlight groups for nvim dap icons
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'MoonflyRed' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { link = 'MoonflyCrimson' })
      vim.api.nvim_set_hl(0, 'DapStopped', { link = 'MoonflyEmerald' })

      vim.fn.sign_define('DapBreakpoint', { text = 'ඞ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    end,
    keys = {
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'toggle breakpoint',
      },
      {
        '<leader>B',
        function()
          vim.ui.input({ prompt = 'Conditional Breakpoint: ' }, function(input)
            require('dap').toggle_breakpoint(input)
          end)
        end,
      },
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'run the debugger, or run the code',
      },
      {
        '<F6>',
        function()
          require('dap').terminate()
        end,
        desc = 'terminate the debugger',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'step over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'step out',
      },
      {
        '<F10>',
        function()
          require('osv').launch { port = 8086 }
        end,
        desc = 'Launch osv nvim debugger',
      },
    },
  },
  { 'theHamsta/nvim-dap-virtual-text', config = true },
  {
    'jay-babu/mason-nvim-dap.nvim',
    opts = {
      -- This line is essential to making automatic installation work
      -- :exploding-brain
      handlers = {},
      automatic_installation = {
        -- These will be configured by separate plugins.
        exclude = {
          'delve',
          'python',
        },
      },
      -- DAP servers: Mason will be invoked to install these if necessary.
      ensure_installed = {
        'bash',
        'codelldb',
        'php',
        'python',
      },
    },
    dependencies = {
      'mfussenegger/nvim-dap',
      'williamboman/mason.nvim',
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'toggle the ui',
      },
    },
    config = function()
      require('dapui').setup {
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        layouts = {
          {
            elements = {
              'breakpoints',
              'stacks',
              'scopes',
            },
            size = 38, -- 40 columns
            position = 'left',
          },
          {
            elements = {
              'repl',
              'watches',
            },
            size = 0.24, -- 24% of total lines
            position = 'bottom',
          },
        },
        controls = {
          enabled = true,
          -- Display controls in this element
          element = 'repl',
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '↻',
            terminate = '',
          },
        },
      }
    end,
  },
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   config = function()
  --     require('dap-vscode-js').setup {
  --       -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --       debugger_path = os.getenv 'HOME' .. '/dev/microsoft/js-debug', -- Path to vscode-js-debug installation.
  --       -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --       adapters = { 'pwa-node' }, -- which adapters to register in nvim-dap
  --       -- other adapters that I'm not using right now: ` 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost'
  --     }
  --
  --     for _, language in ipairs { 'typescript', 'javascript' } do
  --       require('dap').configurations[language] = {
  --         {
  --           {
  --             type = 'pwa-node',
  --             request = 'launch',
  --             name = 'Debug Jest Tests',
  --             -- trace = true, -- include debugger info
  --             runtimeExecutable = 'node',
  --             runtimeArgs = {
  --               './node_modules/jest/bin/jest.js',
  --               '--runInBand',
  --             },
  --             rootPath = '${workspaceFolder}',
  --             cwd = '${workspaceFolder}',
  --             console = 'integratedTerminal',
  --             internalConsoleOptions = 'neverOpen',
  --           },
  --         },
  --       }
  --     end
  --   end,
  -- },
  {
    'mfussenegger/nvim-dap-python',
    lazy = true,
    config = function()
      local python = vim.fn.expand '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(python)
    end,
    -- Consider the mappings at
    -- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#mappings
    dependencies = {
      'mfussenegger/nvim-dap',
    },
  },
}
