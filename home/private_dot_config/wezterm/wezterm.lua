-- pull the wezterm api
local wezterm = require("wezterm")

-- variable to hold the config
local config = {}

-- in newer versions of wezterm. use the config_builder
-- which is a more structured way of setting up the config
if wezterm.config_builder() then
  config = wezterm.config_builder()
end

-- change the colorscheme
config.color_scheme = "Catppuccin Frappe"

-- controls whether the tab bar is enabled
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- cursor settings
config.default_cursor_style = "BlinkingUnderline"
config.audible_bell = "Disabled"

-- window transparency
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0

config.warn_about_missing_glyphs = false
config.font = wezterm.font("VictorMono Nerd Font", { weight = "Medium" })
config.font_size = 12
-- config.cell_width = 1.1
config.line_height = 1.1
config.dpi = 96.0

-- keybindings
config.send_composed_key_when_left_alt_is_pressed = true
config.use_dead_keys = true

-- window settings
-- config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"

return config
