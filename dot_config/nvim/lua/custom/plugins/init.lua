local M = {}

M.user = {

  -- telescope related plugins
  -- see this https://github.com/NvChad/NvChad/issues/1255
  ['nvim-telescope/telescope.nvim'] = {
    module = 'telescope',
  },
  ['nvim-telescope/telescope-file-browser.nvim'] = {},
  ['nvim-telescope/telescope-symbols.nvim'] = {},
  ['nvim-telescope/telescope-ui-select.nvim'] = {},
  ['nvim-telescope/telescope-project.nvim'] = {},
  ['LinArcX/telescope-env.nvim'] = {},
  ['nvim-telescope/telescope-fzf-native.nvim'] = { run = 'make' },

  -- LSP Related Plugins
  ['neovim/nvim-lspconfig'] = {
    config = function()
      require('plugins.configs.lspconfig')
      require('custom.plugins.lspconfig')
    end,
  },

  ['b0o/schemastore.nvim'] = {},

  ['jose-elias-alvarez/null-ls.nvim'] = {
    config = function()
      require('custom.plugins.null-ls')
    end,
  },

  ['simrat39/symbols-outline.nvim'] = {
    after = 'nvim-lspconfig',
    config = function()
      require('custom.plugins.symbols-outline')
    end,
  },

  ['glepnir/lspsaga.nvim'] = {
    config = function()
      require('custom.plugins.lspsaga')
    end,
  },

  -- treesitter related plugins
  ['nvim-treesitter/playground'] = {
    after = 'nvim-treesitter',
  },
  ['RRethy/nvim-treesitter-endwise'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-textobjects'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-refactor'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-context'] = {
    after = 'nvim-treesitter',
    config = function()
      require('treesitter-context').setup({})
    end,
  },

    -- cmp related plugins
  ['hrsh7th/cmp-cmdline'] = {
    after = 'cmp-buffer',
  },

  ['lukas-reineke/cmp-rg'] = {
    after = 'cmp-cmdline',
  },

  -- Other
  ['editorconfig/editorconfig-vim'] = {},
  ['rcarriga/nvim-notify'] = {
    config = function()
      require('custom.plugins.notify')
    end,
  },

  ['folke/which-key.nvim'] = {
    disable = false,
    config = function()
      require('plugins.configs.whichkey')
      require('custom.plugins.whichkey').setup()
    end,
  },

  ['echasnovski/mini.nvim'] = {
    branch = 'stable',
    config = function()
      require('custom.plugins.mini')
    end,
  },

  ['ggandor/lightspeed.nvim'] = {},

  ['L3MON4D3/LuaSnip'] = {
    config = function()
      require('plugins.configs.others').luasnip()
      require('custom.plugins.snip')
    end,
  },

  ['tpope/vim-fugitive'] = {},

  ['towolf/vim-helm'] = {},

  ['CrystalMethod/codestats.nvim'] = {},

}

M.remove = {
  'NvChad/nvterm',
}

M.override = {
  ['kyazdani42/nvim-tree.lua'] = require('custom.plugins.nvim_tree'),
  ['nvim-treesitter/nvim-treesitter'] = require('custom.plugins.treesitter'),
  ['williamboman/mason.nvim'] = require('custom.plugins.mason'),
  ['nvim-telescope/telescope.nvim'] = require('custom.plugins.telescope'),
  ['folke/which-key.nvim'] = require('custom.plugins.whichkey').options(),
  ['lewis6991/gitsigns.nvim'] = require('custom.plugins.gitsigns'),

  ['hrsh7th/nvim-cmp'] = function()
    local cmp = require('cmp')
    return require('custom.plugins.cmp-config')(cmp)
  end,
}

return M
