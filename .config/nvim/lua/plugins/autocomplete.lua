return {
  -- Autocompletion Engine
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- Load when entering insert mode
    dependencies = {
      -- Snippet Engine & Source
      {
        'L3MON4D3/LuaSnip',
        -- Ensure jsregexp is built for enhanced snippet features (if make is available)
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- Optional: Load friendly snippets collection
          -- 'rafamadriz/friendly-snippets',
        },
        -- Config moved to its own plugin spec below for clarity
      },
      'saadparwaiz1/cmp_luasnip', -- Luasnip integration for nvim-cmp

      -- Other completion sources
      'hrsh7th/cmp-nvim-lsp', -- LSP suggestions
      'hrsh7th/cmp-path', -- File system paths
      'hrsh7th/cmp-buffer', -- Suggestions from current buffer words
      {
        'petertriho/cmp-git', -- Suggestions from git commits
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {}, -- Configure cmp-git options here if needed
      },
      {
        'zbirenbaum/copilot-cmp', -- Copilot suggestions (Source)
        config = function()
          -- Basic setup, can add options here if needed
          require('copilot_cmp').setup()
        end,
      },
      -- Note: Codeium source is implicitly added if codeium.nvim is enabled and configured
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      -- `copilot_cmp` setup is handled in its own plugin spec dependency now

      -- Load friendly snippets if installed (example)
      -- require("luasnip.loaders.from_vscode").lazy_load()

      -- Defer setup slightly to ensure other plugins like copilot/codeium sources are registered
      vim.defer_fn(function()
        cmp.setup {
          -- Disable cmp in specific buffers like oil
          enabled = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match('oil://') then -- Use string:match for safer checking
              return false
            end

            -- Restore keymaps potentially altered by langmapper when cmp activates
            -- Explanation: Assumes langmapper might remap keys globally, and cmp needs
            --              the original mappings to function correctly while active.
            pcall(require('langmapper').put_back_keymap) -- Wrap in pcall for safety

            return true
          end,
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body) -- Expand snippets using Luasnip
            end,
          },
          completion = {
            -- Use 'menuone' to always show menu, 'noselect' might be preferred by some
            completeopt = 'menu,menuone,noinsert',
          },
          mapping = cmp.mapping.preset.insert {
            -- Confirm selection: Selects the item without triggering completion again
            ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Changed select to true, common preference
            ['<CR>'] = cmp.mapping.confirm { select = false }, -- Confirm with Enter, no auto-select
            -- Trigger completion
            ['<C-Space>'] = cmp.mapping.complete(),
            -- Navigate completion menu
            ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            -- Scroll documentation window
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            -- Luasnip integration: Jump forward/backward in snippets
            ['<C-l>'] = cmp.mapping(function(fallback) -- Next placeholder/expand
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }), -- Works in insert and select mode
            ['<C-h>'] = cmp.mapping(function(fallback) -- Previous placeholder
              if luasnip.jumpable(-1) then -- Use jumpable(-1) for consistency
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          },
          window = {
            -- Add borders to completion and documentation windows
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          sources = cmp.config.sources({
            -- Define completion sources and their priority
            { name = 'nvim_lsp', priority = 10 }, -- Higher priority for LSP
            { name = 'luasnip', priority = 9 }, -- Snippets next
            { name = 'copilot', priority = 8 }, -- Copilot suggestions
            { name = 'codeium', priority = 7 }, -- Codeium (uncomment if enabled)
            { name = 'buffer', priority = 6 }, -- Words from current buffer
            { name = 'path', priority = 5 }, -- File paths
            { name = 'git', priority = 4 }, -- Git commit messages
          }),
          sorting = {
            -- Prioritize Copilot suggestions slightly higher if they appear
            priority_weight = 2,
            comparators = {
              require('copilot_cmp.comparators').prioritize, -- Copilot specific sorting adjustment
              -- Standard comparators (order matters)
              cmp.config.compare.offset, -- Penalize items further from cursor
              cmp.config.compare.exact, -- Prioritize exact matches
              cmp.config.compare.score, -- LSP/source score
              cmp.config.compare.recently_used, -- History
              cmp.config.compare.kind, -- Group by type (Function, Variable...)
              cmp.config.compare.sort_text, -- Alphabetical fallback
              cmp.config.compare.length, -- Shorter items first
              cmp.config.compare.order, -- Original source order
            },
          },
          formatting = {
            -- Use lspkind to add icons based on completion item kind
            format = lspkind.cmp_format {
              mode = 'symbol_text', -- Show symbol and text
              maxwidth = 50, -- Truncate long completion items if needed
              ellipsis_char = '...',
              -- Define icons for different kinds (requires a Nerd Font)
              symbol_map = {
                Text = '󰉿',
                Method = '󰆧',
                Function = '󰊕',
                Constructor = '',
                Field = '󰜢',
                Variable = '󰀫',
                Class = '󰠱',
                Interface = '',
                Module = '',
                Property = '󰜢',
                Unit = '󰑭',
                Value = '󰎠',
                Enum = '',
                Keyword = '󰌋',
                Snippet = '',
                Color = '󰏘',
                File = '󰈙',
                Reference = '󰈇',
                Folder = '󰉋',
                EnumMember = '',
                Constant = '󰏿',
                Struct = '󰙅',
                Event = '',
                Operator = '󰆕',
                TypeParameter = '󰊄', -- Added icon for TypeParameter
                Copilot = '',
                Codeium = '', -- Added icon for Codeium
              },
            },
          },
        }
      end, 100) -- Defer by 100ms

      -- Custom logic when completion menu closes (related to langmapper)
      cmp.event:on('menu_closed', function()
        -- Explanation: Assumes langmapper needs to re-apply its specific keymap hacks
        --              when the completion menu (which might use standard mappings) closes.
        pcall(function() -- Wrap in pcall for safety
            local langmapper = require 'langmapper'
            langmapper._hack_keymap()
            langmapper.hack_get_keymap()
        end)
      end)
    end,
  },

  -- Snippet Engine Configuration
  {
    'L3MON4D3/LuaSnip',
    -- No separate trigger needed, loaded as dependency by nvim-cmp
    config = function(_, opts) -- Pass opts if defined at top level
      local ls = require 'luasnip'
      ls.setup {
        -- Link sibling nodes for concurrent editing
        link_children = true,
        -- Don't link root nodes (usually not needed)
        link_roots = false,
        -- Don't keep root nodes after leaving them
        keep_roots = false,
        -- Update snippets on text change events for dynamic snippets
        update_events = { 'TextChanged', 'TextChangedI' },
        -- Pass any top-level opts table here
        -- unpack(opts or {}), -- uncomment if you define `opts = {}` for LuaSnip
      }

      -- Keymaps for navigating snippets (outside of nvim-cmp's menu)
      -- These differ slightly from the cmp mappings to provide standalone snippet control

      -- NOTE: Your original config had <C-j>, <C-k>, <C-l>, <C-h> here, but also similar
      -- mappings in nvim-cmp's config (<C-l>, <C-h>). This can be confusing.
      -- Recommendation: Keep snippet navigation primarily within cmp's mappings when the
      -- completion menu is active. Define separate keys here if you need snippet control
      -- *outside* of cmp's completion suggestions.

      -- Example: Using <Tab> for expand/jump forward, <S-Tab> for jump back
      vim.keymap.set({ 'i', 's' }, '<Tab>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        -- else provide fallback? e.g., vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'i', false)
        end
      end, { silent = true, desc = 'Snippet Expand/Next' })

      vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = 'Snippet Previous' })

      -- Keymaps for snippet choices (if using choice nodes)
      vim.keymap.set({ 'i', 's' }, '<C-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = 'Snippet Next Choice' })

      vim.keymap.set({ 'i', 's' }, '<C-h>', function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = 'Snippet Previous Choice' })

      -- Load snippets (example for friendly-snippets)
      -- require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Automatic Pair Closing & Insertion
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' }, -- Load when entering insert mode
    dependencies = { 'hrsh7th/nvim-cmp' }, -- Ensure cmp is loaded
    opts = {
      check_ts = true, -- Use treesitter to check context for pairing
      ts_config = {
        lua = { 'string', 'source' }, -- Example: disable pairing in lua strings
        javascript = { 'template_string' },
        java = false, -- Disable autopairs in java - example
      },
      -- Configure fast wrap feature (e.g., wrap selection with brackets)
      fast_wrap = {
        map = '<M-e>', -- Alt+e to trigger fast wrap
        chars = { '{', '[', '(', '"', "'", '`' }, -- Characters to wrap with
        pattern = [=[[%'%"%>%]%)%}%,]]=], -- Pattern for triggering wrap
        end_key = '$', -- End key (unused here?)
        cursor_pos_before = true, -- Place cursor before closing char
        keys = 'qwertyuiopzxcvbnmasdfghjkl', -- Allowed keys after wrap char
        manual_position = false, -- Auto-position cursor
        highlight = 'Search', -- Highlight for wrap preview
        highlight_grey = 'Comment', -- Highlight color for disabled keys
      },
      -- Other options: disable_filetype, enable_check_bracket_line, etc.
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      -- Integrate with nvim-cmp: If you confirm a completion item that starts
      -- with a pair character, autopairs might interfere. This hook helps fix that.
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- LSP Kind Icons for Completion Menu
  {
    'onsails/lspkind.nvim',
    -- No config needed if defaults are fine and formatting is handled in nvim-cmp
  },

  -- Copilot CMP Source (Loaded as dependency of nvim-cmp)
  -- {
  --   'zbirenbaum/copilot-cmp',
  --   config = function() require('copilot_cmp').setup() end
  -- },
}
