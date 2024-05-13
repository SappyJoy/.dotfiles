return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1, -- High priority is needed if you will use `autoremap()`
    config = function()
      require('langmapper').setup {
        ---@type boolean Add mapping for every CTRL+ binding or not.
        map_all_ctrl = true,
        ---@type string[] Modes to `map_all_ctrl`
        ---Here and below each mode must be specified, even if some of them extend others.
        ---E.g., 'v' includes 'x' and 's', but must be listed separate.
        ctrl_map_modes = { 'n', 'o', 'i', 'c', 't', 'v' },
        ---@type boolean Wrap all keymap's functions (nvim_set_keymap etc)
        hack_keymap = true,
        ---@type string[] Usually you don't want insert mode commands to be translated when hacking.
        ---This does not affect normal wrapper functions, such as `langmapper.map`
        disable_hack_modes = { 'i' },
        ---@type table Modes whose mappings will be checked during automapping.
        automapping_modes = { 'n', 'v', 'x', 's' },
        ---@type string Standart English layout (on Mac, It may be different in your case.)
        default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~abcdefghijklmnopqrstuvwxyz,.;'[]`]],
        ---@type string[] Names of layouts. If empty, will handle all configured layouts.
        use_layouts = {},
        ---@type table Fallback layouts
        layouts = {
          ---@type table Fallback layout item. Name of key is a name of language
          ru = {
            ---@type string Name of your second keyboard layout in system.
            ---It should be the same as result string of `get_current_layout_id()`
            id = 'com.apple.keylayout.RussianWin',
            ---@type string Fallback layout to translate. Should be same length as default layout
            layout = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯБЮЖЭХЪËфисвуапршолдьтщзйкыегмцчнябюжэхъё',
            ---@type string if you need to specify default layout for this fallback layout
            default_layout = nil,
          },
        },
        os = {
          -- Darwin - Mac OS, the result of `vim.loop.os_uname().sysname`
          Linux = {
            ---Function for getting current keyboard layout on your OS
            ---Should return string with id of layout
            ---@return string
            get_current_layout_id = function()
              local cmd = 'xkb-switch'
              if vim.fn.executable(cmd) then
                local output = vim.split(vim.trim(vim.fn.system(cmd)), '\n')
                return output[#output]
              end
            end,
          },
        },
      }
    end,
  },
}
