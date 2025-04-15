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
  -- Use 'W' to wrap search, 'b' for backward
  local flags_fwd = 'W'
  local flags_bwd = 'bW'

  -- Find the end of the block potentially containing the cursor or just after it
  local block_end_search = vim.fn.searchpos(end_pattern, flags_fwd)
  local block_end = block_end_search[1] -- Use searchpos to get line number directly

  -- Find the start of the block potentially containing the cursor or just before it
  local block_start_search = vim.fn.searchpos(start_pattern, flags_bwd)
  local block_start = block_start_search[1]

  -- Refine logic to find the block *containing* the cursor OR the immediately adjacent one
  local current_block_start, current_block_end
  -- Check if cursor is inside a block based on nearest search results
  if block_start > 0 and block_end > 0 and block_start <= initial_line and block_end >= initial_line then
      -- Cursor is likely inside the block found by searching backwards/forwards from cursor
      current_block_start = block_start
      current_block_end = block_end
  else
     -- Maybe cursor is between blocks or outside? Let's try searching strictly from current line
     current_block_start = vim.fn.search(start_pattern, 'bW') -- Search backwards including current line
     current_block_end = vim.fn.search(end_pattern, 'W')     -- Search forwards including current line
     -- If search failed or didn't enclose the cursor, adjust
     if current_block_start == 0 or current_block_end == 0 or current_block_start > initial_line or current_block_end < initial_line then
        -- Fallback: use initial line if search fails, maybe create at top/bottom?
        -- This part of the original logic seems complex; let's simplify for create_cell's goal:
        -- Find the block start *above* the cursor
        local search_start_above = vim.fn.search(start_pattern, 'bW')
        -- Find the block end *below* the cursor
        local search_end_below = vim.fn.search(end_pattern, 'W')

        if direction == 'below' then
            target_line = search_end_below > 0 and search_end_below or vim.fn.line('$')
        else -- above
            target_line = search_start_above > 0 and search_start_above -1 or 0 -- insert before line 1 if no block above
        end
        -- Ensure target_line is valid before proceeding
        target_line = math.max(0, math.min(target_line, vim.fn.line('$'))) -- Allow insertion at line 0 for 'above' at top

        -- Determine language from nearest block if possible
        local lang_line = search_start_above > 0 and search_start_above or vim.fn.search(start_pattern, 'W') -- find any block
        local lang = lang_line > 0 and vim.fn.getline(lang_line):match('^```(%S+)') or 'python'

        local lines = direction == 'below' and
            { '', '```'..lang, '', '```' } or
            { '```'..lang, '', '```', '' }

        -- Adjust target_line for insertion behavior (0-based index for nvim_buf_set_lines)
        -- Insert *after* target_line for 'below', *at* target_line for 'above'
        local insert_at = direction == 'below' and target_line or target_line

        vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, lines)

        -- Position cursor in new cell
        local new_pos_line = direction == 'below' and insert_at + 2 or insert_at + 1
        vim.api.nvim_win_set_cursor(0, { new_pos_line, 0 })

        -- Ensure mode change happens if needed (e.g., trigger insert mode if desired)
        -- The original <c-j> might have been for specific workflow, maybe just enter normal mode?
        -- Or schedule 'i' to enter insert? Let's stick to normal mode positioning for now.
        -- vim.schedule(function() vim.cmd("normal! i") end) -- Uncomment to enter insert mode

        return -- Exit function early as we handled insertion differently
     end
  end


  -- Determine insertion position based on direction and current block
  local target_line
  if direction == 'below' then
    target_line = current_block_end
  else -- above
    target_line = current_block_start - 1 -- Insert *before* the start line
  end

  -- Validate target position
  target_line = math.max(0, math.min(target_line, vim.fn.line('$'))) -- Allow insertion at line 0

  -- Get language from the current block start
  local lang = vim.fn.getline(current_block_start):match('^```(%S+)') or 'python'

  -- Insert new cell
  local lines = direction == 'below' and
    { '', '```'..lang, '', '```' } or
    { '```'..lang, '', '```', '' }

  -- Adjust target_line for insertion behavior (0-based index for nvim_buf_set_lines)
  -- Insert *after* target_line for 'below', *at* target_line for 'above'
  local insert_at = direction == 'below' and target_line or target_line

  vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, lines)

  -- Position cursor in new cell
  local new_pos_line = direction == 'below' and insert_at + 3 or insert_at + 2
  vim.api.nvim_win_set_cursor(0, { new_pos_line, 0 })
  
  -- Original code had a <c-j> feedkeys, which might be specific to a setup. 
  -- Removing it for clarity unless it's essential for molten integration.
  -- If needed for triggering cell recognition, it should be added back.
  -- vim.schedule(function()
  --   vim.api.nvim_feedkeys(
  --     vim.api.nvim_replace_termcodes('<c-j>', true, false, true),
  --     'n', true
  --   )
  -- end)
end


-- Function to delete the current Molten cell and its code block
local function delete_current_cell_and_block()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]

  -- 1. Find the code block boundaries containing the cursor
  -- Use 'n' flag to prevent wrap-around searches, 'W' to ignore 'wrap' option
  -- Search backwards for the start ``` marker
  local block_start = vim.fn.search('^```', 'bnW')
  -- Search forwards for the end ``` marker
  local block_end = vim.fn.search('^```', 'nW')

  -- 2. Check if the cursor is actually within a found block
  -- Also handles search failures (returns 0)
  if block_start == 0 or block_end == 0 or current_line < block_start or current_line > block_end then
    -- Cursor is not inside a recognizable ``` block. Do nothing.
    -- vim.notify("Cursor not inside a code block.", vim.log.levels.WARN) -- Optional feedback
    return
  end

  -- 3. Call MoltenDelete - This should handle the internal cell state
  -- We rely on MoltenDelete to correctly identify the active cell based on cursor
  vim.cmd('MoltenDelete')

  -- 4. Delete the code block lines from the buffer
  -- nvim_buf_set_lines uses 0-based indexing and the end index is exclusive.
  -- To delete lines `block_start` through `block_end` (inclusive, 1-based):
  -- Start index = block_start - 1
  -- End index = block_end (because end is exclusive, deleting up to end deletes line end-1)
  -- Wait, end *is* exclusive. To delete block_end too, we need end index block_end + 1.
  -- Let's re-read help: "end: First line index, exclusive".
  -- To delete lines 5, 6, 7 (start=5, end=7): Call with start=4, end=7. Deletes lines at index 4, 5, 6. Correct.
  -- So, the call should be: start = block_start - 1, end = block_end
   -- vim.api.nvim_buf_set_lines(0, block_start - 1, block_end, false, {})
   -- Correction: The above deletes up to block_end-1. To delete block_end itself, use end = block_end + 1 (0-based exclusive).
   -- Let's test: Delete line 5 (start=5, end=5). Call: start=4, end=5. Deletes index 4. Correct.
   -- Delete lines 5, 6, 7 (start=5, end=7). Call: start=4, end=7+1 = 8. Incorrect.
   -- Back to basics: `:h nvim_buf_set_lines`. Example: `delete lines 1-3`: `nvim_buf_set_lines(0, 0, 3, false, {})`.
   -- This means start is inclusive (0-based), end is exclusive (0-based).
   -- To delete lines `block_start` to `block_end` (1-based):
   -- Start index (0-based, inclusive) = block_start - 1
   -- End index (0-based, exclusive) = block_end
   -- So the call is indeed:
   vim.api.nvim_buf_set_lines(0, block_start - 1, block_end, false, {})


  -- 5. Optional: Move cursor to a sensible position after deletion
  -- Try moving to the line that was just before the deleted block
  local target_line = math.max(1, block_start - 1)
  -- Ensure the target line still exists after deletion
  local last_line = vim.api.nvim_buf_line_count(0)
  target_line = math.min(target_line, last_line)
  -- If buffer becomes empty, stay at line 1
  if last_line == 0 then target_line = 1 end
  pcall(vim.api.nvim_win_set_cursor, 0, {target_line, 0}) -- Use pcall in case buffer/window becomes invalid

  -- vim.notify("Deleted cell and code block.", vim.log.levels.INFO) -- Optional feedback
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
  body = '<localleader>j',
  heads = {
    -- Navigation and Cell Creation (Existing)
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
    -- Deletion
    {
      'd',
      delete_current_cell_and_block, -- Use the new function
      { desc = 'delete cell' }
    },

    -- Execution and Output (Existing)
    { 'l', ':QuartoSend<CR>', { desc = 'run' } },
    { 't', ':MoltenInterrupt<CR>', { desc = 'stop' } },
    { 's', ':noautocmd MoltenEnterOutput<CR>', { desc = 'show' } },
    { 'h', ':MoltenHideOutput<CR>', { desc = 'hide' } },
    { 'a', ':QuartoSendAbove<CR>', { desc = 'run above' } },
    { 'A', ':MoltenReevaluateAll<CR>', { desc = 'run all' } },
    { 'R', ':MoltenRestart<CR>', { desc = 'restart kernel' } },

    { 'i', keys 'i', {exit = true, desc = false} },
    { 'I', keys 'I', {exit = true, desc = false} },
    { 'S', keys 'S', {exit = true, desc = false} },
    { 'C', keys 'C', { exit = true, desc = false } },
    { 'cc', keys 'cc', { exit = true, desc = false } },

    -- Existing Exit Keys
    { '<esc>', nil, { exit = true, desc = false } },
    { 'q', nil, { exit = true, desc = false } },
  },
}
