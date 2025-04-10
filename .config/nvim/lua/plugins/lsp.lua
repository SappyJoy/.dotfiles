return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', function()
            require('telescope.builtin').lsp_references {
              show_line = false,
            }
          end, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local home = os.getenv 'HOME'
      local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = workspace_path .. project_name
      local servers = {
        -- gopls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        jdtls = {},
        pyright = {},
        clangd = {
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        },
        rust_analyzer = {
          settings = {
            diagnostics = {
              enable = true,
            },
          },
        },
        xmlformatter = {},
        -- sqls = {},
        -- ltex = {
        --   use_spellfile = false,
        --   filetypes = { 'latex', 'tex', 'bib', 'markdown', 'gitcommit', 'text' },
        --   flags = { debounce_text_changes = 300 },
        --   settings = {
        --     ltex = {
        --       enabled = { 'latex', 'tex', 'bib', 'markdown' },
        --       language = 'ru',
        --       diagnosticSeverity = 'information',
        --       sentenceCacheSize = 2000,
        --       additionalRules = {
        --         enablePickyRules = true,
        --         motherTongue = 'ru',
        --       },
        --       dictionary = (function()
        --         -- For dictionary, search for files in the runtime to have
        --         -- and include them as externals the format for them is
        --         -- dict/{LANG}.txt
        --         --
        --         -- Also add dict/default.txt to all of them
        --         local files = {}
        --         for _, file in ipairs(vim.api.nvim_get_runtime_file('dict/*', true)) do
        --           local lang = vim.fn.fnamemodify(file, ':t:r')
        --           local fullpath = vim.fs.normalize(file, ':p')
        --           files[lang] = { ':' .. fullpath }
        --         end
        --
        --         if files.default then
        --           for lang, _ in pairs(files) do
        --             if lang ~= 'default' then
        --               vim.list_extend(files[lang], files.default)
        --             end
        --           end
        --           files.default = nil
        --         end
        --         return files
        --       end)(),
        --     },
        --   },
        -- },
        -- tsserver = {},
        eslint_d = {},
        eslint = {},
        ts_ls = {},
        kotlin_language_server = {},
      }

      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
        'sql-formatter',
        'prettier',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
          ['jdtls'] = function() end,
        },
      }
    end,
  },
  {
    'onsails/lspkind.nvim',
    opts = {},
  },
  { 'mfussenegger/nvim-jdtls' },
  -- { 'simrat39/symbols-outline.nvim',
  --   config = function ()
  --     require('symbols-outline').setup({})
  --     local wk = require 'which-key'
  --     wk.register {
  --       ['<leader>o'] = {
  --         name = '[O]pen',
  --         s = { '<cmd>SymbolsOutline<cr>', 'Toggle [s]ymbols outline' }
  --     }
  --     }
  --   end
  -- },
  {
    'ariedov/android-nvim',
    config = function()
      -- OPTIONAL: specify android sdk directory
      vim.g.android_sdk = '~/Android/Sdk'
      require('android-nvim').setup()
    end,
  },
  {
    'hedyhli/outline.nvim',
    config = function(_, opts)
      require('outline').setup(opts)
      local wk = require 'which-key'
      wk.add {
        {
          { '<leader>o', group = '[O]pen' },
          { '<leader>os', '<cmd>topleft Outline<cr>', desc = 'Toggle [s]ymbols outline' },
        },
      }
    end,
    opts = {
      outline_window = {
        focus_on_open = false,
        width = 20,
        relative_width = true,
      },
    },
  },
  -- {
  --   'stevearc/aerial.nvim',
  --   -- Optional dependencies
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   config = function()
  --     local wk = require 'which-key'
  --     wk.register {
  --       ['<leader>o'] = {
  --         name = '[O]pen',
  --         s = { '<cmd>AerialToggle!<cr>', 'Toggle [s]ymbols outline' },
  --       },
  --     }
  --
  --     require('aerial').setup {
  --       -- Your setup opts here (leave empty to use defaults)
  --     }
  --   end,
  -- },
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
