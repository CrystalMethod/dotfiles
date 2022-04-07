local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local function on_server_ready(server)
    local opts = {
        on_attach = require("user.plugins.lsp.handlers").on_attach,
        capabilities = require("user.plugins.lsp.handlers").capabilities,
    }
    -- Lua
    if server.name == "sumneko_lua" then
        local sumneko_opts = require("user.plugins.lsp.settings.sumneko_lua")
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    -- Java
    if server.name == "jdtls" then
        local jdtls_opts = require("user.plugins.lsp.settings.jdtls")
        opts = vim.tbl_deep_extend("force", jdtls_opts, opts)
    end

    server:setup(opts)
end

lsp_installer.on_server_ready(on_server_ready)
