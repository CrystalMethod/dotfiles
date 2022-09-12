local M = {}

M.ensure_installed = {
  'bash',
  'comment',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'gowork',
  'graphql',
  'help',
  'html',
  'http',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'json5',
  'kotlin',
  'lua',
  'make',
  'markdown',
  'pug',
  'python',
  'query',
  'r',
  'regex',
  'rego',
  'rust',
  'scss',
  'sql',
  'toml',
  'typescript',
  'vim',
  'yaml',
}

M.indent = {
  enable = true,
  disable = { 'yaml' },
}

M.autopairs = {
  enable = true,
}

M.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<CR>',
    scope_incremental = '<CR>',
    node_incremental = '<TAB>',
    node_decremental = '<S-TAB>',
  },
}

M.playground = {
  enable = true,
}

M.query_linter = {
  enable = true,
  use_virtual_text = true,
  lint_events = { 'BufWrite', 'CursorHold' },
}

M.endwise = {
  enable = true,
}

M.textobjects = {
  select = {
    enable = false, -- selection is handled by mini.ai plugin
  },

  swap = {
    enable = true,
    swap_next = {
      ['<leader>mr'] = '@parameter.inner',
      ['<leader>mf'] = '@function.outer',
    },
    swap_previous = {
      ['<leader>mR'] = '@parameter.inner',
      ['<leader>mF'] = '@function.outer',
    },
  },

  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']f'] = '@function.outer',
      [']u'] = '@class.outer',
    },
    goto_next_end = {
      [']F'] = '@function.outer',
      [']U'] = '@class.outer',
    },
    goto_previous_start = {
      ['[f'] = '@function.outer',
      ['[u'] = '@class.outer',
    },
    goto_previous_end = {
      ['[F'] = '@function.outer',
      ['[U'] = '@class.outer',
    },
  },
}

M.refactor = {
  highlight_definitions = {
    enable = true,
    -- Set to false if you have an `updatetime` of ~100.
    clear_on_cursor_move = true,
  },
  highlight_current_scope = { enable = false },
  navigate = {
    enable = true,
    keymaps = {
      goto_next_usage = ']*',
      goto_previous_usage = '[#',
    },
  },
}

return M
