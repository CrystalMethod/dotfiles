"""" tagbar options

let g:tagbar_left = 1
let g:tagbar_compact = 1

"autocmd VimEnter * nested :call tagbar#autoopen(1)
"autocmd FileType c,cpp nested :TagbarOpen
autocmd FileType * nested :call tagbar#autoopen(0)

"nnoremap <leader>a :TagbarToggle<CR>
