"""" fzf options

let g:fzf_buffers_jump = 1
nnoremap  <leader>f :Files<CR>
"nnoremap  <C-l> :FZFMru<CR>
nnoremap  <leader>h :History<CR>
nnoremap  <leader>t :Tags<CR>
nnoremap  <leader>g :Ag<CR>


let $FZF_DEFAULT_COMMAND =  "rg --files --hidden 2>/dev/null"
let $FZF_DEFAULT_OPTS=' --color=dark --layout=reverse'
       "\ --color=fg:8,bg:11,hl:7,fg+:7,bg+:0,hl+:9
       "\ --color=gutter:11,info:3,prompt:4,pointer:9,spinner:4
       "\ --layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
let g:fzf_commands_expect = 'ctrl-t'

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  let height = &lines
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width)  / 2)
  let col_offset = &columns / 10
  let opts = {
        \ 'relative': 'editor',
        \ 'row': height * 2 / 3,
        \ 'col': col + col_offset,
        \ 'width': width * 2 / 1,
        \ 'height': height / 3,
        \ 'style': 'minimal'
        \ }
  call nvim_open_win(buf, v:true, opts)
endfunction

" Use neovim floating window for fzf
"if has('nvim')
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
"endif
