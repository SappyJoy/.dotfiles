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
    'folke/persistence.nvim',
  },
  keys = {
    { '<leader>hh', '<Cmd>Alpha<CR>', desc = 'Home' },
  },
  opts = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Icons setup (as before)
    local icons = {}
    local icons_ok, icons_mod = pcall(require, 'sap.icons')
    if icons_ok and icons_mod.startup then
      icons = icons_mod.startup
    else
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
      -- vim.notify("Warning: sap.icons module not found. Using fallback icons for Alpha.", vim.log.levels.WARN)
    end

    -- Header Art (as before)
    --     local typewriter_art = [[
    -- ████████╗██╗   ██╗██████╗ ███████╗██╗    ██╗██████╗ ██╗████████╗███████╗██████╗
    -- ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗
    --    ██║    ╚████╔╝ ██████╔╝█████╗  ██║ █╗ ██║██████╔╝██║   ██║   █████╗  ██████╔╝
    --    ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ██║███╗██║██╔══██╗██║   ██║   ██╔══╝  ██╔══██╗
    --    ██║      ██║   ██║     ███████╗╚███╔███╔╝██║  ██║██║   ██║   ███████╗██║  ██║
    --    ╚═╝      ╚═╝   ╚═╝     ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    --     ]]
    --
--                                                                                                                                                                              
-- 8888888 8888888888 `8.`8888.      ,8' 8 888888888o   8 8888888888 `8.`888b                 ,8' 8 888888888o.    8 8888 8888888 8888888888 8 8888888888   8 888888888o.   
--       8 8888        `8.`8888.    ,8'  8 8888    `88. 8 8888        `8.`888b               ,8'  8 8888    `88.   8 8888       8 8888       8 8888         8 8888    `88.  
--       8 8888         `8.`8888.  ,8'   8 8888     `88 8 8888         `8.`888b             ,8'   8 8888     `88   8 8888       8 8888       8 8888         8 8888     `88  
--       8 8888          `8.`8888.,8'    8 8888     ,88 8 8888          `8.`888b     .b    ,8'    8 8888     ,88   8 8888       8 8888       8 8888         8 8888     ,88  
--       8 8888           `8.`88888'     8 8888.   ,88' 8 888888888888   `8.`888b    88b  ,8'     8 8888.   ,88'   8 8888       8 8888       8 888888888888 8 8888.   ,88'  
--       8 8888            `8. 8888      8 888888888P'  8 8888            `8.`888b .`888b,8'      8 888888888P'    8 8888       8 8888       8 8888         8 888888888P'   
--       8 8888             `8 8888      8 8888         8 8888             `8.`888b8.`8888'       8 8888`8b        8 8888       8 8888       8 8888         8 8888`8b       
--       8 8888              8 8888      8 8888         8 8888              `8.`888`8.`88'        8 8888 `8b.      8 8888       8 8888       8 8888         8 8888 `8b.     
--       8 8888              8 8888      8 8888         8 8888               `8.`8' `8,`'         8 8888   `8b.    8 8888       8 8888       8 8888         8 8888   `8b.   
--       8 8888              8 8888      8 8888         8 888888888888        `8.`   `8'          8 8888     `88.  8 8888       8 8888       8 888888888888 8 8888     `88.
    --     local typewriter_art = [[
    --
    --                                                                   ,,
    -- MMP""MM""YMM                       `7MMF'     A     `7MF'         db   mm
    -- P'   MM   `7                         `MA     ,MA     ,V                MM
    --      MM `7M'   `MF'`7MMpdMAo.  .gP"Ya VM:   ,VVM:   ,V `7Mb,od8 `7MM mmMMmm .gP"Ya `7Mb,od8
    --      MM   VA   ,V    MM   `Wb ,M'   Yb MM.  M' MM.  M'   MM' "'   MM   MM  ,M'   Yb  MM' "'
    --      MM    VA ,V     MM    M8 8M"""""" `MM A'  `MM A'    MM       MM   MM  8M""""""  MM
    --      MM     VVV      MM   ,AP YM.    ,  :MM;    :MM;     MM       MM   MM  YM.    ,  MM
    --    .JMML.   ,V       MMbmmd'   `Mbmmd'   VF      VF    .JMML.   .JMML. `Mbmo`Mbmmd'.JMML.
    --            ,V        MM
    --         OOb"       .JMML.
    --     ]]
    -- local typewriter_art = [[
    -- "                                                                                  ",
    -- "                                                                                  ",
    -- "                      *((##*                                                      ",
    -- "                  /###%%#%&&&%,                           .%((//(/.              ",
    -- "                  #%%&&&&@@@@@@@*                        #%#&%@&%%##%%            ",
    -- "                 &&&@@@@@@@@@@@@@   .**(/(,*,/,*,       &@@@@@@@@@&&%%%*          ",
    -- "                 @@@@@@@@@@&@*                         %@@@@@@@@@@@@&&&&          ",
    -- "                  @@@@%/,               ,                 /@&%@@@@@@@&&&*         ",
    -- "                   &@,                 .                      /%@@@@@@@&.         ",
    -- "                .(..                  ,                         *#@@@@@#          ",
    -- "              .(                                                 .@@@@*           ",
    -- "              #                                                    (              ",
    -- "             ,             *%@%             .@@@@&*                 ,             ",
    -- "          *            /@@@@@@&            @@@@@@@@&                .*           ",
    -- "          ,            @@@@@@@@,   ...  .   .@@@@@@@@@                 /          ",
    -- "          /           @@@@@@/                  *&@@@@@&                           ",
    -- "         /           ,@&@@@.    %@@@@@@@@@,     .#@@@&&                 ,         ",
    -- "         #            (%%%/    *@@@@@@@@@%*      *&%#(*                 /         ",
    -- "         *        .     .           /                   , .,.                     ",
    -- "          .                /                     *                      *         ",
    -- "          *                #.    ./%,%/.      ,%                       /..        ",
    -- "          .,                                                        ,,*  *        ",
    -- "            %*                                 (%%#%%(,          *&*..    ,       ",
    -- "           ,/**#@%,**         ........ ...    #&&&@&&&%%%&(,#@@@@@&##%(%%#,,.     ",
    -- "          .%@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@(@@@@@@&&@@%&%%&&&#@@@@@@@@&&&%(,    ",
    -- "          (%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@&&%&@%&@@@@@@@@@%#,   ",
    -- "        *&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@@@@@@@@&%&&*&@@@@@@&&#.  ",
    -- "        &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@@@@@@@@@&@@@&&(@@@@@@&%* ",
    -- "      .#@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%@@@(@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@##@@@@#.",
    -- "      /@@@@@@@@@@@%%&%@&##%&#%/(@(&#%%###%&%@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/",
    -- "     @@@@@@@@@@%((/((**,.,,,,*,,.,*.*.,*,,,,.. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/",
    -- "    .@@@@@@@@@/.*   .                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(",
    -- ]]


          -- ┌─────────────────────────────────────────────────────────────────┐
          -- │                     ,                                           │
          -- │                     \`-._           __                          │
          -- │                      \\  \-..____,.'  `.                        │
          -- │                       :  )       :      :\                      │
          -- │                        ;'        '   ;  | :                     │
          -- │                        )..      .. .:.`.; :                     │
          -- │                       /::...  .:::...   ` ;                     │
          -- │                       `:o>   /\o_>        : `.                  │
          -- │                      `-`.__ ;   __..--- /:.   \                 │
          -- │                     ==== \_/   ;=====_.':.     ;                │
          -- │                       ,/'`--'...`--....        ;                │
          -- │                            ;                    ;               │
          -- │                        . '                       ;              │
          -- │                      .'     ..     ,      .       ;             │
          -- │                     :       ::..  /      ;::.     |             │
          -- │                    /      `.;::.  |       ;:..    ;             │
          -- │                   :         |:.   :       ;:.    ;              │
          -- │                   :         ::     ;:..   |.    ;               │
          -- │                    :       :;      :::....|     |               │
          -- │                    /\     ,/ \      ;:::::;     ;               │
          -- │                  .:. \:..|    :     ; '.--|     ;               │
          -- │                 ::.  :''  `-.,,;     ;'   ;     ;               │
          -- │              .-'. _.'\      / `;      \,__:      \              │
          -- │              `---'    `----'   ;      /    \,.,,,/              │
          -- │                                 `----`                          │
          -- └─────────────────────────────────────────────────────────────────┘

    local kitty_art = [[
                     ▄▀░░▌
                   ▄▀▐░░░▌
                ▄▀▀▒▐▒░░░▌
     ▄▀▀▄   ▄▄▀▀▒▒▒▒▌▒▒░░▌
    ▐▒░░░▀▄▀▒▒▒▒▒▒▒▒▒▒▒▒▒█
    ▌▒░░░░▒▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄
    ▐▒░░░░░▒▒▒▒▒▒▒▒▒▌▒▐▒▒▒▒▒▀▄
    ▌▀▄░░▒▒▒▒▒▒▒▒▐▒▒▒▌▒▌▒▄▄▒▒▐
   ▌▌▒▒▀▒▒▒▒▒▒▒▒▒▒▐▒▒▒▒▒█▄█▌▒▒▌
 ▄▀▒▐▒▒▒▒▒▒▒▒▒▒▒▄▀█▌▒▒▒▒▒▀▀▒▒▐░░░▄
▀▒▒▒▒▌▒▒▒▒▒▒▒▄▒▐███▌▄▒▒▒▒▒▒▒▄▀▀▀▀
▒▒▒▒▒▐▒▒▒▒▒▄▀▒▒▒▀▀▀▒▒▒▒▄█▀░░▒▌▀▀▄▄
▒▒▒▒▒▒█▒▄▄▀▒▒▒▒▒▒▒▒▒▒▒░░▐▒▀▄▀▄░░░░▀
▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▄▒▒▒▒▄▀▒▒▒▌░░▀▄
▒▒▒▒▒▒▒▒▀▄▒▒▒▒▒▒▒▒▀▀▀▀▒▒▒▄▀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

████████╗██╗   ██╗██████╗ ███████╗██╗    ██╗██████╗ ██╗████████╗███████╗██████╗
╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗
   ██║    ╚████╔╝ ██████╔╝█████╗  ██║ █╗ ██║██████╔╝██║   ██║   █████╗  ██████╔╝
   ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ██║███╗██║██╔══██╗██║   ██║   ██╔══╝  ██╔══██╗
   ██║      ██║   ██║     ███████╗╚███╔███╔╝██║  ██║██║   ██║   ███████╗██║  ██║
   ╚═╝      ╚═╝   ╚═╝     ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    ]]
    -- Footer Quote (as before)
    local footer_quote = '"Quiet people have the loudest minds." - Stephen King'

    -- Configure dashboard sections (as before, with horizontal alignment)
    -- dashboard.section.header.val = vim.split(typewriter_art, '\n')
    dashboard.section.header.val = vim.split(kitty_art, '\n')
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.header.opts.align = 'center'

    dashboard.section.buttons.val = {
      dashboard.button('f', icons.find_files .. ' Find file', '<cmd>Telescope find_files<CR>'),
      dashboard.button('o', icons.notes .. ' Obsidian Notes', '<cmd>ObsidianQuickSwitch<CR>'),
      dashboard.button('z', icons.zen .. ' Zen Mode', '<cmd>ZenMode<CR>'),
      dashboard.button('n', icons.new_file .. ' New file', '<cmd>ene <bar> startinsert<CR>'),
      dashboard.button('r', icons.recent_files .. ' Recent files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('g', icons.find_text .. ' Find text', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('s', icons.sessions .. ' Sessions', "<cmd>lua require('persistence').select()<CR>"),
      dashboard.button('l', icons.lazy .. ' Lazy', '<cmd>Lazy<CR>'),
      dashboard.button('q', icons.quit .. ' Quit', '<cmd>qa<CR>'),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaButtons'
      button.opts.hl_shortcut = 'AlphaShortcut'
    end
    dashboard.section.buttons.opts.align = 'center'

    dashboard.section.footer.val = { footer_quote } -- Ensure it's a table
    dashboard.section.footer.opts.hl = 'AlphaFooter'
    dashboard.section.footer.opts.align = 'center'

    -- Calculate dynamic padding for vertical centering
    -- Fixed padding values *between* sections from the layout below
    local padding_below_header = 2
    local padding_below_buttons = 0
    local padding_below_footer = 1 -- Minimal padding at the very bottom

    -- Calculate content height
    local header_height = #dashboard.section.header.val
    local button_height = #dashboard.section.buttons.val
    local footer_height = #dashboard.section.footer.val

    local total_content_height = header_height + padding_below_header + button_height + padding_below_buttons + footer_height + padding_below_footer

    -- Get window height (use fallback for safety during very early startup)
    local window_height = vim.api.nvim_win_get_height(0)
    if window_height <= 0 then
      window_height = vim.o.lines
    end -- Fallback

    -- Calculate the padding needed above the header
    local top_padding = math.max(1, math.floor((window_height - total_content_height) / 2))

    -- Configure the layout using the calculated top padding
    dashboard.opts.layout = {
      { type = 'padding', val = top_padding }, -- Dynamic top padding
      dashboard.section.header,
      { type = 'padding', val = padding_below_header }, -- Fixed padding below header
      dashboard.section.buttons,
      { type = 'padding', val = padding_below_buttons }, -- Fixed padding below buttons
      dashboard.section.footer,
      { type = 'padding', val = padding_below_footer }, -- Minimal fixed padding at the bottom
    }

    -- Return the modified dashboard config object
    return dashboard
  end,

  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready (as before)
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

    -- Update footer with load stats (as before)
    -- vim.api.nvim_create_autocmd('User', {
    --   once = true,
    --   pattern = 'LazyVimStarted',
    --   callback = function()
    --     local stats = require('lazy').stats()
    --     local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    --     local footer_element = dashboard.section.footer -- Get the footer section object
    --     footer_element.val = { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' } -- Update its value (must be a table)
    --     pcall(vim.cmd.AlphaRedraw) -- Redraw alpha to show the new footer
    --   end,
    -- })
  end,
}
