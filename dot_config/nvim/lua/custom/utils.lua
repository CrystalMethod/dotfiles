P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

local M = {}

M.notify = function(title, level, message)
  local notify_options = {
    title = title,
    timeout = 2000,
  }
  require('notify')(message, level, notify_options)
end

M.create_notify = function(title, level)
  return function(message)
    M.notify(title, level, message)
  end
end

M.create_dir = function(path)
  local present = vim.fn.isdirectory(path)
  if present == 1 then return end

  vim.fn.mkdir(path)
end

M.is_ts_lsp_attached = function()
  local lsp_clients = vim.lsp.buf_get_clients()
  for _, value in ipairs(lsp_clients) do
    if value.name == 'tsserver' then return true end
  end
  return false
end

-- copied from here: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
M.async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(bufnr, 'textDocument/formatting', vim.lsp.util.make_formatting_params({}), function(err, res, ctx)
    if err then
      local err_msg = type(err) == 'string' and err or err.message
      vim.notify('formatting: ' .. err_msg, vim.log.levels.WARN)
      return
    end

    -- don't apply results if buffer is unloaded or has been modified
    if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, 'modified') then return end

    if res then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or 'utf-16')
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('silent noautocmd update')
      end)
    end
  end)
end

return M
