local M = {}

M.config = function()

  lvim.plugins = {
    -- Themes
    { "ellisonleao/gruvbox.nvim" },
    { "folke/tokyonight.nvim" },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "RishabhRD/nvim-cheat.sh",
      requires = "RishabhRD/popfix",
      config = function()
        vim.g.cheat_default_window_layout = "vertical_split"
      end,
      opt = true,
      cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
      keys = "<leader>?",
      disable = not lvim.builtin.cheat.active,
    },
    {
      "ThePrimeagen/harpoon",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      disable = not lvim.builtin.harpoon.active,
    },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("user.fidget_spinner").config()
      end,
    },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle"
    },
  }

end

return M
