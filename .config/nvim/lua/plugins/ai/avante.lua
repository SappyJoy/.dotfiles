return {
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
      -- render-markdown is now configured globally in plugins/lang/markdown.lua
      'MeanderingProgrammer/render-markdown.nvim',
    },
    priority = 1000,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = 'openrouter_gemini_2',
      providers = {
        -- Custom Providers (formerly 'vendors')
        openrouter_gemini_2 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.0-flash-exp:free',
          disable_tools = true,
          extra_request_body = {
            max_completion_tokens = 65536,
          },
        },
        openrouter_gemini_2_thinking = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.0-flash-thinking-exp:free',
          disable_tools = true,
          extra_request_body = {
            max_completion_tokens = 65536,
          },
        },
        openrouter_deepseek_r1_ditill = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'deepseek/deepseek-r1-distill-llama-70b:free',
          disable_tools = true,
          extra_request_body = {
            max_completion_tokens = 65536,
          },
        },
        openrouter_deepseek_r1 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'deepseek/deepseek-r1:free',
          disable_tools = true,
          extra_request_body = {
            max_completion_tokens = 65536,
          },
        },
        openrouter_gemini_2_5 = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          timeout = 800000000,
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'google/gemini-2.5-pro-exp-03-25:free',
          disable_tools = true,
          extra_request_body = {
            max_completion_tokens = 65536,
          },
        },
        -- Disabling default providers
        vertex_claude = { hide_in_model_selector = true },
        copilot = { hide_in_model_selector = true },
        openai = { hide_in_model_selector = true },
        claude = { hide_in_model_selector = true },
        gemini = { hide_in_model_selector = true },
        cohere = { hide_in_model_selector = true },
        vertex = { hide_in_model_selector = true },
        bedrock = { hide_in_model_selector = true },
        ['openai-gpt-4o-mini'] = { hide_in_model_selector = true },
        aihubmix = { hide_in_model_selector = true },
        ['aihubmix-claude'] = { hide_in_model_selector = true },
        ['claude-opus'] = { hide_in_model_selector = true },
        ['claude-haiku'] = { hide_in_model_selector = true },
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
}
