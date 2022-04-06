local lualine = require('lualine')

lualine.setup({
  options = {
    theme = "auto",
    globalstatus = false,
    section_separators = { left = "", right = "" },
    component_separators = { left = "│", right = "│" },
    -- component_separators = { left = "┆", right = "┆" },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 0 } },
    lualine_x = { "filetype" },
    lualine_z = { "location" },
  },
  extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm", "symbols-outline" },
})
