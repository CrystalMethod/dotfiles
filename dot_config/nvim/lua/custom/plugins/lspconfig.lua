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

-- Setup Lua runetime path
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

for _, plugin in ipairs(servers) do
  lsp[plugin].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
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
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  })
end
