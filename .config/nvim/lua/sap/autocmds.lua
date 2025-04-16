local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Autocommand group for Markdown specific settings
augroup('MarkdownAutoFoldFrontmatter', { clear = true })

autocmd('FileType', {
  pattern = 'markdown',
  group = 'MarkdownAutoFoldFrontmatter',
  callback = function(event)
    local buf = event.buf

    -- Standard Treesitter fold setup for the buffer
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt_local.foldlevel = 99 -- Start open to allow selective closing

    -- Defer the fold closing with an explicit delay (e.g., 100ms)
    vim.defer_fn(function()
      -- Use nvim_buf_call to ensure we execute in the context of the correct buffer,
      -- even if the user switched buffers *very* quickly after Telescope.
      vim.api.nvim_buf_call(buf, function()
        -- Check if buffer is still valid and first line looks like frontmatter
        local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
        if first_line and first_line:match '^%-%-%-$' then
          -- **Crucial Check:** Verify a fold actually exists at line 1 before closing.
          -- vim.fn.foldlevel(linenr) returns the level if folded, or 0 if not.
          -- We check if it's > 0, meaning Treesitter has calculated a fold there.
          if vim.fn.foldlevel(1) > 0 then
            -- Attempt to close the fold specifically at line 1
            pcall(vim.cmd, '1foldclose')
            -- Reposition cursor nicely after folding
            pcall(vim.cmd, 'normal! Hzz')
          end
        end
      end)
    end, 100)
    vim.cmd 'syntax enable' -- Ensure syntax is on
  end,
  desc = 'Auto-close YAML frontmatter fold in Markdown files (Deferred)',
})
