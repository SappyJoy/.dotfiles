local colors = require 'ayu.colors'
colors.generate(false) -- Pass `true` to enable mirage
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = colors.comment })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.vcs_added })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.vcs_modified })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.vcs_removed })
vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.guide_active })
