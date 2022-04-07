local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("user.plugins.lsp.lsp-installer")
require("user.plugins.lsp.diagnostics").init()
-- require("user.plugins.lsp.handlers")
-- require("core.lsp.null-ls")

