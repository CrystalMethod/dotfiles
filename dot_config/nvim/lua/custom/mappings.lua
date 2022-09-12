local M = {}

local utils = require('custom.utils')

M.disabled = {
  n = {
    ['<leader>h'] = '', -- unmap new horizontal term mapped by nvchad
    ['<leader>v'] = '', -- unmap new vertical term mapped by nvchad
  },

  v = {
    ['<leader>/'] = '', -- unmap comment mapped by nvchad
  },
}

M.packer = {
  n = {
    ['<leader>pc'] = { '<cmd> PackerCompile <CR>', 'Compile' },
    ['<leader>pi'] = { '<cmd> PackerInstall <CR>', 'Install' },
    ['<leader>ps'] = { '<cmd> PackerSync <CR>', 'Sync' },
    ['<leader>pS'] = { '<cmd> PackerStatus <CR>', 'Status' },
    ['<leader>pu'] = { '<cmd> PackerUpdate <CR>', 'Update' },
  },
}

M.git = {
  n = {
    ['<leader>ga'] = { '<cmd> Gitsigns stage_buffer <CR>', 'stage buffer' },
    ['<leader>ghs'] = { '<cmd> Gitsigns stage_hunk <CR>', 'stage hunk' },
    ['<leader>ghS'] = { '<cmd> Gitsigns undo_stage_hunk <CR>', 'unstage hunk' },
    ['<leader>ghr'] = { '<cmd> Gitsigns reset_hunk <CR>', 'reset hunk' },
    ['<leader>gx'] = { '<cmd> Gitsigns reset_buffer <CR>', 'reset buffer' },
    --[[ ['<leader>gt'] = {
      function()
        require('custom.plugins.toggleterm').lazygit_toggle()
      end,
      'open lazygit',
    }, ]]
  },
}

M.nvimtree = {
  n = { ['<leader>e'] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" } },
}

M.toggles = {
  n = {
    ['<leader>zc'] = { require('custom.flags').toggle_list_chars, 'toggle list chars' },
    ['<leader>zd'] = { require('custom.flags').toggle_diagnostic, 'toggle diagnostic' },
    ['<leader>zf'] = { require('custom.flags').toggle_format_on_save, 'toggle format on save' },
    ['<leader>zl'] = { '<cmd> set rnu! <CR>', 'toggle relative line numbers' },
    ['<leader>zs'] = { '<cmd> Gitsigns toggle_current_line_blame <CR>', 'current git line blame' },
  },
}

return M
