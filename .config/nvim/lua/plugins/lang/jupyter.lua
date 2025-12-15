-- Plugins related to Jupyter Notebooks, Quarto, and interactive computing

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*.ipynb',
  callback = function()
    vim.bo.filetype = 'markdown' -- Jupytext handles conversion
    -- require('jupytext').setup() -- Jupytext lazy loads automatically usually
  end,
})

return {
  {
    'benlubas/molten-nvim',
    ft = { 'python', 'markdown', 'quarto', 'ipynb' },
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_virt_text_output = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_auto_open_output = false -- Disable auto-open to prevent focus stealing
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

      local function new_notebook(filename)
        local path = filename .. '.ipynb'
        local file = io.open(path, 'w')
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd('edit ' .. path)
        else
          print 'Error: Could not open new notebook file for writing.'
        end
      end

      vim.api.nvim_create_user_command('NewNotebook', function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = 'file',
      })
    end,
    config = function()
      -- Define Keymaps ONLY for relevant filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'quarto' },
        callback = function(event)
          local buf = event.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end

          -- Molten Keymaps
          map('n', '<leader>mi', '<cmd>MoltenInit<CR>', 'Molten Init')
          map('n', '<leader>mm', '<cmd>MoltenImportOutput<CR>', 'Molten Import')
          map('n', '<leader>me', '<cmd>MoltenEvaluateOperator<CR>', 'Molten Eval Operator')
          map('n', '<leader>mr', '<cmd>MoltenReevaluateCell<CR>', 'Molten Re-eval Cell')
          -- map('n', '<leader>mR', '<cmd>MoltenReevaluateAll<CR>', 'Molten Re-eval All')
          map('n', '<leader>md', '<cmd>MoltenDelete<CR>', 'Molten Delete Cell')
          map('n', '<leader>mh', '<cmd>MoltenHideOutput<CR>', 'Molten Hide Output')
          map('n', '<leader>mo', '<cmd>noautocmd MoltenEnterOutput<CR>', 'Molten Show Output')
          map('n', '<leader>ms', '<cmd>MoltenInterrupt<CR>', 'Molten Stop/Interrupt')
          map('n', '<leader>mx', '<cmd>MoltenOpenInBrowser<CR>', 'Molten Open in Browser')
          
          -- Quarto Runner Keymaps
          local runner = require('quarto.runner')
          map('n', '<leader>rc', runner.run_cell, 'Run Cell')
          map('n', '<leader>ra', runner.run_above, 'Run Above')
          map('n', '<leader>rA', runner.run_all, 'Run All')
          map('n', '<leader>rl', runner.run_line, 'Run Line')
          map('v', '<leader>r',  runner.run_range, 'Run Visual Range')
        end,
      })

      -- Auto-import output on buffer enter (Logic optimized from before)
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufEnter' }, {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar('vim_did_enter') ~= 1 then
            vim.schedule(function()
              local kernels = vim.fn.MoltenAvailableKernels()
              local venv = os.getenv('VIRTUAL_ENV')
              if venv then
                local venv_name = string.match(venv, '/.+/(.+)')
                if vim.tbl_contains(kernels, venv_name) then
                  vim.cmd(('MoltenInit %s'):format(venv_name))
                  vim.cmd('MoltenImportOutput')
                end
              end
            end)
          end
        end,
      })

      -- Auto-export on save
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.cmd('MoltenExportOutput!')
          end
        end,
      })
    end,
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'quarto', 'markdown' }, -- Load on markdown too for Hydra
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvimtools/hydra.nvim',
    },
    config = function()
      local quarto = require 'quarto'
      quarto.setup {
        lspFeatures = {
          languages = { 'python', 'rust', 'lua' },
          chunks = 'all',
          diagnostics = { enabled = true, triggers = { 'BufWritePost' } },
          completion = { enabled = true },
        },
        keymap = {
          hover = 'K',
          definition = 'gd',
          rename = '<leader>rn',
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      }

      -- vim.keymap.set('n', '<localleader>qp', quarto.quartoPreview, { desc = 'Preview the Quarto document', silent = true, noremap = true })
      -- -- to create a cell in insert mode, I have the ` snippet
      --
      -- local runner = require 'quarto.runner'
      -- vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
      -- vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
      -- vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
      -- vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
      -- vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })

      -- --- Hydra / Notebook Navigation ---
      local Hydra = require 'hydra'
      local function keys(str)
        return function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), 'm', true)
        end
      end

      -- Custom Cell Helper Functions
      local function create_cell(direction)
        local start_pattern, end_pattern = '^```', '^```'
        local search_start_above = vim.fn.search(start_pattern, 'bW')
        local search_end_below = vim.fn.search(end_pattern, 'W')

        local target_line
        if direction == 'below' then
          target_line = search_end_below > 0 and search_end_below or vim.fn.line '$'
        else -- above
          target_line = search_start_above > 0 and search_start_above - 1 or 0
        end
        target_line = math.max(0, math.min(target_line, vim.fn.line '$'))

        -- Auto-detect language
        local lang_line = search_start_above > 0 and search_start_above or vim.fn.search(start_pattern, 'W')
        local lang = lang_line > 0 and vim.fn.getline(lang_line):match '^```(%S+)' or 'python'

        local lines = direction == 'below' and { '', '```' .. lang, '', '```' } or { '```' .. lang, '', '```', '' }
        local insert_at = direction == 'below' and target_line or target_line

        vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, lines)
        local new_pos_line = direction == 'below' and insert_at + 3 or insert_at + 2
        vim.api.nvim_win_set_cursor(0, { new_pos_line, 0 })
      end

      local function delete_current_cell_and_block()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line = cursor_pos[1]
        local block_start = vim.fn.search('^```', 'bnW')
        local block_end = vim.fn.search('^```', 'nW')

        if block_start == 0 or block_end == 0 or current_line < block_start or current_line > block_end then
          vim.notify("Cursor not inside a cell", vim.log.levels.WARN)
          return
        end

        vim.cmd 'MoltenDelete'
        vim.api.nvim_buf_set_lines(0, block_start - 1, block_end, false, {})
        pcall(vim.api.nvim_win_set_cursor, 0, { math.max(1, block_start - 1), 0 })
      end

      -- Notebook Hydra
      local notebook_hint = [[ _J_/_K_: cell  _o_/_O_: new  _d_: del  _l_/_a_/_A_: run  _s_/_h_: output _t_: interrupt  _R_: restart kernel  _q_: exit ]]

      Hydra {
        name = 'Notebook',
        hint = notebook_hint,
        config = {
          color = 'pink',
          invoke_on_body = true,
          hint = {
            type = 'window',
            position = 'bottom',
            float_opts = { border = 'rounded' },
          },
        },
        mode = { 'n' },
        body = '<leader>j',
        heads = {
          -- Navigation
          { 'J', keys ']b', { desc = 'next cell' } },
          { 'K', keys '[b', { desc = 'prev cell' } },

          -- Actions
          { 'o', function() create_cell 'below' end, { desc = 'new below' } },
          { 'O', function() create_cell 'above' end, { desc = 'new above' } },
          { 'd', delete_current_cell_and_block, { desc = 'delete cell' } },
          
          -- Execution
          { 'l', ':QuartoSend<CR>', { desc = 'run' } },
          { 'a', ':QuartoSendAbove<CR>', { desc = 'run above' } },
          { 'A', ':MoltenReevaluateAll<CR>', { desc = 'run all' } },
          { 'R', ':MoltenRestart<CR>', { desc = 'restart kernel' } },
          
          -- Output Control
          { 's', ':noautocmd MoltenEnterOutput<CR>', { desc = 'show float' } },
          { 'h', ':MoltenHideOutput<CR>', { desc = 'hide' } },
          { 't', ':MoltenInterrupt<CR>', { desc = 'stop' } },

          -- Exit
          { '<Esc>', nil, { exit = true, desc = false } },
          { 'q', nil, { exit = true, desc = false } },
          { 'i', keys 'i', { exit = true, desc = false } },
          { 'I', keys 'I', { exit = true, desc = false } },
          { 'S', keys 'S', { exit = true, desc = false } },
          { 'C', keys 'C', { exit = true, desc = false } },
          { 'cc', keys 'cc', { exit = true, desc = false } },
          { '-', keys '-', { exit = true, desc = false } },
        },
      }
    end,
  },
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    config = function()
      require('jupytext').setup {
        style = 'markdown',
        output_extension = 'md',
        force_ft = 'markdown',
        custom_language_formatting = {
          jupyter = { -- Add explicit format mapping
            fmt = 'markdown',
            extension = 'md',
          },
        },
      }
    end,
  },
}
