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
        org_default_orgfiles_file = '~/orgfiles/inbox.org',
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
        },
      }

      -- Optional: Register Which-Key labels for the default Orgmode mappings
      local ok, wk = pcall(require, 'which-key')
      if ok then
        wk.add {
          { '<leader>o', group = 'Orgmode' },
          { '<leader>oa', desc = 'Agenda' },
          { '<leader>oc', desc = 'Capture' },
        }
      end
    end,
  },
}
