vim.api.nvim_set_var('projectionist_heuristics', {
  ['*.java'] = {
    ['src/main/java/*.java'] = {
      ['type'] = 'source',
      ['alternate'] = 'src/test/java/{}.java'
    },
    ['src/test/java/*.java'] = {
      ['type'] = 'test',
      ['alternate'] = 'src/test/java/{}.java'
    }
  }
})
