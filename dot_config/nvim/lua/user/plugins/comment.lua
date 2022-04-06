local comment = require('Comment')

comment.setup({

  opleader = {
    line = "gc",
    block = "gb",
  },

  mappings = {
    basic = true,

    extra = true,

    extended = true,
  },

  toggler = {
    line = "gcc",

    block = "gcb",
  },

  pre_hook = nil,

  post_hook = nil,

  ignore = nil,

})
