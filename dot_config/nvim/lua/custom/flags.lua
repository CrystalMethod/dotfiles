local config = require('custom.config')
local utils = require('custom.utils')

local notify_toggle = utils.create_notify('Flag toggled', 'info')

local M = {}

M.format_on_save = config.format_on_save
M.enable_list_chars = config.enable_list_chars
M.enable_diagnostic = true

M.toggle_format_on_save = function()
  M.format_on_save = not M.format_on_save
  notify_toggle('Toggled format_on_save to ' .. tostring(M.format_on_save))
end

M.toggle_list_chars = function()
  M.enable_list_chars = not M.enable_list_chars
  vim.opt.list = M.enable_list_chars
  notify_toggle('Toggled enable_list_chars to ' .. tostring(M.enable_list_chars))
end

M.toggle_diagnostic = function()
  M.enable_diagnostic = not M.enable_diagnostic
  notify_toggle('Toggled enable_diagnostic to ' .. tostring(M.enable_diagnostic))
  -- hide and show to rerender text
  vim.diagnostic.hide()
  vim.diagnostic.show()
end

return M
