local ok, notify = pcall(require, 'notify')

if not ok then return end

-- require("base46").load_highlight "notify"

local options = {
  stages = 'fade_in_slide_out',
  timeout = 2000,
}

notify.setup(options)
vim.notify = notify
