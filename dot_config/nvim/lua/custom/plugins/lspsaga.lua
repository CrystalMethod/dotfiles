local ok, saga = pcall(require, 'lspsaga')

if not ok then return end

saga.init_lsp_saga({
  finder_request_timeout = 20000, -- long timeout for big projects
  code_action_icon = " ",
  code_action_lightbulb = {
    enable = true,
    sign = false,
    enable_in_insert = true,
    sign_priority = 20,
    virtual_text = true,
  },
})
