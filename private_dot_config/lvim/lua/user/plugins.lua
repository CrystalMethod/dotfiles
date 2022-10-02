local M = {}

M.config = function()

  lvim.plugins = {
    -- Themes
    { "ellisonleao/gruvbox.nvim" },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle"
    },
  }

end

return M
