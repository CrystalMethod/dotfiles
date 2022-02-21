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

  use { 'itchyny/lightline.vim' }
  use { 'towolf/vim-helm' }

  use {
    'tpope/vim-projectionist',
    config = function()
      require('user.plugins.projectionist')
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
    'tpope/vim-fugitive',
    requires = 'tpope/vim-rhubarb',
    cmd = 'G',
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup { sign_priority = 20 }
    end,
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
    branch = 'release'
  }

  use {
    'glepnir/dashboard-nvim',
    config = function()
      require('user.plugins.dashboard')
    end
  }

  use {
    'https://gitlab.com/code-stats/code-stats-vim',
    config = function()
      require('user.plugins.codestats')
    end
  }

end)
