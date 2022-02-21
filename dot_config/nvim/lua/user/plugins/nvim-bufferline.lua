require("bufferline").setup{
    options = {
        numbers = "none",        
        close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
        diagnostics = "nvim_lsp"
    }
}

local map = vim.api.nvim_set_keymap

map('n', '<leader>gB', ':BufferLinePick<CR>', { noremap = true, silent = true })
map('n', '<leader>gC', ':BufferLinePickClose<CR>', { noremap = true, silent = true })
map('n', '<leader>gb1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
map('n', '<leader>gb2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
map('n', '<leader>gb3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
map('n', '<leader>gb4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
map('n', '<leader>gb5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })

map('n', ']b', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', '[b', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
