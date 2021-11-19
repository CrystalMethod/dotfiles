""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" airline options

""""""" Unicode symbols: NOT NEEDED if "g:airline_powerline_fonts = 1"
"    if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
"    endif
"    let g:airline_symbols.linenr = ''
"    let g:airline_symbols.crypt = ''
"    let g:airline_symbols.paste = 'ρ'
"    let g:airline_symbols.spell = 'Ꞩ'
"    "let g:airline_symbols.spell = 'X'
"    let g:airline_symbols.notexists = '∄'
"    let g:airline_symbols.whitespace = 'Ξ'
"    let g:airline_left_sep = ''
"    let g:airline_left_alt_sep = ''
"    let g:airline_right_sep = ''
"    let g:airline_right_alt_sep = ''
"    let g:airline_symbols.branch = ''
"    let g:airline_symbols.readonly = ''
"    let g:airline_symbols.maxlinenr = ''
"""""""""
let g:airline_theme='base16_gruvbox_dark_hard'

" Do not show branch (section B, see manual)
let g:airline_section_b = ''

let g:airline_powerline_fonts = 1

" tabline shows the list of buffers on top
let g:airline#extensions#tabline#enabled = 0

let g:airline#extensions#tagbar#enabled = 1

" Show extra info on current function
"let g:airline#extensions#tagbar#flags = 's'
