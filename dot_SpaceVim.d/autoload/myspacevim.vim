function! myspacevim#before() abort
  let g:spacevim_snippet_engine = 'ultisnips'

  let g:mapleader = ','

  let g:codestats_api_key = 'SFMyNTY.UTNKNWMzUmhiRTFsZEdodlpBPT0jI01UVXlNakk9.v_cWcZn34kYwvFTv-4cxAmBR34_aOliWi0okMJ8pssU'
endfunction

function! myspacevim#after() abort
  highlight Comment cterm=italic gui=italic

  " always show sign column
  set signcolumn=yes

  call EnableNeovimTreeSitter()
  call SetupGit()
endfunction

function SetupGit() abort
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'm'], 'GitMessenger', 'git-messenger', 1)
endfunction

function EnableNeovimTreeSitter() abort
  if exists(":TSModuleInfo")
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()

lua << EOF
require "nvim-treesitter.configs".setup {
  ensure_installed = { "go", "typescript", "java", "javascript", "tsx", "python", "bash", "vim", "lua", "vue", "html", "css", "toml", "json", "yaml", "cmake" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF
  endif
endfunction
