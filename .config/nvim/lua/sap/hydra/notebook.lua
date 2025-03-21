local function keys(str)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), 'm', true)
  end
end

local Hydra = require 'hydra'

local function create_cell(direction)
  -- Save initial cursor position
  local initial_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Find nearest code block boundaries
  local start_pattern, end_pattern = '^```', '^```'
  local flags = direction == 'below' and 'W' or 'bW'
  
  -- Find current block end first
  local block_end = vim.fn.search(end_pattern, flags)
  if block_end == 0 then block_end = initial_line end
  
  -- Then find current block start
  local block_start = vim.fn.search(start_pattern, 'b'..flags)
  if block_start == 0 then block_start = initial_line end
  
  -- Determine if we're between blocks
  local between_blocks = block_end < initial_line and 
                        vim.fn.getline(block_end + 1):match('^```')

  -- Calculate insertion position
  local target_line
  if direction == 'below' then
    target_line = between_blocks and block_end - 1 or (block_end)
  else
    target_line = between_blocks and (block_start + 2) or (block_start + 1)
  end

  -- Validate target position
  target_line = math.max(1, math.min(target_line, vim.fn.line('$')))
  
  -- Set cursor to insertion point
  vim.api.nvim_win_set_cursor(0, { target_line, 0 })
  
  -- Insert new cell
  local lang = vim.fn.getline(block_start):match('^```(%S+)') or 'python'
  local lines = direction == 'below' and 
    { '', '```'..lang, '', '```', '' } or 
    { '```'..lang, '', '```', '' }

  vim.api.nvim_buf_set_lines(0, target_line, target_line, false, lines)
  
  -- Position cursor in new cell
  local new_pos = direction == 'below' and 
    { target_line + 2, 0 } or  -- Inside new lower cell
    { target_line + 1, 0 }     -- Inside new upper cell

  vim.api.nvim_win_set_cursor(0, new_pos)
  vim.schedule(function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<c-j>', true, false, true),
      'n', true
    )
  end)
end

Hydra {
  name = 'Notebook',
  hint = '_j_/_k_: ↑/↓ | _o_/_O_: new cell ↓/↑ | _l_: run | _s_how/_h_ide | run _a_bove',
  config = {
    color = 'pink',
    invoke_on_body = true,
    hint = {
      type = 'window',
      position = 'bottom',
      float_opts = { border = 'rounded' },
    }
  },
  mode = { 'n' },
  body = '<localleader>j',
  heads = {
    { 'j', keys ']b', { desc = '↓' } },
    { 'k', keys '[b', { desc = '↑' } },
    { 'o', function() create_cell('below') end, { desc = 'new cell ↓' } },
    { 'O', function() create_cell('above') end, { desc = 'new cell ↑' } },
    { 'l', ':QuartoSend<CR>', { desc = 'run' } },
    { 's', ':noautocmd MoltenEnterOutput<CR>', { desc = 'show' } },
    { 'h', ':MoltenHideOutput<CR>', { desc = 'hide' } },
    { 'a', ':QuartoSendAbove<CR>', { desc = 'run above' } },
    { '<esc>', nil, { exit = true, desc = false } },
    { 'q', nil, { exit = true, desc = false } },
  },
}
