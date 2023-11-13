---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
    ["J"] = { ":m '>+1<CR>gv=gv", "move up"},
    ["K"] = { ":m '>+1<CR>gv=gv", "move down"},
    ["<C-c>"] = { "<Esc>", "go to normal mode"},
  },
}

-- more keybinds!

return M
