-- Plugins related to Jupyter Notebooks, Quarto, and interactive computing

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*.ipynb',
  callback = function()
    vim.bo.filetype = 'jupyter' -- Or 'python' if preferred
    require('jupytext').setup() -- Ensure jupytext activates
  end,
})

return {
  {
    'benlubas/molten-nvim',
    ft = { 'python', 'markdown', 'quarto', 'ipynb', 'jupyter' },
    dependencies = { '3rd/image.nvim', ft = { 'python', 'markdown', 'quarto', 'ipynb', 'jupyter' } },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_virt_text_output = true -- Restore virtual text output by default
      -- vim.g.molten_output_win_max_height = 20
      vim.g.molten_use_border_highlights = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_virt_text_output = true
      -- vim.g.molten_enter_output_behavior = "open_and_enter"
      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true

      -- don't change the mappings (unless it's related to your bug)
      vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { desc = 'Initialize Molten', silent = true })
      vim.keymap.set('n', '<localleader>mm', ':MoltenImportOutput<CR>', { desc = 'Import Notebook', silent = true })
      vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>', { desc = 'Evaluate operator', silent = true })
      vim.keymap.set('n', '<localleader>mr', ':MoltenReevaluateCell<CR>', { desc = 'Re-evaluate cell', silent = true })
      vim.keymap.set('n', '<localleader>mu', ':MoltenReevaluateAll<CR>', { desc = 'Re-evaluate all', silent = true })
      vim.keymap.set('v', '<localleader>me', ':<C-u>MoltenEvaluateVisual<CR>', { desc = 'Evaluate visual selection', silent = true })
      vim.keymap.set('n', '<localleader>mx', ':MoltenOpenInBrowser<CR>', { desc = 'Open in browser', silent = true })
      vim.keymap.set('n', '<localleader>mr', ':MoltenDelete<CR>', { desc = 'Delete Molten cell', silent = true })
      vim.keymap.set('n', '<localleader>ms', ':MoltenInterrupt<CR>', { desc = 'Molten Interrupt', silent = true })
      vim.keymap.set('n', '<localleader>ma', ':MoltenReevaluateAll<CR>', { desc = 'Molten Run All', silent = true })
      -- vim.keymap.set('n', '<localleader>k', ':MoltenPrev<CR>', { desc = 'Previous cell', silent = true })
      -- vim.keymap.set('n', '<localleader>j', ':MoltenNext<CR>', { desc = 'Next cell', silent = true })

      -- Provide a command to create a blank new Python notebook
      -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
      -- if you use another language than Python, you should change it in the template.
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
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.qmd', '*.md', '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.keymap.set('n', '<localleader>mo', ':noautocmd MoltenEnterOutput<CR>', { desc = 'Open output window', silent = true })
            vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { desc = 'Hide output window', silent = true })
          end
        end,
      })

      -- automatically import output chunks from a jupyter notebook
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local kernel_name = nil

          -- 1. Try to match the active VirtualEnv to a kernel name
          local venv = os.getenv 'VIRTUAL_ENV'
          if venv ~= nil then
            local venv_name = string.match(venv, '/.+/(.+)')
            if vim.tbl_contains(kernels, venv_name) then
              kernel_name = venv_name
            end
          end

          if kernel_name then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
            vim.cmd 'MoltenImportOutput'
          else
            -- Optional: Notify that no automatic kernel was found
            -- vim.notify("Molten: No venv-matching kernel found. Please run :MoltenInit", vim.log.levels.INFO)
          end
        end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd('BufAdd', {
        pattern = { '*.ipynb' },
        callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
            imb(e)
          end
        end,
      })

      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.cmd 'MoltenExportOutput!'
          end
        end,
      })
    end,
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'quarto', 'ipynb', 'jupyter' },
    dependencies = {
      'jmbuhr/otter.nvim',
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
      'nvim-cmp',
      { 'nvimtools/hydra.nvim', lazy = true },
    },
    config = function()
      local quarto = require 'quarto'
      quarto.setup {
        lspFeatures = {
          -- NOTE: put whatever languages you want here:
          languages = { 'r', 'python', 'rust' },
          chunks = 'all',
          diagnostics = {
            enabled = true,
            triggers = { 'BufWritePost' },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          -- NOTE: setup your own keymaps:
          hover = 'H',
          definition = 'gd',
          rename = '<leader>rn',
          references = 'gr',
          format = '<leader>fj',
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      }

      vim.keymap.set('n', '<localleader>qp', quarto.quartoPreview, { desc = 'Preview the Quarto document', silent = true, noremap = true })
      -- to create a cell in insert mode, I have the ` snippet

      local runner = require 'quarto.runner'
      vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
      vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
      vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
      vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
      vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
      -- vim.keymap.set('n', '<localleader>RA', function()
      --   runner.run_all(true)
      -- end, { desc = 'run all cells of all languages', silent = true })

      -- --- Hydra / Notebook Navigation ---
      local Hydra = require 'hydra'
      local function keys(str)
        return function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), 'm', true)
        end
      end

      local function create_cell(direction)
        local initial_line = vim.api.nvim_win_get_cursor(0)[1]
        local start_pattern, end_pattern = '^```', '^```'
        -- Find the block start *above* the cursor
        local search_start_above = vim.fn.search(start_pattern, 'bW')
        -- Find the block end *below* the cursor
        local search_end_below = vim.fn.search(end_pattern, 'W')

        local target_line
        if direction == 'below' then
          target_line = search_end_below > 0 and search_end_below or vim.fn.line '$'
        else -- above
          target_line = search_start_above > 0 and search_start_above - 1 or 0
        end
        target_line = math.max(0, math.min(target_line, vim.fn.line '$'))

        -- Determine language from nearest block if possible
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
          return
        end

        vim.cmd 'MoltenDelete'
        vim.api.nvim_buf_set_lines(0, block_start - 1, block_end, false, {})

        local target_line = math.max(1, block_start - 1)
        local last_line = vim.api.nvim_buf_line_count(0)
        target_line = math.min(target_line, last_line)
        if last_line == 0 then
          target_line = 1
        end
        pcall(vim.api.nvim_win_set_cursor, 0, { target_line, 0 })
      end

      Hydra {
        name = 'Notebook',
        hint = '_j_/_k_: ↑/↓ | _o_/_O_: new cell ↓/↑ | _l_/_t_: run/stop | _s_how/_h_ide | run _a_bove/_A_ll | _d_elete cell | _R_estart kernel',
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
          { 'j', keys ']b', { desc = '↓' } },
          { 'k', keys '[b', { desc = '↑' } },
          {
            'o',
            function()
              create_cell 'below'
            end,
            { desc = 'new cell ↓' },
          },
          {
            'O',
            function()
              create_cell 'above'
            end,
            { desc = 'new cell ↑' },
          },
          { 'd', delete_current_cell_and_block, { desc = 'delete cell' } },
          { 'l', ':QuartoSend<CR>', { desc = 'run' } },
          { 't', ':MoltenInterrupt<CR>', { desc = 'stop' } },
          { 's', ':noautocmd MoltenEnterOutput<CR>', { desc = 'show' } },
          { 'h', ':MoltenHideOutput<CR>', { desc = 'hide' } },
          { 'a', ':QuartoSendAbove<CR>', { desc = 'run above' } },
          { 'A', ':MoltenReevaluateAll<CR>', { desc = 'run all' } },
          { 'R', ':MoltenRestart<CR>', { desc = 'restart kernel' } },
          { 'i', keys 'i', { exit = true, desc = false } },
          { 'I', keys 'I', { exit = true, desc = false } },
          { 'S', keys 'S', { exit = true, desc = false } },
          { 'C', keys 'C', { exit = true, desc = false } },
          { 'cc', keys 'cc', { exit = true, desc = false } },
          { '-', keys '-', { exit = true, desc = false } },
          { '<esc>', nil, { exit = true, desc = false } },
          { 'q', nil, { exit = true, desc = false } },
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
    -- Depending on your nvim distro or config you may need to make the loading not lazy
    -- lazy=false,
  },
}
