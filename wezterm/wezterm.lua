local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'OneDark (base16)'

config.font = wezterm.font {
  family = 'MesloLGS Nerd Font',
}
config.font_size = 12

config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 7,
  bottom = 7,
}
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = 'NeverPrompt'

config.check_for_updates = false

config.enable_tab_bar = false
tab_bar_at_bottom = true
use_fancy_tab_bar = false

config.hyperlink_rules = {
  {
    regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
    format = '$1',
    highlight = 1,
  },
}

return config
