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
      "ThePrimeagen/harpoon",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      disable = not lvim.builtin.harpoon.active,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
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
