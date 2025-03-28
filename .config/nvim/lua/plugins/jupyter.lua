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
      -- vim.g.molten_output_win_max_height = 20
      vim.g.molten_use_border_highlights = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      -- this will make it so the output shows up below the \`\`\` cell delimiter
      -- vim.g.molten_virt_lines_off_by_1 = true

      -- don't change the mappings (unless it's related to your bug)
      vim.keymap.set('n', '<localleader>min', ':MoltenInit<CR>', { desc = 'Initialize Molten', silent = true })
      vim.keymap.set('n', '<localleader>mim', ':MoltenImportOutput<CR>', { desc = 'Import Notebook', silent = true })
      vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>', { desc = 'Evaluate operator', silent = true })
      vim.keymap.set('n', '<localleader>mr', ':MoltenReevaluateCell<CR>', { desc = 'Re-evaluate cell', silent = true })
      vim.keymap.set('n', '<localleader>mu', ':MoltenReevaluateAll<CR>', { desc = 'Re-evaluate all', silent = true })
      vim.keymap.set('v', '<localleader>me', ':<C-u>MoltenEvaluateVisual<CR>', { desc = 'Evaluate visual selection', silent = true })
      vim.keymap.set('n', '<localleader>mo', ':noautocmd MoltenEnterOutput<CR>', { desc = 'Open output window', silent = true })
      vim.keymap.set('n', '<localleader>mx', ':MoltenOpenInBrowser<CR>', { desc = 'Open in browser', silent = true })
      vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { desc = 'Hide output window', silent = true })
      vim.keymap.set('n', '<localleader>mr', ':MoltenDelete<CR>', { desc = 'Delete Molten cell', silent = true })
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
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', true)
            vim.fn.MoltenUpdateOption('virt_text_output', true)
          else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
          end
        end,
      })

      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv 'VIRTUAL_ENV'
            if venv ~= nil then
              kernel_name = string.match(venv, '/.+/(.+)')
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
          end
          vim.cmd 'MoltenImportOutput'
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
          format = '<leader>gf',
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      }

      vim.keymap.set('n', '<localleader>qp', quarto.quartoPreview, { desc = 'Preview the Quarto document', silent = true, noremap = true })
      -- to create a cell in insert mode, I have the ` snippet
      vim.keymap.set('n', '<localleader>cc', 'i`<c-j>', { desc = 'Create a new code cell', silent = true })
      vim.keymap.set('n', '<localleader>cs', 'i```\r\r```{}<left>', { desc = 'Split code cell', silent = true, noremap = true })

      local runner = require 'quarto.runner'
      vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
      vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
      vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
      vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
      vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
      vim.keymap.set('n', '<localleader>RA', function()
        runner.run_all(true)
      end, { desc = 'run all cells of all languages', silent = true })

      require 'sap.hydra.notebook'
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
