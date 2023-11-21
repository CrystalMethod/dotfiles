return {
  "David-Kunz/gen.nvim",
  commands = { "Gen" },
  keys = {
    { "<leader>G", mode = { "n", "v" }, ":Gen<CR>", desc = "Gen AI+" },
  },
  config = function()
    require("gen").model = "codellama:34b-instruct"
  end,
}
