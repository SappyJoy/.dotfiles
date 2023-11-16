-- local on_attach = require("plugins.configs.lspconfig").on_attach
local utils = require "core.utils" 
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd" }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = function (client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            utils.load_mappings("lspconfig", { buffer = bufnr })

            if client.server_capabilities.signatureHelpProvider then
                require("nvchad.signature").setup(client)
            end

            if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
                client.server_capabilities.semanticTokensProvider = nil
            end

            -- client.resolved_capabilities.document_formatting = false
            -- client.resolved_capabilities.document_range_formatting = false

            -- require 'illuminate'.on_attach(client)
        end,--attach,

        capabilities = capabilities,
    }
end

--
-- lspconfig.pyright.setup { blabla}
