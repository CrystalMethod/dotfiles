local M = {}

M.set_hop_keymaps = function()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "s", ":HopChar2MW<cr>", opts)
  vim.api.nvim_set_keymap("n", "S", ":HopWordMW<cr>", opts)
  vim.api.nvim_set_keymap(
    "n",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "n",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
  )
end

M.set_lightspeed_keymaps = function()
  vim.cmd [[
nmap s <Plug>Lightspeed_s
nmap S <Plug>Lightspeed_S
nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
  ]]
end

local function set_harpoon_keymaps()
  lvim.keys.normal_mode["<C-Space>"] = "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>"
  lvim.keys.normal_mode["tu"] = "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>"
  lvim.keys.normal_mode["te"] = "<cmd>lua require('harpoon.term').gotoTerminal(2)<CR>"
  lvim.keys.normal_mode["cu"] = "<cmd>lua require('harpoon.term').sendCommand(1, 1)<CR>"
  lvim.keys.normal_mode["ce"] = "<cmd>lua require('harpoon.term').sendCommand(1, 2)<CR>"
  lvim.builtin.which_key.mappings["a"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", " Add Mark" }
  lvim.builtin.which_key.mappings["<leader>"] = {
    "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
    " Harpoon",
  }

  local whk_status, whk = pcall(require, "which-key")
  if not whk_status then
    return
  end
  whk.register {
    ["<leader>1"] = { "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", " goto1" },
    ["<leader>2"] = { "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", " goto2" },
    ["<leader>3"] = { "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", " goto3" },
    ["<leader>4"] = { "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", " goto4" },
  }
end

M.config = function()
  lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"

  lvim.keys.normal_mode["<esc><esc>"] = "<cmd>nohlsearch<cr>"

  if lvim.builtin.harpoon.active then
    set_harpoon_keymaps()
  end

  if lvim.builtin.cheat.active then
    lvim.builtin.which_key.mappings["?"] = { "<cmd>Cheat<CR>", " Cheat.sh" }
  end
end

return M
