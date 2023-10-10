return {
  {
    "earthly/earthly.vim",
    ft = "Earthfile",
  },
  {
    "CrystalMethod/codestats.nvim",
    event = "User AstroFile",
  },
  {
    "axkirillov/easypick.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Easypick",
    config = function()
      local base_branch = "develop"
      local easypick = require("easypick")
      easypick.setup({
        pickers = {
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
          },
          {
            name = "git_conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      })
    end,
  },
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
