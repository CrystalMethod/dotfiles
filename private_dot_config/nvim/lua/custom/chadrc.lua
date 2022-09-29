local M = {}

local plugins = require("custom.plugins")

-- local override_conf = require('custom.plugins.override_config')
-- local user_conf = require('custom.plugins.user_config')

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "vscode_dark" },
}

M.plugins = {
  	remove = plugins.remove,
	  override = plugins.override,
	  user = plugins.user
  -- -- Override default config of a plugin
  -- override = {
  --   ["NvChad/ui"] = override_conf.ui,
  --   ["nvim-treesitter/nvim-treesitter"] = override_conf.treesitter,
  --   ["williamboman/mason.nvim"] = override_conf.mason
  -- },
  -- remove = {},
  -- user = {
  --   ["folke/which-key.nvim"] = { disable = false },
  --   ["goolord/alpha-nvim"] = { disable = false },
  --   ["rcarriga/nvim-notify"] = { config = user_conf.notify },
  --   ["neovim/nvim-lspconfig"] = {
  --     config = function()
  --       require "plugins.configs.lspconfig"
  --       require "custom.plugins.lsp"
  --     end,
  --  },
  --   ["jose-elias-alvarez/null-ls.nvim"] = {
  --     after = "nvim-lspconfig",
  --     config = function()
  --       require "custom.plugins.null-ls"
  --     end
  --   },
  --   ["nvim-treesitter/playground"] = {
  --     config = function()
  --       require "nvim-treesitter.configs".setup {
  --         playground = {
  --           enable = true,
  --           disable = {},
  --           updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
  --           persist_queries = false, -- Whether the query persists across vim sessions
  --           keybindings = {
  --             toggle_query_editor = 'o',
  --             toggle_hl_groups = 'i',
  --             toggle_injected_languages = 't',
  --             toggle_anonymous_nodes = 'a',
  --             toggle_language_display = 'I',
  --             focus_language = 'f',
  --             unfocus_language = 'F',
  --             update = 'R',
  --             goto_node = '<cr>',
  --             show_help = '?',
  --           },
  --         }
  --       }
  --     end
  --   },
  --   ["ahmedkhalf/project.nvim"] = { cmd = "Telescope", config = user_conf.project },
  --   ["ray-x/lsp_signature.nvim"] = { after = "nvim-lspconfig", config = user_conf.lsp_signature },
  --   ["stevearc/aerial.nvim"] = { cmd = "AerialToggle", config = user_conf.aerial }
  -- }
}

M.mappings = require("custom.mappings")

return M
