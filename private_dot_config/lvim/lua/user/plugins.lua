local M = {}

M.config = function()

  lvim.plugins = {
    -- Themes
    { "ellisonleao/gruvbox.nvim" },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle"
    },
  }

end

return M
