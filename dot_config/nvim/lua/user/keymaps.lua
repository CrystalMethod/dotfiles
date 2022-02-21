local keymap = require 'lib.utils'.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', '<leader>k', ':nohlsearch<CR>')
keymap('n', '<leader>Q', ':bufdo bdelete<CR>')

