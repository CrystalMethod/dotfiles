return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 100,
        -- virt_text_pos = "eol",
      },
    },
    keys = {
      { "<leader>ub", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toogle Git line blame" },
    },
  },
}
