return {
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    dependencies = {
      "plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "rcasia/neotest-java",
      "rouge8/neotest-rust",
      "thenbe/neotest-playwright",
    },
    opts = {
      config = function(_, opts)
        table.insert(opts.adapters, require("neotest-rust"))
        table.insert(opts.adapters, require("neotest-java"))
      end,
    },
  },
}
