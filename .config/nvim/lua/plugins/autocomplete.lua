return {
  -- NOTE: Here is where you install your plugins.
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      {
        'petertriho/cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
          filetypes = { 'gitcommit', 'gitrebase', 'markdown' }, -- markdown covers gh edits, which are markdown files
        },
      },

      -- If you want to add a bunch of pre-configured snippets,
      --    you can use this plugin to help you. It even has snippets
      --    for various frameworks/libraries/etc. but you will have to
      --    set up the ones that are useful for you.
      -- 'rafamadriz/friendly-snippets',
    },
    config = function(_, opts)
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local copilot_cmp = require 'copilot_cmp'
      local lspkind = require 'lspkind'

      -- Delay setup to ensure all dependencies are loaded
      vim.defer_fn(function()
        copilot_cmp.setup(opts)
        luasnip.config.setup {}

        cmp.setup {
          enabled = function()
            local path = vim.api.nvim_buf_get_name(0)
            if string.find(path, 'oil://', 1, true) == 1 then
              return false
            end

            -- NOTE: this fuction is getting triggered every time you enter insert mode
            local langmapper = require 'langmapper'
            -- disable langmapper while cmp is working
            langmapper.put_back_keymap()

            return true
          end,
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },
          mapping = cmp.mapping {
            ['<C-y>'] = cmp.mapping.confirm { select = false, behavior = cmp.ConfirmBehavior.Insert },
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
          },
          window = {
            completion = {
              border = 'single',
            },
            documentation = {
              border = 'single',
            },
          },
          sources = {
            { name = 'nvim_lsp', priority = 8 },
            { name = 'codeium', priority = 2 },
            { name = 'copilot', priority = 1 },
            -- { name = 'buffer', priority = 1 },
            -- { name = 'spell', priority = 1 },
            -- { name = 'dictionary', priority = 1 },
            -- { name = 'nvim_lua', priority = 1 },
            -- { name = 'fuzzy_path', priority = 1 },
            { name = 'luasnip' },
            { name = 'path' },
          },
          sorting = {
            priority_weight = 2,
            comparators = {
              require('copilot_cmp.comparators').prioritize,

              -- Below is the default comparitor list and order for nvim-cmp
              cmp.config.compare.offset,
              -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
              cmp.config.compare.exact,
              cmp.config.compare.score,
              cmp.config.compare.recently_used,
              cmp.config.compare.locality,
              cmp.config.compare.kind,
              cmp.config.compare.sort_text,
              cmp.config.compare.length,
              cmp.config.compare.order,
            },
          },
          formatting = {
            format = lspkind.cmp_format {
              mode = 'symbol', -- show only symbol annotations
              maxwidth = function()
                return math.floor(0.45 * vim.o.columns)
              end,
              ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              show_labelDetails = true, -- show labelDetails in menu. Disabled by default
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
                TypeParameter = '',
                Copilot = '',
                Codeium = '',
              },
            },
          },
        }

        cmp.event:on('menu_closed', function()
          local langmapper = require 'langmapper'
          langmapper._hack_keymap()
          langmapper.hack_get_keymap()
        end)

      end, 100) -- Delay setup by 100ms to ensure all dependencies are loaded
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local ls = require 'luasnip'
      ls.setup {
        link_children = true,
        link_roots = false,
        keep_roots = false,
        update_events = { 'TextChanged', 'TextChangedI' },
      }
      require 'snippets' -- loading custom snippets

      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true, desc = 'expand snippet or jump to the next snippet node' })

      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = 'previous spot in the snippet' })

      vim.keymap.set({ 'i', 's' }, '<C-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = 'next snippet choice' })

      vim.keymap.set({ 'i', 's' }, '<C-h>', function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = 'previous snippet choice' })
    end,
  },
  {
    'windwp/nvim-autopairs',
    dependencies = {
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      require('nvim-autopairs').setup {
        check_ts = true,
        fast_wrap = {
          map = '<A-e>',
          chars = { '{', '[', '(', '"', "'", '`' },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = '$',
          cursor_pos_before = true,
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          manual_position = false,
        },
      }
      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
