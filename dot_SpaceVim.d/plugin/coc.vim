let g:coc_global_extensions = [
      \ 'coc-java',
      \ 'coc-explorer',
      \]

let g:coc_config_home = '~/.SpaceVim.d/'

let g:indentLine_fileTypeExclude = ['coc-explorer', 'startify']

nmap <silent><F3> :CocCommand explorer<CR>
