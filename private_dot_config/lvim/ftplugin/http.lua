local wkstatus_ok, which_key = pcall(require, "which-key")
if not wkstatus_ok then
  return
end

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vopts = {
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  r = {
    name = "Rest",
    r = { "<Plug>RestNvim", "Run request under cursor" },
    p = { "<Plug>RestNvimPreview", "Preview cURL command" },
    l = { "<Plug>RestNvimLast", "Re-run last request" },
  },
}

local vmappings = {
  j = {
    name = "Rest",
    l = { "<Plug>RestNvimLast", "Re-run last request" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
