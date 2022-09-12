return function()
  local actions = require('telescope.actions')
  return {
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      },
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      oldfiles = {
        initial_mode = 'normal',
      },
      buffers = {
        ignore_current_buffer = true,
        initial_mode = 'normal',
        sort_mru = true,
        mappings = {
          n = {
            ['x'] = actions.delete_buffer,
          },
        },
      },
      lsp_definitions = {
        initial_mode = 'normal',
        theme = 'cursor',
      },
      diagnostics = {
        initial_mode = 'normal',
      },
      project = { -- TODO: this is not working
        initial_mode = 'normal',
        theme = 'ivy',
      },
    },
    defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
      file_ignore_patterns = { 'node_modules', '.git', '.terraform', '%.jpg', '%.png' },
      mappings = {
        i = {
          ['<esc>'] = actions.close,
        },
      },
    },
    extensions_list = { 'themes', 'terms', 'project', 'file_browser', 'ui-select', 'fzf', 'env' },
  }
end
