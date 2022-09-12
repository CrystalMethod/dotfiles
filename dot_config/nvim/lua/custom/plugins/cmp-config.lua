return function(cmp)
  cmp.setup.cmdline(':', {
    sources = {
      { name = 'cmdline' },
    },
  })
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
    },
  })
  return {
    mapping = {
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require('luasnip').expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
        else
          fallback()
        end
      end, {
        'i',
        's',
        'c',
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require('luasnip').jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
        else
          fallback()
        end
      end, {
        'i',
        's',
        'c',
      }),
    },
    formatting = {
      format = function(entry, vim_item)
        local icons = require('nvchad_ui.icons').lspkind
        vim_item.kind = string.format('%s %s', icons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          luasnip = '[SNIP]',
          nvim_lsp = '[LSP]',
          buffer = '[BUF]',
          path = '[PATH]',
          rg = '[RG]',
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'buffer', keyword_length = 5 },
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'cmdline' },
      { name = 'rg', keyword_length = 5 },
    },
  }
end
