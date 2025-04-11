-- The are bug that writes "<Plug>(Hydra2_wait)" in current buffer if use body twice
-- Consider setting `invoke_on_body = false` and using a separate mapping like
-- vim.keymap.set('n', '<C-w>', h.body, { desc = 'Window/Tab Hydra' })
-- if the <Plug> issue persists or if you prefer <C-w> to only act as a prefix.

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
    -- color = 'pink', -- Optional: set color explicitly
  },
  mode = 'n',
  body = '<C-w>',
  heads = {
    -- === Window Focus ===
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
    { 's', '<C-w>s', { desc = 'split horizontal' } },
    { 'v', '<C-w>v', { desc = 'split vertical' } },
    { 'o', '<C-w>o', { exit = true, desc = 'remain only' } },
    { 'q', '<C-w>q', { desc = 'close window' } },

    -- === Window Switch ===
    { 'w', nil, { exit = true, desc = false } },
    { '<C-w>', nil, { exit = true, desc = false } },

    -- === Tab Control ===
    -- Note: Not exiting after 'c' means the hydra stays active, but focus moves
    -- to the new tab. The hydra state is tied to the original window.
    { 'c', ':tabnew<CR>', { desc = 'new tab' } }, -- Does NOT exit hydra
    { 'd', ':tabclose<CR>', { exit = true, desc = 'close tab' } }, -- Exits hydra
    { 'n', 'gt', { desc = 'next tab' } }, -- Does NOT exit hydra
    { 'p', 'gT', { desc = 'prev tab' } }, -- Does NOT exit hydra
    { 'T', '<C-w>T', { desc = 'window to new tab' } }, -- Exits hydra

    -- === Hydra Utilities ===
    { 'i', show, { desc = 'toggle hint' } }, -- Toggle hint visibility
    { 'b', show, { desc = false } }, -- Keep duplicate or remove if 'i' is enough

    -- === Exit Hydra ===
    { '<Esc>', nil, { exit = true, desc = false } },
    -- Optional: Add an explicit quit key if needed
    -- { 'Q', nil, { exit = true, desc = 'quit hydra' } },
  },
}

-- Optional keymap if you set invoke_on_body = false
-- vim.keymap.set('n', '<C-w>', h.body, { desc = 'Window/Tab Hydra' })
