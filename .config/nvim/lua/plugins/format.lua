return {
  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = true, -- Keep true during debugging
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },

      -- Define specific formatter configurations
      formatters = {
        -- Configure prettier to accept stdin and treat it as markdown
        -- We create a dedicated formatter definition for this case.
        prettier_markdown_stdin = {
          inherit = true, -- Inherit base command, etc. from prettier if defined elsewhere
          command = 'prettier', -- Ensure command is correct
          -- Crucial: Provide a fake filename to prettier so it uses the markdown parser
          args = { '--stdin-filepath', 'dummy.md' },
          stdin = true,
        },
        ktfmt = {
          inherit = true,
          prepend_args = { '--kotlinlang-style' },
        },

        -- Configure cbfmt (assuming it's codeblockfmt)
        -- Usually, cbfmt should handle stdin well, but if it also fails,
        -- you might need to configure it explicitly.
        -- Example (if needed):
        -- cbfmt = {
        --   command = "cbfmt",
        --   stdin = true,
        --   args = {}, -- Add args if needed to hint language, though usually auto-detects from ``` blocks
        -- }
      },

      formatters_by_ft = {
        lua = { 'stylua' },
        cpp = { 'clang-format' },
        cmake = { 'cmake_format' },
        python = { 'cbfmt', 'isort', 'black' },
        java = { 'google-java-format' },
        json = { 'prettier' }, -- Use standard prettier for json
        xml = { 'xmlformat' },
        sql = { 'sql_formatter' },
        -- Use the specific prettier config for markdown buffers (including jupytext ones)
        markdown = { 'cbfmt', 'prettier_markdown_stdin' },
        yaml = { 'prettier' }, -- Use standard prettier for yaml
        protobuf = { 'buf' },
        proto = { 'buf' },
        typescript = { 'eslint_d' },
        kotlin = { 'ktfmt' },
        javascript = { 'prettierd', 'prettier' },
        -- Remove ipynb and jupyter, rely on markdown ft set by jupytext
        -- quarto = { 'cbfmt', 'isort', 'black' }, -- Keep if you format quarto files differently
        quarto = { 'cbfmt', 'prettier_markdown_stdin' }, -- Or treat quarto like markdown
      },
    },
    -- Ensure the keymap is outside the opts table if it wasn't already
    config = function(_, opts)
      require('conform').setup(opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
        require('conform').format {
          timeout_ms = 1000, -- Increase timeout if needed
          lsp_fallback = true,
        }
      end, { desc = '[F]or[m]at buffer' })
    end,
  },
}
