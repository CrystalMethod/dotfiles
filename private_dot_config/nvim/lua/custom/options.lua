local opt = vim.opt
local config = require('custom.config')

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.backup = false -- disable a backup file
opt.swapfile = true -- enable swap file creation
opt.dir = vim.fn.stdpath('data') .. '/swp' -- swap file directory
opt.undodir = vim.fn.stdpath('data') .. '/undodir' -- set undo directory
opt.history = 500 -- Use the 'history' option to set the number of lines from command mode that are remembered.
opt.fileencoding = 'utf-8' -- the encoding written to a file
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.mouse = config.mouse
opt.smartcase = true -- smart case
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8 -- The minimal number of columns to scroll horizontally
opt.pumheight = 10 -- pop up menu height
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.foldenable = false -- disable folding; enable with zi; wait for https://github.com/neovim/neovim/pull/17446
opt.foldcolumn = '1'
opt.foldlevelstart = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.listchars = config.list.chars
opt.list = config.list.enable
opt.wildmode = 'full'
opt.completeopt = { 'menuone', 'noselect' } -- mostly just for cmp
opt.incsearch = true -- search as you type
opt.numberwidth = 4 -- set number column width to 4 {default 2}
opt.signcolumn = 'yes' -- always show the sign column, otherwise it would shift the text each time
opt.guifont = 'monospace:h17' -- the font used in graphical neovim applications

vim.cmd('set whichwrap+=<,>,[,],h,l')
vim.cmd([[set iskeyword+=-]])
vim.opt.shortmess:append('c')
vim.cmd('set inccommand=split') -- incremental substitution as explained here https://www.youtube.com/watch?v=sA3z6gsqOuw
vim.cmd('set rnu!') -- set relative line numbers by default

-- treesitter based experimental folding
vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
