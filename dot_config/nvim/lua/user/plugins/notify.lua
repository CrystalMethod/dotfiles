local notify = require('notify')

local renderer = require('notify.render')

notify.setup({
  stages = 'fade_in_slide_out',
  timeout = 3000,
  render = function(bufnr, notif, highlights)
    local style = notif.title[1] == '' and 'minimal' or 'default'
    renderer[style](bufnr, notif, highlights)
  end,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "🖉",
    WARN = "",
  },
})
