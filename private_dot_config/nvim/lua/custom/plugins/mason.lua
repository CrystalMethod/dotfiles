local M = {}

M.ensure_installed = {
  -- cue
  'cuelsp',

  -- lua stuff
  'lua-language-server',
  'stylua',

  -- go
  'gopls',
  'golangci-lint',
  'gofumpt',
  'goimports',
  'golines',
  'revive',
  'staticcheck',

  -- java
  'clang-format',
  'groovy-language-server',
  'jdtls',
  'kotlin-language-server',
  'ktlint',

  -- json
  'jq',
  'json-lsp',

  -- shell
  'bash-language-server',
  'shfmt',
  'shellcheck',

  -- web dev
  'eslint-lsp',
  'eslint_d',
  'prettier',
  'typescript-language-server',

  -- xml
  'lemminx',
  'xmlformatter',

  -- yaml
  'yaml-language-server',
  'yamlfmt',
  'yamllint',

  --other
  'dockerfile-language-server',
  'markdownlint',
  'marksman',
  'vale',
}

return M
