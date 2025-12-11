return {
  {
    'Shatur/neovim-ayu',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme 'ayu-light'

      -- Custom Highlights (Moved from sap/colors.lua)
      local ok, colors = pcall(require, 'ayu.colors')
      if ok then
        colors.generate(false) -- Pass `true` to enable mirage

        -- Override highlights
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, 'GitSignsCurrentLineBlame', { fg = colors.comment })
        set_hl(0, 'GitSignsAdd', { fg = colors.vcs_added })
        set_hl(0, 'GitSignsChange', { fg = colors.vcs_modified })
        set_hl(0, 'GitSignsDelete', { fg = colors.vcs_removed })
        set_hl(0, 'LineNr', { fg = colors.guide_active })
        set_hl(0, 'CmpNormal', { bg = colors.guide_normal })
        set_hl(0, 'Visual', { bg = '#E0E0E0', bold = true })

        -- Alpha Highlights
        set_hl(0, 'AlphaHeader', { fg = colors.accent })
        set_hl(0, 'AlphaButtons', { link = 'String' })
        set_hl(0, 'AlphaShortcut', { link = 'Type' })
        set_hl(0, 'AlphaFooter', { link = 'Comment' })

        -- C++: Disable the "grey out" of inactive regions (#ifndef) by clearing the semantic comment highlight.
        -- This allows Treesitter syntax highlighting to show through instead.
        set_hl(0, '@lsp.type.comment.cpp', {})

        vim.cmd.hi 'Comment gui=none'
      end
    end,
  },

  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'folke/tokyonight.nvim', priority = 1000 },
  { 'morhetz/gruvbox', priority = 1000 },
  { 'EdenEast/nightfox.nvim', priority = 1000 },
  { 'sainnhe/gruvbox-material', priority = 1000 },
  { 'sainnhe/everforest', priority = 1000 },
  { 'nyoom-engineering/oxocarbon.nvim', priority = 1000 },
  { 'ribru17/bamboo.nvim', priority = 1000 },
  { 'rose-pine/neovim', priority = 1000 },
  { 'navarasu/onedark.nvim', priority = 1000 },
  { 'miikanissi/modus-themes.nvim', priority = 1000 },
  { 'binhtran432k/dracula.nvim', priority = 1000 },
  { 'mofiqul/vscode.nvim', priority = 1000 },
  { 'rmehri01/onenord.nvim', priority = 1000 },
  { 'cocopon/iceberg.vim', priority = 1000 },
  { 'sainnhe/edge', priority = 1000 },
  { 'sonph/onehalf', priority = 1000 },
  { 'rakr/vim-one', priority = 1000 },
  { 'ntbbloodbath/doom-one.nvim', priority = 1000 },
  { 'p00f/alabaster.nvim', priority = 1000 },
  { 'chriskempson/vim-tomorrow-theme', priority = 1000 },
  { 'olimorris/onedarkpro.nvim', priority = 1000 },
  { 'nlknguyen/papercolor-theme', priority = 1000 },
  { 'hzchirs/vim-material', priority = 1000 },
  { 'soft-aesthetic/soft-era-vim', priority = 1000 },

  -- vim.cmd.colorscheme 'ayu-light',
}
