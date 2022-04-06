require("nvim-treesitter.configs").setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = { 'NvimTree' },
        additional_vim_regex_highlighting = false,
    },
}
