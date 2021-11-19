"""" fzf options
let g:fzf_buffers_jump = 1
nnoremap  <C-p> :FZF<CR>
"nnoremap  <C-l> :FZFMru<CR>
nnoremap  <C-l> :History<CR>
nnoremap  <C-t> :Tags<CR>
nnoremap  <C-g> :Ag<CR>

" Use neovim floating window for fzf
if has('nvim')
"  let $FZF_DEFAULT_OPTS .=' --layout=reverse'
"  let $FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
"
"  function! FloatingFZF()
"    let height = &lines
"    let width = float2nr(&columns - (&columns * 2 / 10))
"    let col = float2nr((&columns - width) / 2)
"    let col_offset = &columns / 10
"    let opts = {
"          \ 'relative': 'editor',
"          \ 'row': height * 2 / 3,
"          \ 'col': col + col_offset,
"          \ 'width': width * 2 / 1,
"          \ 'height': height / 3,
"          \ 'style': 'minimal'
"          \ }
"    let buf = nvim_create_buf(v:false, v:true)
"    let win = nvim_open_win(buf, v:true, opts)
"    call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
"  endfunction
"
"  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
"
"  highlight TabLine ctermbg=234
endif
