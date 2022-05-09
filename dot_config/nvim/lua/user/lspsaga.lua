local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then
  return
end

lspsaga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  infor_sign = '',
  border_style = 'round',
}
