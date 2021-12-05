let g:coc_global_extensions = [
      \ 'coc-java',
      \ 'coc-explorer',
      \ 'coc-snippets',
      \ 'coc-yaml'
      \]

let g:coc_config_home = '~/.SpaceVim.d/'

let g:indentLine_fileTypeExclude = ['coc-explorer', 'startify']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction


nmap <silent><F3> :CocCommand explorer<CR>
