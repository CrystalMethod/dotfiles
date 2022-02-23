local packer = require 'lib.packer-init'

packer.startup(function(use)
  use { 'wbthomason/packer.nvim' } -- Let packer manage itself

  use { 'airblade/vim-rooter' }
  use { 'christoomey/vim-tmux-navigator' }
  use { 'farmergreg/vim-lastplace' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-eunuch' } -- Adds :Rename, :SudoWrite
  use { 'tpope/vim-unimpaired' } -- Adds [b and other handy mappings
  use { 'tpope/vim-sleuth' } -- Indent autodetection with editorconfig support
  use { 'jessarcher/vim-heritage' } -- Automatically create parent dirs when saving
  use { 'nelstrom/vim-visual-star-search' }

  use { 'towolf/vim-helm' }

  use({
   "editorconfig/editorconfig-vim",
  })

  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf' }
  }

  use {
    'tpope/vim-projectionist',
    config = function()
      require('user.plugins.projectionist')
    end
  }

  use {
    'miyakogi/conoline.vim',
    config = function()
      require('user.plugins.conoline')
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-live-grep-raw.nvim' },
    },
    config = function()
      require('user.plugins.telescope')
    end
  }

  use { 'fannheyward/telescope-coc.nvim' }
  use {
    'fhill2/telescope-ultisnips.nvim',
    config = function()
      require('user.plugins.ultisnips')
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'lewis6991/spellsitter.nvim',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('user.plugins.treesitter')
      require('spellsitter').setup()
    end
  }

  use {
    'ThePrimeagen/git-worktree.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      -- require('user.plugins.git-worktree')
      require('git-worktree').setup{ autopush = false }
    end
  }

  use 'tpope/vim-fugitive'

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup { sign_priority = 20 }
    end,
  }

  use {
    'akinsho/nvim-bufferline.lua',
    config = function()
      require('user.plugins.nvim-bufferline')
    end
  }

  use {
    'ellisonleao/gruvbox.nvim',
    requires = {
      'rktjmp/lush.nvim'
    },
    config = function()
      require('user.plugins.gruvbox')
    end
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      require('user.plugins.coc-nvim')
    end
  }

  use { 'SirVer/ultisnips' }

  use {
    'glepnir/dashboard-nvim',
    config = function()
      require('user.plugins.dashboard')
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons', opt = true
    },
    config = function()
      require('user.plugins.lualine')
    end
  }

  use {
    'https://gitlab.com/code-stats/code-stats-vim',
    config = function()
      require('user.plugins.codestats')
    end
  }

end)
