return {
  {
    'Shatur/neovim-ayu',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      vim.cmd.colorscheme 'ayu-light'
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
