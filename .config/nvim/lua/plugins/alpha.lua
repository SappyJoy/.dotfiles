-- lua/plugins/alpha.lua
return {
  'goolord/alpha-nvim',
  event = 'VimEnter', -- Load on startup
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- For icons
    'nvim-lua/plenary.nvim', -- Often a dependency for telescope actions
    'nvim-telescope/telescope.nvim',
    'folke/zen-mode.nvim', -- For Zen Mode button
    'epwalsh/obsidian.nvim', -- For Obsidian button
    -- Add other dependencies if button commands require them (e.g., persistence for sessions)
    -- 'folke/persistence.nvim',
  },
  opts = function()
    -- Load alpha and the dashboard theme
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Attempt to load icons, provide fallbacks if module doesn't exist
    local icons = {}
    local icons_ok, icons_mod = pcall(require, 'sap.icons')
    if icons_ok and icons_mod.startup then
      icons = icons_mod.startup
    else
      -- Define simple fallback icons here if needed
      icons = {
        find_files = ' ',
        notes = '󰠮 ',
        zen = '󰒡 ',
        new_file = ' ',
        recent_files = ' ',
        sessions = '󱂬 ',
        find_text = '󰍉 ',
        lazy = '󰒲 ',
        quit = ' ',
      }
      -- Consider adding a vim.notify here instead of print if you prefer
      -- print("Warning: sap.icons module not found or failed to load. Using fallback icons for Alpha.")
    end

    local typewriter_art = [[
████████╗██╗   ██╗██████╗ ███████╗██╗    ██╗██████╗ ██╗████████╗███████╗██████╗ 
╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗
   ██║    ╚████╔╝ ██████╔╝█████╗  ██║ █╗ ██║██████╔╝██║   ██║   █████╗  ██████╔╝
   ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ██║███╗██║██╔══██╗██║   ██║   ██╔══╝  ██╔══██╗
   ██║      ██║   ██║     ███████╗╚███╔███╔╝██║  ██║██║   ██║   ███████╗██║  ██║
   ╚═╝      ╚═╝   ╚═╝     ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    ]]
    -- Footer Quote
    local footer_quote = '"Quiet people have the loudest minds." - Stephen King'

    -- Configure the dashboard sections
    -- Assign the table directly, don't use vim.split()
    dashboard.section.header.val = vim.split(typewriter_art, '\n')
    dashboard.section.header.opts.hl = 'AlphaHeader' -- Use custom HL group (defined later)

    -- Define Buttons: { key, description, command }
    dashboard.section.buttons.val = {
      dashboard.button('f', icons.find_files .. ' Find file', '<cmd>Telescope find_files<CR>'),
      dashboard.button('o', icons.notes .. ' Obsidian Notes', '<cmd>ObsidianQuickSwitch<CR>'), -- Changed key to 'o'
      dashboard.button('z', icons.zen .. ' Zen Mode', '<cmd>ZenMode<CR>'),
      dashboard.button('n', icons.new_file .. ' New file', '<cmd>ene <bar> startinsert<CR>'), -- Starts in insert mode
      dashboard.button('r', icons.recent_files .. ' Recent files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('g', icons.find_text .. ' Find text', '<cmd>Telescope live_grep<CR>'),
      -- dashboard.button("s", icons.sessions .. " Sessions", "<cmd>lua require('persistence').load()<CR>"), -- Uncomment if using persistence
      dashboard.button('l', icons.lazy .. ' Lazy', '<cmd>Lazy<CR>'),
      dashboard.button('q', icons.quit .. ' Quit', '<cmd>qa<CR>'), -- Use :qa to quit all splits/tabs
    }
    -- Apply common highlight groups to all buttons
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaButtons' -- Highlight for the description text
      button.opts.hl_shortcut = 'AlphaShortcut' -- Highlight for the key shortcut (e.g., 'f')
    end

    -- Footer value should be a table of strings
    dashboard.section.footer.val = { footer_quote } -- <<< CORRECTED HERE
    dashboard.section.footer.opts.hl = 'AlphaFooter' -- Use custom HL group

    -- Adjust layout - Add padding, remove default MRU/Session sections if not wanted
    dashboard.opts.layout = {
      { type = 'padding', val = 2 }, -- Padding at the top
      dashboard.section.header,
      { type = 'padding', val = 2 }, -- Padding below header
      dashboard.section.buttons,
      { type = 'padding', val = 1 }, -- Padding below buttons
      dashboard.section.footer,
      { type = 'padding', val = 1 }, -- Padding at the bottom
    }

    -- Ensure alpha uses the custom highlight groups
    return dashboard -- Return the modified dashboard config object
  end,

  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    require('alpha').setup(dashboard.opts)

    vim.api.nvim_create_autocmd('User', {
      once = true,
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
