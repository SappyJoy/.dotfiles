local Hydra = require 'hydra'

-- Combine window and tab hints - Added 'T'
local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split        ^^     Tabs
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------  ^^---------------------
 ^ ^ _k_ ^ ^  ^ ^ ^ _K_ ^ ^    ^   _+_   ^      _s_: horizontally ^^ _c_: new tab
 _h_ ^ ^ _l_  ^ _H_ ^ ^ _L_    _<_     _>_      _v_: vertically   ^^ _d_: close tab
 ^ ^ _j_ ^ ^  ^ ^ ^ _J_ ^ ^    ^   _-_   ^      _q_: close window ^^ _n_: next tab
 focus^^^^^^  ^window^^^^  ^^^_=_: equalize ^   _z_: max height   ^^ _p_: prev tab
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^ ^  ^^ ^           ^   _x_: max width    ^^ _T_: window to new tab
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^ ^  ^^ ^           ^   _o_: remain only  ^^
]]

local h = nil
-- Hint is shown by default now, so 'shown' starts true
local shown = true
local show = function()
  if h ~= nil then
    if shown then -- If currently shown...
      h.hint:close() -- ...hide it
      shown = false
    else -- If currently hidden...
      h.hint:show() -- ...show it
      shown = true
    end
  end
end

h = Hydra {
  name = 'Windows & Tabs',
  hint = window_hint,
  config = {
    invoke_on_body = true,
    hint = {
      position = 'bottom',
      -- Show hint immediately when hydra is entered
      hide_on_load = false,
    },
    -- Add default noremap for all heads unless overridden
    -- This is a good general practice for hydra
    noremap = true,
  },
  mode = 'n',
  body = '<leader>w',
  heads = {
    -- === Window Focus ===
    -- noremap = true is inherited from config
    { 'h', '<C-w>h', { desc = 'focus left' } },
    { 'j', '<C-w>j', { desc = 'focus down' } },
    { 'k', '<C-w>k', { desc = 'focus up' } },
    { 'l', '<C-w>l', { desc = 'focus right' } },

    -- === Window Move ===
    { 'H', '<C-w>H', { desc = 'move left' } },
    { 'J', '<C-w>J', { desc = 'move down' } },
    { 'K', '<C-w>K', { desc = 'move up' } },
    { 'L', '<C-w>L', { desc = 'move right' } },

    -- === Window Resize ===
    { '<', '<C-w><', { desc = 'width -' } },
    { '-', '<C-w>-', { desc = 'height -' } },
    { '+', '<C-w>+', { desc = 'height +' } },
    { '>', '<C-w>>', { desc = 'width +' } },
    { '=', '<C-w>=', { desc = 'equalize' } },
    { 'z', '<c-w>_', { desc = 'maximize height' } },
    { 'x', '<c-w>|', { desc = 'maximize width' } },

    -- === Window Split / Close ===
    -- Use Ex commands for split to avoid potential <C-w>s timing issues
    { 's', ':split<CR>', { desc = 'split horizontal' } },
    { 'v', ':vsplit<CR>', { desc = 'split vertical' } },
    -- Using <Cmd> avoids mode changes and is slightly cleaner than :...<CR>
    -- { 's', '<Cmd>split<CR>', { desc = 'split horizontal' } },
    -- { 'v', '<Cmd>vsplit<CR>', { desc = 'split vertical' } },

    { 'o', '<C-w>o', { exit = true, desc = 'remain only' } },
    { 'q', '<C-w>q', { desc = 'close window' } }, -- Can also use :close<CR> or <Cmd>close<CR>

    -- === Tab Control ===
    -- Using <Cmd> which implies noremap and avoids mode changes
    { 'c', '<Cmd>tabnew<CR>', { desc = 'new tab' } },
    { 'd', '<Cmd>tabclose<CR>', { desc = 'close tab' } },
    { 'n', 'gt', { desc = 'next tab' } },
    { 'p', 'gT', { desc = 'prev tab' } },
    { 'T', '<C-w>T', { desc = 'window to new tab' } }, -- exit=true implies noremap not strictly needed for recursion

    -- === Hydra Utilities ===
    -- Function calls don't use noremap
    { 'i', show, { noremap = false, desc = 'toggle hint' } }, -- Explicitly false for functions

    -- === Exit Hydra ===
    -- exit=true implies noremap=false as there's no RHS mapping
    { '<Esc>', nil, { exit = true, desc = false } },
    { 'w', nil, { exit = true, desc = false } },
  },
}
