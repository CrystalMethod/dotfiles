vim.g.dashboard_custom_header = {
  '',
  '',
  ' ██████╗██╗      ██████╗ ██╗   ██╗██████╗ ███████╗████████╗ █████╗ ██████╗ ██╗  ██╗',
  '██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝',
  '██║     ██║     ██║   ██║██║   ██║██║  ██║███████╗   ██║   ███████║██████╔╝█████╔╝ ',
  '██║     ██║     ██║   ██║██║   ██║██║  ██║╚════██║   ██║   ██╔══██║██╔══██╗██╔═██╗ ',
  '╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝███████║   ██║   ██║  ██║██║  ██║██║  ██╗',
  ' ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝'
}

vim.g.dashboard_custom_section = {
  a = { description = { '  New file                         ' }, command = ':enew' },
  b = { description = { '  Find file               SPC f f  ' }, command = 'Telescope find_files' },
  c = { description = { '  Recent files            SPC f o  ' }, command = 'Telescope oldfiles' },
  d = { description = { '  Find Word               SPC s a  ' }, command = 'Telescope live_grep' },
  e = { description = { '  Change Theme            SPC o v c' }, command = 'Telescope colorscheme' },
  q = { description = { '  Exit                             ' }, command = ':qa' },
}

vim.g.dashboard_custom_footer = {
    "It costs $0.00 to treat someone with respect.",
}
