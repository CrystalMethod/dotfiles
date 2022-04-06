local wk = require('which-key')

vim.o.timeoutlen = 500

local presets = require('which-key.plugins.presets')
presets.objects['a('] = nil
presets.operators['g'] = nil

wk.setup({
  show_help = true,
  triggers = "auto",
  plugins = { spelling = true, marks = true, registers = true },
  key_labels = { ["<leader>"] = "SPC" },
  layout = { spacing = 10 },
})

----------------------------------------------------------------------
-- NOTE: leader key mappings {{{
----------------------------------------------------------------------
local leader_key_maps = {
  ----------------------------------------------------------------------
  -- NOTE: direct mappings {{{
  ----------------------------------------------------------------------
  ["*"] = "vimgrep-under-cursor",
  [":"] = { ":Telescope commands<CR>", "commands" },
  ["<leader>"] = { ":Telescope find_files<CR>", "find-files" },
  ["/"] = { ":Telescope live_grep<CR>", "search-project" },
  ["1"] = { ":ToggleTerm1<CR>", "terminal-1" },
  ["2"] = { ":ToggleTerm2<CR>", "terminal-2" },
  ["3"] = { ":ToggleTerm3<CR>", "terminal-3" },
  ["4"] = { ":ToggleTerm4<CR>", "terminal-4" },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: a is for actions {{{
  ----------------------------------------------------------------------
  ["a"] = {
    ["name"] = "+actions",
    ["b"] = { ":ColorizerToggle<CR>", "toggle-colorizer" },
    ["d"] = { ":ColorizerAttachToBuffer<CR>", "attach-colorizer" },
    -- t.b.d.
    ["f"] = { ":NvimTreeFindFile<CR>", "nvim-tree-find-file" },
    -- t.b.d.
    ["o"] = { ":NvimTreeToggle<CR>", "nvim-tree-toggle" },
    -- t.b.d.
    ["r"] = { ":NvimTreeRefresh<CR>", "nvim-tree-refresh" },
    -- t.b.d
    ["s"] = { ":StartupTime<CR>", "run-startup-time" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: b is for buffers {{{
  ----------------------------------------------------------------------
  ["b"] = {
    ["name"] = "+buffers",
    ["["] = { ":bp<CR>", "prev-buffer" },
    ["]"] = { ":bn<CR>", "next-buffer" },
    ["b"] = { ":Telescope buffers<CR>", "telescope-buffers" },
    ["c"] = { ":vnew<CR>", "new-empty-buffer-vert" },
    ["C"] = { ":BDelete other<CR>", "close-all-but-current" },
    ["d"] = { ":BDelete this<CR>", "delete-buffer" },
    ["D"] = { ":BDelete all<CR>", "delete-all-buffers" },
    ["f"] = { ":bfirst<CR>", "first-buffer" },
    ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "search-buffer-lines" },
    ["L"] = { ":blast<CR>", "first-buffer" },
    ["m"] = { ":delm!<CR>", "delete-marks" },
    -- t.b.d.
    ["r"] = { ":e<CR>", "refresh-buffer" },
    ["R"] = { ":bufdo :e<CR>", "refresh-loaded-buffers" },
    ["s"] = { ":new<CR>", "new-empty-buffer" },
    ["u"] = { ":BDelete nameless<CR>", "delete-nameless-buffers" },
    ["w"] = { ":BDelete all<CR>", "close-buffer-and-window" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: e is for error/warnings using lspconfig {{{
  ----------------------------------------------------------------------
  ["e"] = {
    ["name"] = "+errors/warnings",
    ["a"] = { ":DiagListAll<CR>", "quickfix-diagnostics" },
    ["b"] = { ":DiagList<CR>", "quickfix-buffer-diagnostics" },
    ["l"] = { ":Telescope diagnostics<CR>", "workspace-diagnosticss" },
    ["n"] = { ":LspGotoNextDiagnostic<CR>", "next-diagnosticss" },
    ["p"] = { ":LspGotoPrevDiagnostic<CR>", "prev-diagnosticss" },
    ["v"] = { ":ShowLineDiagnosticInFlot<CR>", "diagnostic-float-preview" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: f is for files {{{
  ----------------------------------------------------------------------
  ["f"] = {
    ["name"] = "+files",
    ["e"] = { ":Telescope file_browser<CR>", "file-browser" },
    ["f"] = { ":Telescope find_files<CR>", "files" },
    ["g"] = { ":Telescope git_files<CR>", "git-files" },
    ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
    ["r"] = { ":Telescope frecency<CR>", "telescope-frecency" },
    ["s"] = { ":w<CR>", "save-buffer" },
    ["S"] = { ":wa<CR>", "save-all-buffers" },
    ["t"] = { ":Telescope filetypes<CR>", "file-types" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: g is for git {{{
  ----------------------------------------------------------------------
  ["g"] = {
    ["name"] = "+git",
    -- t.b.d.
    ["c"] = { ":Telescope git_branches<CR>", "checkout" },
    -- t.b.d.
    ["h"] = {
      ["name"] = "+gitsigns-hunks",
      ["a"] = { ":Gitsigns attach<CR>", "attach" },
      ["b"] = { ":Gitsigns stage_buffer<CR>", "stage-buffer" },
      ["c"] = { ":Gitsigns change_base<CR>", "change-base" },
      ["d"] = { ":Gitsigns diffthis<CR>", "diffthis" },
      ["i"] = { ":Gitsigns reset_buffer_index<CR>", "reset-buffer-index" },
      ["l"] = { ":Gitsigns blame_line<CR>", "blame-line" },
      ["n"] = { ":Gitsigns next_hunk<CR>", "next-hunk" },
      ["p"] = { ":Gitsigns prev_hunk<CR>", "prev-hunk" },
      ["r"] = { ":Gitsigns refresh<CR>", "refresh" },
      ["R"] = { ":Gitsigns reset_buffer<CR>", "reset-buffer" },
      ["s"] = { ":Gitsigns stage_hunk<CR>", "stage-hunk" },
      ["S"] = { ":Gitsigns select_hunk<CR>", "select-hunk" },
      ["u"] = { ":Gitsigns detach<CR>", "detach" },
      ["U"] = { ":Gitsigns detach_all<CR>", "detach-all" },
      ["v"] = { ":Gitsigns preview_hunk<CR>", "preview-hunk" },
      ["x"] = { ":Gitsigns reset_hunk<CR>", "reset-hunk" },
    },
    ["m"] = { ":Gitsigns blame_line<CR>", "blame-line" },
    -- t.b.d.
    ["w"] = {
      ["name"] = "+git-worktree",
      ["c"] = { ":Telescope git_worktree create_git_worktree<CR>", "create-worktree" },
      ["l"] = { ":Telescope git_worktree git_worktrees<CR>", "list-worktrees" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: h is for highlight {{{
  ----------------------------------------------------------------------
  ["h"] = {
    ["name"] = "+highlight",
    ["h"] = { ":TSHighlightCapturesUnderCursor<CR>", "show-highlights-info" },
    ["t"] = {
      ["name"] = "+todo-comments",
      ["q"] = { ":TodoQuickFix<CR>", "todos-quickfix" },
      ["t"] = { ":TodoTelescope<CR>", "todos-telescope" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: o is for telescope.nvim {{{
  ----------------------------------------------------------------------
  ["o"] = {
    ["name"] = "+Telescope",
    ["b"] = {
      ["name"] = "+buffers",
      ["a"] = { ":Telescope lsp_code_actions<CR>", "code-actions" },
      ["b"] = { ":Telescope buffers<CR>", "buffers" },
      -- ["B"] = { ":Telescope tele_tabby list<CR>", "tele-tabby-buffers" },
      ["c"] = { ":Telescope lsp_range_code_actions<CR>", "range-code-actions" },
      ["d"] = { ":Telescope lsp_document_symbols<CR>", "buffer-symbols" },
      ["j"] = { ":Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
      ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "buffer-lines" },
      ["r"] = { ":Telescope lsp_references<CR>", "references" },
      ["p"] = { ":Telescope spell_suggest<CR>", "spell_suggest" },
      ["t"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
    },
    ["e"] = { ":Telescope emoji search<CR>", "emoji-search" },
    ["f"] = {
      ["name"] = "+files",
      -- ["c"] = "dotfiles",
      ["d"] = { ":Telescope find_files theme=dropdown<CR>", "with-dropdown" },
      -- ["e"] = { ":Telescope file_browser<CR>", "file-browser" },
      ["f"] = { ":Telescope find_files<CR>", "find-files" },
      ["g"] = { ":Telescope git_files<CR>", "git-files" },
      ["h"] = { ":Telescope frecency<CR>", "telescope-frecency" },
      ["i"] = { ":Telescope find_files theme=ivy<CR>", "ivy-theme-files" },
      -- ["m"] = { ":Telescope media_files<CR>", "media-files" },
      -- ["n"] = "nvim-config",
      ["o"] = { ":Telescope find_files<CR>", "find-files" },
      ["r"] = { ":Telescope oldfiles<CR>", "recent-files" },
      ["z"] = { ":Telescope filetypes<CR>", "filetypes" },
    },
    ["g"] = {
      ["name"] = "+git",
      ["a"] = { ":Telescope git_commits<CR>", "git-commits" },
      ["b"] = { ":Telescope git_bcommits<CR>", "git-buffer-commits" },
      ["c"] = { ":Telescope git_branches<CR>", "git-branches" },
      ["f"] = { ":Telescope git_files<CR>", "git-files" },
      ["g"] = { ":Telescope git_status<CR>", "git-status" },
      ["s"] = { ":Telescope git_stash<CR>", "git-stash" },
    },
    ["t"] = {
      ["name"] = "+telescope",
      ["b"] = { ":Telescope builtin<CR>", "builtins" },
      ["p"] = { ":Telescope planets<CR>", "planets" },
      ["r"] = { ":Telescope reloader<CR>", "reloaders" },
      ["t"] = { ":Telescope treesitter<CR>", "treesitter" },
      -- ["w"] = "change-background",
    },
    -- ["u"] = { ":Telescope ultisnips ultisnips<CR>", "ultisnips" },
    ["v"] = {
      ["name"] = "+vim",
      [";"] = { ":Telescope commands<CR>", "commands" },
      ["a"] = { ":Telescope autocommands<CR>", "autocommands" },
      ["c"] = { ":Telescope colorscheme<CR>", "colorschemes" },
      ["h"] = { ":Telescope command_history<CR>", "commands-history" },
      ["H"] = { ":Telescope highlights<CR>", "highlights" },
      ["k"] = { ":Telescope keymaps<CR>", "keymaps" },
      ["m"] = { ":Telescope marks<CR>", "marks" },
      ["r"] = { ":Telescope registers<CR>", "vim-registers" },
      ["t"] = { ":Telescope help_tags<CR>", "help-tags" },
      ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
    },
    ["w"] = { ":Telescope grep_string<CR>", "grep-words" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: s is for search {{{
  ----------------------------------------------------------------------
  ["s"] = {
    ["name"] = "+search",
    ["/"] = { ":Telescope command_history<CR>", "history" },
    [":"] = { ":Telescope commands<CR>", "commands" },
    ["a"] = { ":Telescope live_grep<CR>", "live-grep" },
    ["b"] = { ":Telescope buffers<CR>", "buffers" },
    ["c"] = { ":Telescope git_commits<CR>", "commits" },
    ["C"] = { ":Telescope git_bcommits<CR>", "buffer-commits" },
    ["d"] = { ":Telescope git_files<CR>", "git-files" },
    ["f"] = { ":Telescope find_files<CR>", "files" },
    ["F"] = { ":Telescope filetypes<CR>", "file-types" },
    ["g"] = { ":Telescope git_status<CR>", "modified-git-files" },
    ["h"] = { ":Telescope help_tags<CR>", "help-tags" },
    ["H"] = { ":Telescope command_history<CR>", "command-history" },
    ["l"] = { ":Telescope current_buffer_fuzzy_find<CR>", "telescope-buffer-lines" },
    ["m"] = { ":Telescope marks<CR>", "marks" },
    ["M"] = { ":Telescope keymaps<CR>", "keymaps" },
    ["o"] = { ":Telescope oldfiles<CR>", "old-files" },
    ["p"] = { ":Telescope live_grep<CR>", "live-grep" },
    ["r"] = { ":Telescope resume<CR>", "resume-search" },
    ["S"] = { ":Telescope colorscheme<CR>", "color-schemes" },
    ["t"] = { ":Telescope current_buffer_tags<CR>", "buffer-tags" },
    ["T"] = { ":Telescope tags<CR>", "project-tags" },
    ["v"] = { ":Telescope vim_options<CR>", "vim-options" },
    ['"'] = { ":Telescope registers<CR>", "registers" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: S is for sessions {{{
  ----------------------------------------------------------------------
  ["S"] = {
    ["name"] = "+sessions/+workspaces",
    ["l"] = { ":SearchSession<CR>", "search-sessions" },
  },
  -- }}}
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- NOTE: t is for toggle/tabs/terminal {{{
  ----------------------------------------------------------------------
  ["t"] = {
    ["name"] = "+tabs/terminal/toggle",
    ["g"] = {
      ["name"] = "+git",
      ["b"] = { ":Gitsigns toggle_current_line_blame<CR>", "toggle-blame" },
      ["l"] = { ":Gitsigns toggle_linehl<CR>", "toggle-linehl" },
      ["n"] = { ":Gitsigns toggle_numhl<CR>", "toggle-numhl" },
      ["s"] = { ":Gitsigns toggle_signs<CR>", "toggle-signs" },
      ["w"] = { ":Gitsigns toggle_word_diff<CR>", "toggle-word-diff" },
    },
    -- t.b.d.
    ["n"] = {
      ["name"] = "+nvim-tree",
      ["t"] = { ":NvimTreeToggle<CR>", "toggle" },
      ["f"] = { ":NvimTreeFindFile<CR>", "find-file" },
      ["r"] = { ":NvimTreeRefresh<CR>", "refresh" },
    },
  },
  -- }}}
  ----------------------------------------------------------------------
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: local leader key mappings {{{
----------------------------------------------------------------------
local local_leader_key_maps = {
  ----------------------------------------------------------------------
  -- NOTE: buffers  {{{
  ----------------------------------------------------------------------
  ["b"] = {
    ["name"] = "+buffers",
    ["b"] = { ":Telescope buffers<CR>", "buffers" },
    ["m"] = { ":Telescope marks<CR>", "marks" },
--    ["t"] = { ":ReachOpen tabpages<CR>", "tabs" },
  },
  -- }}}
  ----------------------------------------------------------------------
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: visual mode keymaps {{{
----------------------------------------------------------------------
local visual_mode_leader_key_maps = {
  ["r"] = {
    ["name"] = "+refactor",
    ["f"] = { ":ExtractSelectedFunc<CR>", "extract-function" },
    ["r"] = { ":RefactorsList", "refactors-list" },
    ["v"] = { ":DebugPrintVarBelow", "print-var-below" },
    ["V"] = { ":DebugPrintVarAbove", "print-var-above" },
  },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: [ mappings {{{
----------------------------------------------------------------------
wk.register({
  b = { "<Plug>(buf-surf-back)", "buf-surf-back" },
}, { prefix = "[" })

wk.register({
  b = { "<Plug>(buf-surf-forward)", "buf-surf-forward" },
}, { prefix = "]" })
-- }}}
----------------------------------------------------------------------

wk.register(local_leader_key_maps, { prefix = "<localleader>" })
wk.register(leader_key_maps, { prefix = "<leader>" })
wk.register(visual_mode_leader_key_maps, { prefix = "<leader>", mode = "v" })

-- vim:foldmethod=marker
