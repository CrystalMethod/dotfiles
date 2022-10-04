local M = {}

M.config = function()

  -- GitSigns
  lvim.builtin.gitsigns.opts._threaded_diff = true
  lvim.builtin.gitsigns.opts._extmark_signs = true
  lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time> · <summary>"

  -- IndentBlankline
  require("user.indent_blankline").config()
end

  -- Toggleterm
  -- =========================================
  lvim.builtin.terminal.active = true
  lvim.builtin.terminal.execs = {}
  lvim.builtin.terminal.autochdir = true
  lvim.builtin.terminal.open_mapping = nil
  lvim.builtin.terminal.size = vim.o.columns * 0.4
  lvim.builtin.terminal.on_config_done = function()
    M.create_terminal(2, "<c-\\>", 20, "float")
    M.create_terminal(3, "<A-0>", vim.o.columns * 0.4, "vertical")
  end

--- Create a new toggleterm
---@param num number the terminal number must be > 1
---@param keymap string the keymap to toggle the terminal
---@param size number the size of the terminal
---@param direction string can be 'float','vertical','horizontal'
M.create_terminal = function(num, keymap, size, direction)
  local terms = require "toggleterm.terminal"
  local ui = require "toggleterm.ui"
  local dir = vim.loop.cwd()
  vim.keymap.set({ "n", "t" }, keymap, function()
    local term = terms.get_or_create_term(num, dir, direction)
    ui.update_origin_window(term.window)
    term:toggle(size, direction)
  end, { noremap = true, silent = true })
end

return M
