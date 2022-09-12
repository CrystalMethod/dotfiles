local M = {}

M.setup = function()
  local ok, wk = pcall(require, 'which-key')

  if not ok then return end

  wk.register({
    ['<leader>'] = {
      name = '<SPC>',
      c = {
        name = 'code',
      },
      f = {
        name = 'find',
      },
      g = {
        name = 'git',
        h = {
           name = 'hunk'
        }
      },
      p = {
        name = 'packer'
      },
      z = {
        name = 'toggles',
      },
    },
  })
end

M.options = function()
  local opt = {}
  opt.icons = {
      group = ' ',
    }
  return opt
end

return M
