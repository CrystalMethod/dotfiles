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

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                buffer = "[BUF]",
                cmdline = "[CMD]",
                cmp_git = "[GIT]",
                emoji = "[EMJ]",
                luasnip = "[SNIP]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                path = "[PATH]",
                spell = "[SPELL]",
                treesitter = "[TREE]",
            },
        }),
    },
    documentation = { border = "rounded" },
    experimental = { native_menu = false, ghost_text = false },

})


