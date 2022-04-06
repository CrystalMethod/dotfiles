--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
packer.startup({
  function(use)

    ----------------------------------------------------------------------------
    -- NOTE: Packer and speed ups {{{
    ----------------------------------------------------------------------------
    use({ "wbthomason/packer.nvim" })
    use({ "lewis6991/impatient.nvim" })
    -- Profile startup time
    use({
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
      opt = true,
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: must have {{{
    ----------------------------------------------------------------------------
    use({ "nvim-lua/plenary.nvim" })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: UI and Beautify {{{
    ----------------------------------------------------------------------------
    -- improve default neovim UI
    use({
      "stevearc/dressing.nvim",
      after = "telescope.nvim",
      config = function()
        require("user.plugins.dressing")
      end,
    })

    ----------------------------------------------------------------------------
    -- NOTE: notifications {{{
    ----------------------------------------------------------------------------
    use({
      "rcarriga/nvim-notify",
      module = "vim",
      config = function()
        require("user.plugins.notify")
      end,
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: colorschemes {{{
    ----------------------------------------------------------------------------
    use({
      "ellisonleao/gruvbox.nvim",
      requires = {
        "rktjmp/lush.nvim"
      },
      config = function()
        require("user.plugins.gruvbox")
      end
    })

    use({ "dracula/vim" })
    use({ "folke/tokyonight.nvim" })
    use({ "rebelot/kanagawa.nvim" })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: icons {{{
    ----------------------------------------------------------------------------
    use({
      'yamatsum/nvim-nonicons',
      requires = {
        'kyazdani42/nvim-web-devicons'
      },
      config = function()
        require('user.plugins.devicons')
      end,
      event = { 'BufRead' },
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: general {{{
    ----------------------------------------------------------------------------
    -- highlighting of todo comments
    use({
      'folke/todo-comments.nvim',
      config = function()
        require('user.plugins.todo-comments')
      end,
      requires = { 'nvim-lua/plenary.nvim' },
    })

    -- which-key
    use({
      'folke/which-key.nvim',
      config = function()
        require('user.plugins.which-key')
      end,
    })

    -- session management
    use({
      'rmagatti/session-lens',
      after = { 'telescope.nvim', 'auto-session' },
      cmd = { 'SearchSession' },
      requires = {
        {
        'rmagatti/auto-session',
        event = { 'VimEnter' },
        config = function()
          require('user.plugins.auto-session')
        end,
        },
        {
        'nvim-telescope/telescope.nvim'
        },
      },
      config = function()
        require('user.plugins.session-lens')
      end,
    })

    -- Colorizer for showing the colors
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('user.plugins.colorizer')
      end,
      cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer' },
    })
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: FUZZY SEARCH {{{
    ---------------------------------------------------------------------------
    -- telescope.nvim
    use({
      'nvim-telescope/telescope.nvim',
      cmd = { 'Telescope' },
      config = function()
        require('user.plugins.telescope')
      end,
      requires = {
        { 'nvim-lua/plenary.nvim', after = 'telescope.nvim' },
        {
          'nvim-telescope/telescope-frecency.nvim',
          requires = { 'tami5/sqlite.lua' },
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('frecency')
          end,
        },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('fzf')
          end,
        },
        {
          'xiyaowong/telescope-emoji.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('emoji')
          end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('smart_history')
          end,
        },
        {
          'nvim-telescope/telescope-ui-select.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('ui-select')
          end,
        },
        {
         'camgraff/telescope-tmux.nvim',
          requires = { 'norcalli/nvim-terminal.lua' },
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('tmux')
          end,
        },
        {
          'nvim-telescope/telescope-hop.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('hop')
          end,
        },
      },
    })
    -- }}}
    ---------------------------------------------------------------------------

    -- delete buffers without distubing layout
    use({
      'kazhala/close-buffers.nvim',
      cmd = { 'BDelete' },
      config = function()
        require('user.plugins.close-buffers')
      end,
    })

    -- commenting
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('user.plugins.comment')
      end,
    })

    ---------------------------------------------------------------------------
    -- NOTE: VERSION CONTROL STYSTEM {{{
    ---------------------------------------------------------------------------
    -- git worktree
    use({
      'ThePrimeagen/git-worktree.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('git_worktree')
      end,
    })

    -- gitsigns in lua
    use({
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      event = { 'BufRead' },
      config = function()
        require('user.plugins.gitsigns')
      end,
    })
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: STATUS AND TAB LINES {{{
    ---------------------------------------------------------------------------
    -- lualine.nvim
    use({
      'nvim-lualine/lualine.nvim',
      config = function()
        require('user.plugins.lualine')
      end,
    })

    -- bufferline
    use({
      'akinsho/nvim-bufferline.lua',
      event = { 'BufRead' },
      config = function()
        require('user.plugins.bufferline')
      end,
    })
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: Format {{{
    ---------------------------------------------------------------------------

    -- indentlines in neovim
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("user.plugins.indent-blankline")
        end,
        event = { "BufRead" },
    })
    -- }}}
    ------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: LSP {{{
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: lspconfig {{{
    ---------------------------------------------------------------------------
    use({
        "neovim/nvim-lspconfig",
        -- ft = vim.g.enable_lspconfig_ft,
        config = function()
            require("user.plugins.lsp")
        end,
        requires = {
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("user.plugins.fidget")
                end,
                after = "nvim-lspconfig",
            },
            {
                "onsails/lspkind-nvim",
                after = "nvim-lspconfig",
            },
            {
                "hrsh7th/nvim-cmp",
                config = function()
                    require("user.plugins.nvim-cmp")
                end,
                event = { "InsertEnter", "CmdlineEnter" },
                requires = {
                    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                    { "hrsh7th/cmp-cmdline", after = "nvim-cmp", event = { "CmdlineEnter" } },
                    { "hrsh7th/cmp-emoji", after = "nvim-cmp", keys = { "i", ":" } },
                    { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
                    { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
                    { "hrsh7th/cmp-path", after = "nvim-cmp" },
                    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                    { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
                },
            },
 --       {
 --         'ray-x/lsp_signature.nvim',
 --         config = function()
 --           require('user.plugins.signature')
 --         end,
 --         after = 'nvim-lspconfig',
 --       },
 --       {
 --         'onsails/diaglist.nvim',
 --         after = 'nvim-lspconfig',
 --         cmd = { 'DiagList', 'DiagListAll' },
 --       },
            { "williamboman/nvim-lsp-installer" },
            {
                "folke/lua-dev.nvim",
                ft = "lua",
                after = { "nvim-lspconfig" },
            },
        },
    })

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    -- }}}
    ---------------------------------------------------------------------------
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: Treesitter {{{
    ---------------------------------------------------------------------------
    use({
      'nvim-treesitter/nvim-treesitter',
      ft = vim.g.enable_treesitter_ft,
      config = function()
        require('user.plugins.treesitter')
      end,
      run = ':TSUpdate',
      requires = {
        {
          'nvim-treesitter/nvim-treesitter-textobjects',
          after = 'nvim-treesitter',
        },
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle' },
          after = { 'nvim-treesitter' },
        },
        {
          'JoosepAlviste/nvim-ts-context-commentstring',
          after = { 'nvim-treesitter', 'Comment.nvim' },
        },
      },
    })

    -- annotations using treesitter
    use({
      'danymat/neogen',
      cmd = { 'Neogen' },
      after = { 'nvim-treesitter' },
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('user.plugins.neogen')
      end,
    })

    use({
      'lewis6991/spellsitter.nvim',
      after = { 'nvim-treesitter' },
      config = function()
        require('user.plugins.spellsitter')
      end,
    })

    -- }}}
    ---------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Explorers {{{
    ------------------------------------------------------------------------
    -- nvim-tree explorer
    use({
      'kyazdani42/nvim-tree.lua',
      cmd = {
        'NvimTreeToggle',
        'NvimTreeRefresh',
        'NvimTreeFindFile',
      },
      config = function()
        require('user.plugins.nvim-tree')
      end,
    })

    -- }}}
    ------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: TERMINAL {{{
    ---------------------------------------------------------------------------
    -- Float Terminal
    use({
      "akinsho/nvim-toggleterm.lua",
      config = function()
        require('user.plugins.toggleterm')
      end,
      keys = { "n", [[<C-\>]] },
      cmd = {
        "ToggleTerm",
        "ToggleTerm1",
        "ToggleTerm2",
        "ToggleTerm3",
        "ToggleTerm4",
      },
    })
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- NOTE: misc {{{
    ---------------------------------------------------------------------------
    -- CodeStats
    use({
      'https://gitlab.com/code-stats/code-stats-vim',
      config = function()
        require('user.plugins.codestats')
      end
    })

    -- 
    use({ 'towolf/vim-helm' })

    use({
      'glepnir/dashboard-nvim',
      config = function()
        require('user.plugins.dashboard')
      end
    })

    use({
      "folke/zen-mode.nvim",
      config = function()
        require("user.plugins.zen-mode")
      end
    })

    use({
      "folke/twilight.nvim",
      config = function()
        require('user.plugins.twilight')
      end
    })

    -- }}}
    ---------------------------------------------------------------------------


--  use { 'airblade/vim-rooter' }
--  use { 'christoomey/vim-tmux-navigator' }
--  use { 'farmergreg/vim-lastplace' }
--  use { 'tpope/vim-commentary' }
--  use { 'tpope/vim-repeat' }
--  use { 'tpope/vim-surround' }
--  use { 'tpope/vim-eunuch' } -- Adds :Rename, :SudoWrite
--  use { 'tpope/vim-unimpaired' } -- Adds [b and other handy mappings
--  use { 'tpope/vim-sleuth' } -- Indent autodetection with editorconfig support
--  use { 'jessarcher/vim-heritage' } -- Automatically create parent dirs when saving
--  use { 'nelstrom/vim-visual-star-search' }
--
--  use { 'towolf/vim-helm' }
--
--  use({
--    "editorconfig/editorconfig-vim",
--  })
--
--  use {
--    'junegunn/fzf.vim',
--    requires = { 'junegunn/fzf' }
--  }
--
--  use {
--    'tpope/vim-projectionist',
--   config = function()
--      require('user.plugins.projectionist')
--    end
-- }
--
--  use {
--    'miyakogi/conoline.vim',
--    config = function()
--      require('user.plugins.conoline')
--    end
--  }
--
--  use {
--    'nvim-telescope/telescope.nvim',
--    requires = {
--      { 'kyazdani42/nvim-web-devicons' },
--      { 'ryanoasis/vim-devicons' },
--      { 'nvim-lua/popup.nvim' },
--      { 'nvim-lua/plenary.nvim' },
--      { 'nvim-telescope/telescope-fzy-native.nvim' },
--      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
--      { 'nvim-telescope/telescope-project.nvim' },
--      { 'ThePrimeagen/git-worktree.nvim' },
--      { 'nvim-telescope/telescope-live-grep-raw.nvim' },
--    },
--    config = function()
--      require('user.plugins.telescope')
--    end
--  }
--
--  use { 'fannheyward/telescope-coc.nvim' }
--  use {
--    'fhill2/telescope-ultisnips.nvim',
--    config = function()
--      require('user.plugins.ultisnips')
--    end
--  }
--
--  use {
--    'nvim-treesitter/nvim-treesitter',
--    run = ':TSUpdate',
--    requires = {
--      'nvim-treesitter/playground',
--      'nvim-treesitter/nvim-treesitter-textobjects',
--      'lewis6991/spellsitter.nvim',
--      'JoosepAlviste/nvim-ts-context-commentstring',
--    },
--    config = function()
--      require('user.plugins.treesitter')
--      require('spellsitter').setup()
--    end
--  }
--
--  -- git
--  use 'tpope/vim-fugitive'
--  use {
--    'junegunn/gv.vim',
--    requires = {
--      'tpope/vim-fugitive'
--    }
--  }
--
--  use {
--    'lewis6991/gitsigns.nvim',
--    requires = 'nvim-lua/plenary.nvim',
--    config = function()
--      require('gitsigns').setup { sign_priority = 20 }
--    end,
--  }
--
--  use {
--    'akinsho/nvim-bufferline.lua',
--    config = function()
--      require('user.plugins.nvim-bufferline')
--    end
--  }
--
--  use {
--    'neoclide/coc.nvim',
--    branch = 'release',
--    config = function()
--      require('user.plugins.coc-nvim')
--    end
--  }
--
--  use { 'SirVer/ultisnips' }
--
  end})

-- }}}
-------------------------------------------------------------------------------
-- }}}
-------------------------------------------------------------------------------

-- vim:foldmethod=marker
