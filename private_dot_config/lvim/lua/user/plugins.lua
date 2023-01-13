local M = {}

M.config = function()

  lvim.plugins = {
    -- Themes
    "ellisonleao/gruvbox.nvim",
    { "catppuccin/nvim", name = "catppuccin" },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "folke/todo-comments.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("user.todo_comments").config()
      end,
      event = "BufRead",
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("trouble").setup {
          auto_open = true,
          auto_close = true,
          padding = false,
          height = 10,
          use_diagnostic_signs = true,
        }
      end,
      cmd = "Trouble",
    },
    {
      "ggandor/lightspeed.nvim",
      config = function()
        require("user.lightspeed").config()
      end,
      enabled = lvim.builtin.motion_provider == "lightspeed",
    },
    {
      "phaazon/hop.nvim",
      event = "BufRead",
      config = function()
        require("user.hop").config()
      end,
      enabled = lvim.builtin.motion_provider == "hop",
    },
    {
      "folke/twilight.nvim",
      config = function()
        require("user.twilight").config()
      end,
      event = "BufRead",
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("user.colorizer").config()
      end,
      event = "BufReadPre",
    },
    { "mfussenegger/nvim-jdtls", ft = "java" },
    {
      "folke/zen-mode.nvim",
      config = function()
        require("user.zen").config()
      end,
      event = "BufRead",
    },
    {
      "RishabhRD/nvim-cheat.sh",
      dependencies = "RishabhRD/popfix",
      config = function()
        vim.g.cheat_default_window_layout = "vertical_split"
      end,
      lazy = true,
      cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
      keys = "<leader>?",
      enabled = lvim.builtin.cheat.active,
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      enabled = lvim.builtin.harpoon.active,
    },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "mtdl9/vim-log-highlighting", ft = { "text", "log" }, },
    {
      "yamatsum/nvim-cursorline",
      lazy = true,
      event = "BufWinEnter",
      enabled = lvim.builtin.cursorline.active,
    },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("user.fidget_spinner").config()
      end,
    },
    {
      "editorconfig/editorconfig-vim",
      event = "BufRead",
      enabled = lvim.builtin.editorconfig.active,
    },
    {
      "stevearc/dressing.nvim",
      config = function()
        require("user.dress").config()
      end,
      enabled = lvim.builtin.dressing.active,
      event = "BufWinEnter",
    },
    { "NTBBloodbath/rest.nvim",
      dependencies = "nvim-lua/plenary.nvim"
    },
    { "CrystalMethod/codestats.nvim" },
    { "towolf/vim-helm" },
  }

end

return M
