local ok, null_ls = pcall(require, 'null-ls')

if not ok then return end

local code_actions = null_ls.builtins.code_actions
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
-- local hover = null_ls.builtins.hover

local sources = {
  ----------- lua --------------
  formatting.stylua,

  ----------- js/ts --------------
  code_actions.eslint_d,
  -- code_actions.prettierd,
  -- formatting.prettier,
  formatting.eslint_d,
  -- diagnostics.eslint_d,

  ----------- bash --------------
  code_actions.shellcheck,
  formatting.shfmt,
  diagnostics.shellcheck,

  ----------- golang -------------
  formatting.gofumpt,
  formatting.goimports,
  formatting.golines,
  diagnostics.golangci_lint,
  diagnostics.revive,
  diagnostics.staticcheck,

  ----------- other -------------
  -- code_actions.gitsigns,
  diagnostics.vale,
  completion.spell.with({
    filetypes = { 'markdown', 'text' },
  }),
}

local on_attach = function(client, bufnr)
  -- require('custom.autocmd').format_on_save(client, bufnr)
end

null_ls.setup({ sources = sources, on_attach = on_attach })
