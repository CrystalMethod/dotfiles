local cmp = require("cmp")
local lspkind = require("lspkind")

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

cmp.setup({

    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "emoji" },
    }, {
        { name = "buffer" },
    }),

    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                buffer = "[BUF]",
                cmdline = "[CMD]",
                cmp_git = "[GIT]",
                cmp_tabnine = "[TBN]",
                emoji = "[EMJ]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                path = "[PATH]",
                spell = "[SPELL]",
                treesitter = "[TREE]",
                luasnip = "[SNIP]",
            },
        }),
    },
    documentation = { border = "rounded" },
    experimental = { native_menu = false, ghost_text = false },

})


