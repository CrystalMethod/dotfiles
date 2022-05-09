local status_ok, notify = pcall(require, "notify")
if not status_ok then
  return
end

notify.setup({
  stages = "fade_in_slide_out",
  on_open = nil,
  on_close = nil,
  render = "default",
  timeout = 175,
  background_colour = "Normal",
  minimum_width = 10,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "🖉",
    WARN = "",
  },
})

