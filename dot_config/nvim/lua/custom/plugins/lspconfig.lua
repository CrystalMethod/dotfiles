local ok, lsp = pcall(require, 'lspconfig')

if not ok then return end

-- custom.plugins.lspconfig
local on_attach = require('plugins.configs.lspconfig').on_attach
local capabilities = require('plugins.configs.lspconfig').capabilities

local servers = {
  'ansiblels',
  'bashls',
  'cssls',
  'dockerls',
  'emmet_ls',
  'eslint',
  'groovyls',
  'gopls',
  'html',
  'jdtls',
  'jsonls',
  'kotlin_language_server',
  'lemminx',
  'marksman',
  'pyright',
  'sumneko_lua',
  'terraformls',
  'tsserver',
  'yamlls',
}

for _, plugin in ipairs(servers) do
  lsp[plugin].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    }
  })
end
