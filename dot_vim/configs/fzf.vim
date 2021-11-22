"""" fzf options

let g:fzf_buffers_jump = 1
nnoremap  <leader>f :Files<CR>
"nnoremap  <C-l> :FZFMru<CR>
nnoremap  <leader>h :History<CR>
nnoremap  <leader>t :Tags<CR>
nnoremap  <leader>g :Ag<CR>

let $FZF_DEFAULT_COMMAND =  "rg --files --hidden"
let $FZF_DEFAULT_OPTS='--color=dark --layout=reverse --info=inline'

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.4, 'yoffset': 1.0 } }
let g:fzf_commands_expect = 'ctrl-t'
