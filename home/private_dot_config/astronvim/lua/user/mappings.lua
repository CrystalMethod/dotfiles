-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
    ["<leader>bN"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<leader>gj"] = { "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
    ["<leader>gk"] = { "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
    ["<leader>gr"] = { "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Git hunk" },
    ["<leader>gR"] = { "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Git buffer" },
    ["<leader>gh"] = false,

    ["<leader>F"] = { name = "󰻿 Focus" },
    ["<leader>Ft"] = { "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
    ["<leader>Fz"] = { "<cmd>ZenMode<cr>", desc = "Toogle Zen Mode" },
    -- ui/ux
    ["<leader>uH"] = { "<cmd>Hardtime toggle<cr>", desc = "Toggle Hardtime" },
    ["<leader>uT"] = false,
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
