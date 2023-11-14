---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
        ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
	},
	v = {
		[">"] = { ">gv", "indent" },
		["J"] = { ":m '>+1<CR>gv=gv", "move up" },
		["K"] = { ":m '>+1<CR>gv=gv", "move down" },
		["<C-c>"] = { "<Esc>", "go to normal mode" },
	},
}

M.disabled = {
  n = {
      ["<tab>"] = "",
      ["<S-tab>"] = ""
  }
}

M.tabufline = {
  n = {
    -- cycle through buffers
    ["<leader>k"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["<leader>j"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
  },
}

M.telescope = {
    n = {
        ["<leader>gr"] = { "<cmd> Telescope lsp_references <CR>", "Open references"},
        ["<leader>fd"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Search through symbols"},
    },
}

return M
