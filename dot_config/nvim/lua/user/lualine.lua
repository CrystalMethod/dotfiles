local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local status_gps_ok, gps = pcall(require, "nvim-gps")
if not status_gps_ok then
  return
end

local function clock()
  return " " .. os.date("%H:%M")
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local fileformat
do
  local table = {
    unix = 'LF',
    dos = 'CRLF',
    mac = 'CR',
  }

  local function display()
    return table[vim.bo.fileformat]
  end

  fileformat = {
    display,
  }
end

local nvim_gps = function()
  local gps_location = gps.get_location()
  if gps_location == "error" then
    return ""
  else
    return gps.get_location()
  end
end

lualine.setup({
  options = {
    theme = "gruvbox-material",
    component_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "Outline", "fugitiveblame" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      { "filename", path = 1, shorting_target = 40, symbols = { modified = "[]", readonly = "[]" }},
      { nvim_gps, cond = gps.is_available }
    },
    lualine_x = { diff, spaces, "encoding", fileformat, "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location"},
  },
  extensions = { "fugitive", "nvim-tree", "quickfix", "toggleterm", "fzf" },
})
