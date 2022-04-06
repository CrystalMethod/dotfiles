local telescope = require('telescope')

telescope.load_extension('session-lens')

local actions = require('telescope.actions')

require('session-lens').setup({
  theme_conf = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
})
