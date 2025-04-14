-- lua/plugins/leap.lua
return {
  {
    'ggandor/leap.nvim',
    config = function(_)
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', '<Plug>(leap-anywhere)', { desc = 'Leap to' })
    end,
  },
}
