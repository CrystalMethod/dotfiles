return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        filetypes_include = { "rust" },
        init_options = {
          userLanguages = {
            rust = "html",
          },
        },
        handlers = {
          ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
            vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
          end,
        },
        settings = {
          includeLanguages = {
            typescript = "javascript",
            typescriptreact = "javascript",
          },
          tailwindCSS = {
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },
            experimental = {
              classRegex = {
                [[x-class="([^"]*)]],
                [[class="([^"]*)]],
                [[class: "([^"]*)]],
                '~H""".*class="([^"]*)".*"""',
              },
            },
            validate = true,
          },
        },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = true,
      },
      filetypes = {
        "*", -- all file types
        -- exclude following filetypes
        "!lazy",
        "!TelescopePrompt",
        "!TelescopeResults",
        "!TelescopePreview",
      },
      buftypes = {
        "*", -- All buffer types
        -- exclude following buffer types
        "!alpha",
        "!lazy",
        "!neo-tree",
        "!Outline",
        "!prompt",
        "!Trouble",
      },
    },
  },
}
