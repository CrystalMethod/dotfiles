local config = require('custom.config').nvim_tree

local M = {}

M.ignore_ft_on_setup = {
  'startify',
  'dashboard',
  'alpha',
}

M.git = {
  enable = true,
  ignore = true,
  timeout = 400,
}

M.renderer = {
  icons = {
    show = {
      git = config.enable_git_icons,
    },
    glyphs = {
      git = {
        unstaged = '',
      },
    },
  },
}

M.update_focused_file = {
  enable = true,
  update_root = true,
  ignore_list = { '.git', '.cache', 'help' },
}

M.trash = { cmd = 'trash-put', require_confirm = true }

M.diagnostics = {
  enable = true,
  show_on_dirs = false,
  icons = { hint = '', info = '', warning = '', error = '' },
}

M.view = {
  preserve_window_proportions = true,
}

return M
