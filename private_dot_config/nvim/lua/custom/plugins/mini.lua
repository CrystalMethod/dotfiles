-- --------------- mini.ai -------------------------
local mini_ai = require('mini.ai')
local spec_treesitter = mini_ai.gen_spec.treesitter

mini_ai.setup({
  _lines = 500,
  custom_textobjects = {
    -- a = mapped to args by mini.ai
    f = spec_treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
    u = spec_treesitter({
      a = '@class.outer',
      i = '@class.outer', -- only outer is available
    }),
    j = spec_treesitter({
      a = '@loop.outer',
      i = '@loop.inner',
    }),
    o = spec_treesitter({
      a = '@block.outer',
      i = '@block.inner',
    }),
    r = spec_treesitter({
      a = '@parameter.outer',
      i = '@parameter.inner',
    }),
    i = spec_treesitter({
      a = '@conditional.outer',
      i = '@conditional.inner',
    }),
    m = spec_treesitter({
      a = '@comment.outer',
      i = '@comment.outer', -- only outer is available
    }),
    c = spec_treesitter({
      a = '@call.outer',
      i = '@call.inner',
    }),
    d = spec_treesitter({
      a = '@statement.outer',
      i = '@statement.inner',
    }),
    -- scopename
    -- frame
    -- attribute
  },
})

-----------------mini.surround---------------------

local mini_surround = require('mini.surround')
mini_surround.setup({
  mappings = {
    add = 'ys', -- Add surrounding in Normal and Visual modes
    delete = 'ds', -- Delete surrounding
    find_left = '[s', -- Find surrounding (to the left)
    find = ']s', -- Find surrounding (to the right)
    highlight = '', -- Highlight surrounding
    replace = 'cs', -- Replace surrounding
    update_n_lines = '', -- Update `n_lines`
  },
})
