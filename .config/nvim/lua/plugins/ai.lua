return {
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
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
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
          file_types = { 'Avante' },
        },
        ft = { 'Avante' },
      },
    },
    priority = 1000,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- provider = 'openai',
      -- -- add any opts here
      provider = 'openrouter_gemini_2',
      -- disable all default providers
      vertex_claude = {
        hide_in_model_selector = true,
      },
      copilot = {
        hide_in_model_selector = true,
      },
      openai = {
        hide_in_model_selector = true,
      },
      claude = {
        hide_in_model_selector = true,
      },
      gemini = {
        hide_in_model_selector = true,
      },
      cohere = {
        hide_in_model_selector = true,
      },
      vertex = {
        hide_in_model_selector = true,
      },
      bedrock = {
        hide_in_model_selector = true,
      },
      ['openai-gpt-4o-mini'] = {
        hide_in_model_selector = true,
      },
      aihubmix = {
        hide_in_model_selector = true,
      },
      ['aihubmix-claude'] = {
        hide_in_model_selector = true,
      },
      ['claude-opus'] = {
        hide_in_model_selector = true,
      },
      ['claude-haiku'] = {
        hide_in_model_selector = true,
      },
      vendors = {
        openrouter_gemini_2 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.0-flash-exp:free',
          disable_tools = true,
          max_completion_tokens = 65536,
        },
        openrouter_gemini_2_thinking = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.0-flash-thinking-exp:free',
          disable_tools = true,
          max_completion_tokens = 65536,
        },
        openrouter_deepseek_r1_ditill = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'deepseek/deepseek-r1-distill-llama-70b:free',
          disable_tools = true,
          max_completion_tokens = 65536,
        },
        openrouter_deepseek_r1 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'deepseek/deepseek-r1:free',
          -- model = 'google/gemini-2.5-pro-exp-03-25:free',
          disable_tools = true,
          max_completion_tokens = 65536,
        },
        openrouter_gemini_2_5 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.5-pro-exp-03-25:free',
          disable_tools = true,
          max_completion_tokens = 65536,
        },
      },
      windows = {
        position = 'right', -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 50, -- default % based on available width
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
          start_insert = true, -- Start insert mode when opening the ask window
          border = 'rounded',
          ---@type "ours" | "theirs"
          focus_on_apply = 'ours', -- which diff to focus after applying
        },
      },
      file_selector = {
        provider = 'telescope',
        provider_opts = {}, -- You can add Telescope-specific options here if needed
      },
    },
    build = 'make',
  },
  {
    'GeorgesAlkhouri/nvim-aider',
    cmd = { 'Aider', 'AiderOpen' },
    dependencies = {
      { 'folke/snacks.nvim', version = '>=2.24.0' },
      -- Optional integration: if you have neo-tree, this adds mappings
      'nvim-neo-tree/neo-tree.nvim',
    },
    keys = {
      { '<leader>a/', '<cmd>Aider toggle<cr>', desc = 'Toggle Aider' },
      { '<leader>as', '<cmd>Aider send<cr>', desc = 'Send to Aider', mode = { 'n', 'v' } },
      { '<leader>ac', '<cmd>Aider command<cr>', desc = 'Aider Commands' },
      { '<leader>ab', '<cmd>Aider buffer<cr>', desc = 'Send Buffer' },
      { '<leader>a+', '<cmd>Aider add<cr>', desc = 'Add File' },
      { '<leader>a-', '<cmd>Aider drop<cr>', desc = 'Drop File' },
      { '<leader>ar', '<cmd>Aider add readonly<cr>', desc = 'Add Read-Only' },
      { '<leader>aR', '<cmd>Aider reset<cr>', desc = 'Reset Session' },
    },
    opts = {
      aider_cmd = 'aider',
      args = {
        '--no-auto-commits',
        '--pretty',
      },
      auto_reload = true,
      theme = {
        user_input_color = '#86B300',       -- ayu string
        tool_output_color = '#399EE6',      -- ayu entity
        tool_error_color = '#E65050',       -- ayu error
        tool_warning_color = '#FA8D3E',     -- ayu warning
        assistant_output_color = '#A37ACC', -- ayu constant
        completion_menu_color = '#5C6166',  -- ayu fg
        completion_menu_bg_color = '#F3F4F5', -- ayu panel_bg
        completion_menu_current_color = '#5C6166', -- ayu fg
        completion_menu_current_bg_color = '#D3E1F5', -- ayu selection_bg
      },
      config = {
        os = { editPreset = 'nvim-remote' },
        gui = { nerdFontsVersion = '3' },
      },
      win = {
        wo = { winbar = 'Aider' },
        style = 'nvim_aider',
        position = 'right',
      },
    },
    config = function(_, opts)
      require('nvim_aider').setup(opts)

      -- Neo-tree integration setup
      -- Note: If you already configure neo-tree in another file, 
      -- you may want to move this mapping logic there.
      local has_neotree, _ = pcall(require, 'neo-tree')
      if has_neotree then
        require('nvim_aider.neo_tree').setup {
          window = {
            mappings = {
              ['+'] = { 'nvim_aider_add', desc = 'add to aider' },
              ['-'] = { 'nvim_aider_drop', desc = 'drop from aider' },
              ['='] = { 'nvim_aider_add_read_only', desc = 'add read-only to aider' },
            },
          },
        }
      end
    end,
  },
}
