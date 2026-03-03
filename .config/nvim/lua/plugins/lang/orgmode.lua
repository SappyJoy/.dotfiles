return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    config = function()
      require('orgmode').setup {
        org_agenda_files = { '~/orgfiles/**/*' },
        org_default_notes_file = '~/orgfiles/inbox.org',
        org_capture_templates = {
          t = {
            description = 'Task',
            template = '* TODO %?\n  %u',
            target = '~/orgfiles/inbox.org',
          },
          n = {
            description = 'Note',
            template = '* %?\n  %u',
            target = '~/orgfiles/inbox.org',
          },
          p = {
            description = 'LLM Prompt',
            template = '* PROMPT %?\n  %U\n\n  ',
            target = '~/orgfiles/prompts.org',
          },
        },
      }

      -- Optional: Register Which-Key labels for the default Orgmode mappings
      local ok, wk = pcall(require, 'which-key')
      if ok then
        wk.add {
          { '<leader>o', group = 'Orgmode' },
          { '<leader>oa', desc = 'Agenda' },
          { '<leader>oc', desc = 'Capture' },
          {
            '<leader>of',
            function()
              require('telescope.builtin').find_files { cwd = '~/orgfiles', prompt_title = 'Org Files' }
            end,
            desc = 'Find files',
          },
          {
            '<leader>os',
            function()
              require('telescope.builtin').live_grep { cwd = '~/orgfiles', prompt_title = 'Org Grep' }
            end,
            desc = 'Search content',
          },
          { '<leader>oh', '<cmd>Telescope orgmode search_headings<CR>', desc = 'Search headings' },
        }
      end
    end,
  },
  {
    'nvim-orgmode/telescope-orgmode.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-orgmode/orgmode',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'orgmode'
    end,
  },
}
