return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Autocmd for LSP Attach (your existing code is good)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', function()
            require('telescope.builtin').lsp_references { show_line = false }
          end, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch Document [S]ymbols')
          map('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch [W]orkspace symbols')
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
      local lsp_servers = {
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
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        jdtls = {}, -- Ensure jdtls is installed via Mason if you use this
        pyright = {},
        clangd = {
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        },
        rust_analyzer = {
          settings = { diagnostics = { enable = true } },
        },
        -- xmlformatter = {}, -- xmlformatter is a formatter, not an LSP. Install with mason-tool-installer
        -- sqls = {},
        eslint = {}, -- For eslint LSP, ensure 'eslint_d' or 'eslint-lsp' is installed via Mason
        -- tsserver = {},
        kotlin_language_server = {},
        -- debugpy is a Debug Adapter, not an LSP. Install with mason-tool-installer or mason-nvim-dap.

        -- LaTeX LSPs
        texlab = {
          -- Example specific texlab settings (optional)
          settings = {
            texlab = {
              auxDirectory = './.aux', -- If you want aux files in a subdirectory
              bibtexFormatter = 'texlab', -- or "bibtex-tidy" if you configure it
              formatterLineLength = 80,
              forwardSearch = {
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
              },
            },
          },
        },
        ltex = {
          -- filetypes for nvim-lspconfig to activate ltex
          filetypes = { 'tex', 'latex', 'bib', 'markdown', 'gitcommit', 'text', 'rmd', 'org' },
          settings = {
            ltex = {
              -- Internal ltex setting for which "sub-languages" or types it processes
              -- This list is from your :LspInfo, seems to be a default from ltex-ls itself now
              enabled = {
                'bibtex',
                'gitcommit',
                'markdown',
                'org',
                'tex',
                'restructuredtext',
                'rsweave',
                'latex',
                'quarto',
                'rmd',
                'context',
                'html',
                'xhtml',
                'mail',
                'plaintext',
              },
              language = 'ru-RU', -- Or 'ru'
              diagnosticSeverity = 'information', -- Or 'warning' to make them more prominent
              sentenceCacheSize = 2000,
              additionalRules = {
                enablePickyRules = true,
                motherTongue = 'ru',
              },
              -- Use your more robust dynamic dictionary or the simple one for now
              -- dictionary = (function()
              --   local files = {}
              --   for _, file in ipairs(vim.api.nvim_get_runtime_file('dict/*', true)) do
              --     local lang = vim.fn.fnamemodify(file, ':t:r')
              --     if lang ~= '' then -- Ensure lang is not empty
              --       local fullpath = vim.fs.normalize(file) -- Use vim.fs.normalize
              --       if files[lang] then
              --         table.insert(files[lang], ':' .. fullpath)
              --       else
              --         files[lang] = { ':' .. fullpath }
              --       end
              --     end
              --   end
              --   if files.default then
              --     for lang, _ in pairs(files) do
              --       if lang ~= 'default' and files[lang] then
              --         vim.list_extend(files[lang], files.default)
              --       end
              --     end
              --     files.default = nil -- Remove default after merging
              --   end
              --   -- Ensure the target language dictionary exists, even if empty, if specified in 'language'
              --   if not files['ru-RU'] and not files['ru'] then
              --     files['ru-RU'] = {}
              --   end
              --   return files
              -- end)(),
              -- Or simpler for testing:
              dictionary = {
                ['ru-RU'] = { "LaTeX", "BibTeX", "терминXYZ" },
              },

              -- dictionary = (function()
              --   -- For dictionary, search for files in the runtime to have
              --   -- and include them as externals the format for them is
              --   -- dict/{LANG}.txt
              --   --
              --   -- Also add dict/default.txt to all of them
              --   local files = {}
              --   for _, file in ipairs(vim.api.nvim_get_runtime_file('dict/*', true)) do
              --     local lang = vim.fn.fnamemodify(file, ':t:r')
              --     local fullpath = vim.fs.normalize(file, ':p')
              --     files[lang] = { ':' .. fullpath }
              --   end
              --
              --   if files.default then
              --     for lang, _ in pairs(files) do
              --       if lang ~= 'default' then
              --         vim.list_extend(files[lang], files.default)
              --       end
              --     end
              --     files.default = nil
              --   end
              --   return files
              -- end)(),

              -- Potentially useful: If ltex-ls has trouble finding java or LT
              -- java = { path = "/path/to/your/java" }, -- If not on PATH or non-standard
              -- LanguageTool path might be configurable too, check ltex-ls docs
            },
          },
        },
        -- 'ltex_ls_plus' was an option, stick to 'ltex' (ltex-ls) for now unless you have a specific reason
      }

      -- Setup Mason
      require('mason').setup()

      -- Define ALL tools (LSPs, formatters, linters, DAPs) to be *ENSURED INSTALLED* by mason-tool-installer
      -- Use the EXACT package name as shown in :Mason
      local tools_to_ensure_installed = {
        -- 'tree-sitter-cli',

        -- LSPs (these will also be configured by mason-lspconfig)
        'lua-language-server', -- Mason name for lua_ls
        'jdtls',
        'pyright',
        'clangd',
        'rust-analyzer',
        'eslint-lsp', -- Or 'eslint_d' depending on your preference/setup for eslint
        -- 'typescript-language-server', -- Mason name for tsserver
        'kotlin-language-server',
        'texlab',
        'ltex-ls', -- Mason name for ltex LSP

        -- Formatters / Linters (non-LSP)
        'stylua',
        'sql-formatter',
        'prettier',
        'latexindent', -- LaTeX formatter
        'bibtex-tidy', -- BibTeX formatter
        'xmlformatter', -- XML formatter

        -- Debug Adapters (DAPs)
        'debugpy', -- Python DAP

        -- Add any other tools you want mason-tool-installer to manage
        -- 'vale', -- Prose linter (if you decide to use it later)
      }
      require('mason-tool-installer').setup {
        ensure_installed = tools_to_ensure_installed,
        -- You can add auto_update = true if you want tools to be updated automatically
        -- auto_update = false,
        -- run_on_start = true, -- if you want it to check and install on Neovim start
      }

      -- Setup mason-lspconfig to configure the LSPs from the 'lsp_servers' table
      require('mason-lspconfig').setup {
        handlers = {
          -- Default handler: sets up LSP with capabilities and server-specific settings
          function(server_name)
            local server_config = lsp_servers[server_name] or {}
            server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
            require('lspconfig')[server_name].setup(server_config)
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
