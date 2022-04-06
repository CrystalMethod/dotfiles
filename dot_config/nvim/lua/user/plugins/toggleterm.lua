local toggleterm = require('toggleterm')

toggleterm.setup({
  size = 30,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = "float",
  float_opts = { border = "curved" },
})
