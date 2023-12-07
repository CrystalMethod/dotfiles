-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local util = require("lazyvim.util")
local wk = require("which-key")

wk.register({
  ["<leader>D"] = { name = "+docker" },
  ["<leader>m"] = { name = "+markdown" },
})

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- cursor stays in the middle of the screen when scrolling
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<leader>Dl", function()
  util.terminal.open({ "lazydocker" }, { cwd = util.root.get() })
end, { desc = "Lazydocker" })

keymap.set("n", "<leader>Dc", function()
  util.terminal.open({ "ctop" }, { cwd = util.root.get() })
end, { desc = "Ctop" })

keymap.set("n", "<leader>mg", "<cmd>Glow<CR>", { desc = "Markdown Preview (Glow)" })
