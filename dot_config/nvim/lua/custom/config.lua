local M = {}

-- enable mouse see :h mouse
M.mouse = 'nv'
M.format_on_save = true

M.list = {
  enable = false, -- enable or disable listchars
  chars = 'eol:↵,tab:>·,trail:~,extends:>,precedes:<', -- which list chars to show
}

M.nvim_tree = {
   enable_git_icons = true,
}

return M
