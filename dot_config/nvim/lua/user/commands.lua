----------------------------------------------------------------------
-- NOTE: telescope commands {{{
----------------------------------------------------------------------

vim.api.nvim_create_user_command("TelescopeNotifyHistory", function()
    require("telescope").extensions.notify.notify()
end, {})

-- }}}
----------------------------------------------------------------------


----------------------------------------------------------------------
-- NOTE: buffer commands {{{
----------------------------------------------------------------------

vim.api.nvim_create_user_command("BufferCloseAllButCurrent", function()
    vim.cmd([[:bd|e#|bd#"]])
end, {})

vim.api.nvim_create_user_command("Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]], {})

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: neovim utility commands {{{
----------------------------------------------------------------------

vim.api.nvim_create_user_command("ToggleBackground", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, {})

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: open help in new tab {{{
----------------------------------------------------------------------

vim.api.nvim_create_user_command("HelpTab", function()
  vim.cmd([[tab help]])
end, { nargs = "?", complete = "help" })

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
