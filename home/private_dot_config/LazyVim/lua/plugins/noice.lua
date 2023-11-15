return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- Classic command line position
    -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#classic-cmdline

    -- cmdline = {
    -- 	view = "cmdline",
    -- },

    -- Command line and popup menu together
    -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#display-the-cmdline-and-popupmenu-together

    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
  },
}
