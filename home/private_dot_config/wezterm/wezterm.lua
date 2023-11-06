local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder() then
    config = wezterm.config_builder()
end

-- base config
config.send_composed_key_when_left_alt_is_pressed = true
config.use_dead_keys = true

config.color_scheme = "Catppuccin Frappe"
config.hide_tab_bar_if_only_one_tab = true

return config
