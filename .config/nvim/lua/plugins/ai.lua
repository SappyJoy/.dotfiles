return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
          yaml = true,
        },
      }
    end,
  },
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {}
    end,
  },
  {
    'jackMort/ChatGPT.nvim',
    event = 'VeryLazy',
    config = function()
      require('chatgpt').setup {
        api_key_cmd = 'pass show api/tokens/openai',
        openai_params = {
          model = 'o1-preview',
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        },
      }
      local wk = require 'which-key'
      wk.add {
        {
          { '<leader>cg', '<cmd>ChatGPT<cr>', desc = 'Open ChatGPT' },
          { '<leader>cs', '<cmd>ChatGPTActAs<cr>', desc = 'ChatGPT Act As' },
        },
      }
      wk.add {
        {
          mode = { 'n', 'v' },
          { '<leader>cc', '<cmd>ChatGPTCompleteCode<cr>', desc = 'ChatGPT Complete Code' },
          { '<leader>ce', '<cmd>ChatGPTEditWithInstructions<cr>', desc = 'ChatGPT Edit With Instructions' },
          { '<leader>cr', group = 'ChatGPT Run' },
          { '<leader>crt', '<cmd>ChatGPTRun translate<cr>', desc = 'ChatGPT Run translate' },
          { '<leader>cra', '<cmd>ChatGPTRun add_tests<cr>', desc = 'ChatGPT Run add_tests' },
          { '<leader>crg', '<cmd>ChatGPTRun grammar_correction<cr>', desc = 'ChatGPT Run grammar_correction' },
          { '<leader>crs', '<cmd>ChatGPTRun summarize<cr>', desc = 'ChatGPT Run summarize' },
          { '<leader>crf', '<cmd>ChatGPTRun fix_bugs<cr>', desc = 'ChatGPT Run fix_bugs' },
          { '<leader>cre', '<cmd>ChatGPTRun explain_code<cr>', desc = 'ChatGPT Run explain_code' },
          { '<leader>crd', '<cmd>ChatGPTRun docstring<cr>', desc = 'ChatGPT Run docstring' },
          { '<leader>cro', '<cmd>ChatGPTRun optimize_code<cr>', desc = 'ChatGPT Run optimize_code' },
          { '<leader>crR', '<cmd>ChatGPTRun roxygen_edit<cr>', desc = 'ChatGPT Run roxygen_edit' },
          { '<leader>crc', '<cmd>ChatGPTRun complete_code<cr>', desc = 'ChatGPT Run complete_code' },
          { '<leader>crr', '<cmd>ChatGPTRun code_readability_analysis<cr>', desc = 'ChatGPT Run code_readability_analysis' },
          { '<leader>crk', '<cmd>ChatGPTRun keywords<cr>', desc = 'ChatGPT Run keywords' },
        },
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'folke/trouble.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    priority = 1000,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- provider = 'openai',
      -- -- add any opts here
      provider = 'openrouter',
      vendors = {
        openrouter = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          -- model = 'deepseek/deepseek-r1-distill-llama-70b:free',
          model = 'deepseek/deepseek-r1:free',
          -- model = 'google/gemini-2.0-flash-thinking-exp:free',
          disable_tools = true,
        },
      },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = 'right', -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = 'center', -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = '> ',
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = 'rounded',
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = false, -- Start insert mode when opening the ask window
          border = 'rounded',
          ---@type "ours" | "theirs"
          focus_on_apply = 'ours', -- which diff to focus after applying
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
