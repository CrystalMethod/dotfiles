return {
  { "gitsigns.nvim", opts = { preview_config = { border = BORDER_STYLE } } },
  { "mason.nvim", opts = { ui = { border = BORDER_STYLE } } },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      require("lspconfig.ui.windows").default_options.border = BORDER_STYLE
      vim.diagnostic.config({ float = { border = BORDER_STYLE } })
      return opts
    end,
  },
}
