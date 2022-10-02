local M = {}

M.config = function()
  lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"

  lvim.keys.normal_mode["<esc><esc>"] = "<cmd>nohlsearch<cr>"

  if lvim.builtin.cheat.active then
    lvim.builtin.which_key.mappings["?"] = { "<cmd>Cheat<CR>", " Cheat.sh" }
  end
end

return M
