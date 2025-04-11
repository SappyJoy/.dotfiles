local colors = require 'ayu.colors'
colors.generate(false) -- Pass `true` to enable mirage
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = colors.comment })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.vcs_added })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.vcs_modified })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.vcs_removed })
vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.guide_active })
vim.api.nvim_set_hl(0, 'CmpNormal', { bg = colors.guide_normal })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#E0E0E0', bold = true })

vim.cmd.hi 'Comment gui=none'
