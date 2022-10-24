-- Neovim
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox"
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
require("user.neovim").config()

-- Customization
lvim.builtin.lua_dev = { active = true } -- change this to enable/disable folke/lua_dev
lvim.builtin.cheat = { active = false } -- enable/disable cheat.sh ilvim.builtin.cheat = { active = false } -- enable/disable cheat.sh integrationntegration
lvim.builtin.harpoon = { active = true } -- use the harpoon plugin
lvim.builtin.cursorline = { active = false } -- use a bit fancier cursorline
lvim.builtin.motion_provider = "lightspeed" -- change this to use different motion providers ( hop or lightspeed )
lvim.builtin.editorconfig = { active = true } -- enable/disable editorconfig
lvim.builtin.dressing = { active = false } -- enable to override vim.ui.input and vim.ui.select with telescope

lvim.builtin.indentlines.active = true
-- lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "html",
  "java",
  "javascript",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "python",
  "rust",
  "tsx",
  "typescript",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

if lvim.builtin.cursorline.active then
  lvim.lsp.document_highlight = false
end

require("user.builtin").config()

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "jdtls",
})
-- Additional Plugins
require("user.plugins").config()

-- Additional keybindings
require("user.keybindings").config()
