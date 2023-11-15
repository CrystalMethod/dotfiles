return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.window = vim.tbl_extend("force", opts.window or {}, {
      -- Add border to LSP completion and documentation.
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    })
  end,
}
