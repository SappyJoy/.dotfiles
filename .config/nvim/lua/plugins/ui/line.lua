-- lua/plugins/line.lua
return {
  {
    'MunifTanjim/nougat.nvim',
    dependencies = {
      'mfussenegger/nvim-dap', -- Dependency for DAP status
      -- 'benlubas/molten-nvim', -- Dependency for Molten status
    },
    config = function()
      -- Load colorscheme colors
      local color = require 'ayu.colors'
      color.generate(false) -- Pass `true` to enable mirage

      -- Nougat components
      local nougat = require 'nougat'
      local core = require 'nougat.core'
      local Bar = require 'nougat.bar'
      local Item = require 'nougat.item'
      local sep = require 'nougat.separator'

      local nut = {
        buf = {
          diagnostic_count = require('nougat.nut.buf.diagnostic_count').create,
          filename = require('nougat.nut.buf.filename').create,
          filestatus = require('nougat.nut.buf.filestatus').create,
          filetype = require('nougat.nut.buf.filetype').create,
        },
        git = {
          branch = require('nougat.nut.git.branch').create,
          status = require 'nougat.nut.git.status',
        },
        tab = {
          tablist = {
            tabs = require('nougat.nut.tab.tablist').create,
            close = require('nougat.nut.tab.tablist.close').create,
            icon = require('nougat.nut.tab.tablist.icon').create,
            label = require('nougat.nut.tab.tablist.label').create,
            modified = require('nougat.nut.tab.tablist.modified').create,
          },
        },
        mode = require('nougat.nut.mode').create,
        spacer = require('nougat.nut.spacer').create,
        truncation_point = require('nougat.nut.truncation_point').create,
      }

      -- --- Custom Component Functions ---

      -- Function to get DAP status
      local function get_dap_status()
        -- Use pcall to safely require dap
        local ok_dap, dap = pcall(require, 'dap')
        if not ok_dap then
          return ''
        end

        -- Use pcall to safely check for an active session
        local ok_session, session = pcall(dap.session)
        if ok_session and session then
          -- Optionally and safely check dap.status() for more details
          local ok_status, status_str = pcall(dap.status)
          local status_info = (ok_status and status_str) and (' (' .. status_str .. ')') or ''
          return '🐞 DAP' .. status_info -- Use a bug icon + status if available
        end
        return '' -- Return empty if no DAP session active or error checking
      end

      -- --- Statusline Configuration ---

      local mode = nut.mode {
        prefix = ' ',
        suffix = ' ',
        sep_right = sep.right_chevron_solid(true),
      }

      -- Define DAP status item
      local dap_item = Item {
        hl = { bg = color.vcs_removed, fg = color.bg }, -- Use a distinct color
        prefix = ' ',
        content = get_dap_status,
        suffix = ' ',
        sep_right = sep.right_chevron_solid(true),
        -- Only show if content is not empty
        hidden = function(self)
          return self.content == ''
        end,
      }

      -- Active Statusline (stl)
      local stl = Bar 'statusline'
      stl:add_item(mode)
      stl:add_item(dap_item) -- Add DAP status after mode
      stl:add_item(nut.git.branch {
        hl = { bg = color.accent, fg = color.fg },
        prefix = '  ', -- Git icon
        suffix = ' ',
        sep_right = sep.right_chevron_solid(true),
      })
      stl:add_item(nut.git.status.create {
        hl = { bg = color.line },
        content = {
          nut.git.status.count('added', {
            hl = { fg = color.vcs_added },
            prefix = ' +',
          }),
          nut.git.status.count('changed', {
            hl = { fg = color.vcs_modified },
            prefix = ' ~',
          }),
          nut.git.status.count('removed', {
            hl = { fg = color.vcs_removed },
            prefix = ' -',
          }),
        },
        suffix = ' ',
        sep_right = sep.right_chevron_solid(true),
      })
      local filename = stl:add_item(nut.buf.filename {
        hl = { bg = color.panel_bg },
        prefix = ' ',
        suffix = ' ',
      })
      local filestatus = stl:add_item(nut.buf.filestatus {
        hl = { bg = color.panel_bg },
        suffix = ' ',
        sep_right = sep.right_chevron_solid(true),
        config = {
          modified = '󰏫', -- Modified icon
          nomodifiable = '󰏯', -- Lock icon
          readonly = '', -- Readonly icon (adjust if needed)
          sep = ' ',
        },
      })
      stl:add_item(nut.spacer())
      stl:add_item(nut.truncation_point())
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.error, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = '  ', -- Error icon
        suffix = ' ',
        config = {
          severity = vim.diagnostic.severity.ERROR,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.warning, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = '  ', -- Warning icon
        suffix = ' ',
        config = {
          severity = vim.diagnostic.severity.WARN,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hidden = false,
        hl = { bg = color.regexp, fg = color.bg }, -- Using regexp color for INFO
        sep_left = sep.left_chevron_solid(true),
        prefix = '  ', -- Info icon
        suffix = ' ',
        config = {
          severity = vim.diagnostic.severity.INFO,
        },
      })
      stl:add_item(nut.buf.diagnostic_count {
        hl = { bg = color.special, fg = color.bg }, -- Using special color for HINT
        sep_left = sep.left_chevron_solid(true),
        prefix = '  ', -- Hint icon (adjust if needed)
        suffix = ' ',
        config = {
          severity = vim.diagnostic.severity.HINT,
        },
      })
      stl:add_item(nut.buf.filetype {
        hl = { bg = color.operator },
        sep_left = sep.left_chevron_solid(true),
        prefix = ' ',
        suffix = ' ',
      })
      stl:add_item(Item {
        hl = { bg = color.constant, fg = color.fg },
        sep_left = sep.left_chevron_solid(true),
        prefix = '  ', -- Line icon
        content = core.group {
          core.code 'l',
          ':',
          core.code 'c',
        },
        suffix = ' ',
      })
      stl:add_item(Item {
        hl = { bg = color.string, fg = color.bg },
        sep_left = sep.left_chevron_solid(true),
        prefix = ' ',
        content = core.code 'P', -- Percentage through file
        suffix = '% ', -- Added percentage sign
      })

      -- Inactive Statusline (stl_inactive) - Keep it simple
      local stl_inactive = Bar 'statusline'
      stl_inactive:add_item(mode)
      stl_inactive:add_item(filename) -- Use the same filename item instance
      stl_inactive:add_item(filestatus) -- Use the same filestatus item instance
      stl_inactive:add_item(nut.spacer())

      -- Set the statusline dynamically based on focus
      nougat.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)

      -- --- Tabline Configuration (Unchanged) ---
      local tal = Bar 'tabline'
      tal:add_item(nut.tab.tablist.tabs {
        active_tab = {
          hl = { bg = color.bg, fg = color.regexp },
          prefix = ' ',
          suffix = ' ',
          content = {
            nut.tab.tablist.icon { suffix = ' ' },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = ' ', config = { text = '●' } },
            nut.tab.tablist.close { prefix = ' ', config = { text = '󰅖' } },
          },
          sep_right = sep.right_chevron_solid(true),
        },
        inactive_tab = {
          hl = { bg = color.panel_bg, fg = color.fg_idle },
          prefix = ' ',
          suffix = ' ',
          content = {
            nut.tab.tablist.icon { suffix = ' ' },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = ' ', config = { text = '●' } },
            nut.tab.tablist.close { prefix = ' ', config = { text = '󰅖' } },
          },
          sep_right = sep.right_chevron_solid(true),
        },
      })

      nougat.set_tabline(tal)
    end,
  },
}
