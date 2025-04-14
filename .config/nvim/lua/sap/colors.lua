local colors = require 'ayu.colors'
colors.generate(false) -- Pass `true` to enable mirage
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = colors.comment })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.vcs_added })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.vcs_modified })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.vcs_removed })
vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.guide_active })
vim.api.nvim_set_hl(0, 'CmpNormal', { bg = colors.guide_normal })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#E0E0E0', bold = true })

-- Alpha Highlight Groups (Link to existing ayu-light colors)
vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = colors.accent })   -- Header text color like comments
vim.api.nvim_set_hl(0, 'AlphaButtons', { link = 'String' })    -- Button description text color like strings
vim.api.nvim_set_hl(0, 'AlphaShortcut', { link = 'Type' })     -- Button shortcut key color like types/keywords
vim.api.nvim_set_hl(0, 'AlphaFooter', { link = 'Comment' })   -- Footer text color like comments

vim.cmd.hi 'Comment gui=none'
