" ================================================================================
" # PLUGIN LIST
" ================================================================================

" Plugin list "

call plug#begin(stdpath('data') . '/plugged')

" Security
Plug 'ciaranm/securemodelines'

" Text manipulation
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'junegunn/vim-easy-align'
Plug 'editorconfig/editorconfig-vim'

" UI enhancements
Plug 'tpope/vim-eunuch'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'luochen1990/rainbow'
Plug 'preservim/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

" Color schemes
Plug 'chriskempson/base16-vim'

Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

call plug#end()

" ================================================================================
" # PLUGIN CONFIGURATIONS
" ================================================================================

" Rainbow "

let g:rainbow_active = 1

" Rust "

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Coc "

call coc#add_extension(
	\'coc-yaml',
	\'coc-java',
	\'coc-json',
	\'coc-vimlsp',
	\'coc-snippets',
	\'coc-highlight',
\)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]	=~# '\s'
endfunction

" Use <c-.> to trigger completion.
inoremap <silent><expr> <c-.> coc#refresh()

" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
	execute 'h '.expand('<cword>')
  else
	call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Find symbol of current document.
nnoremap <silent> <space>o	:<C-u>CocList outline<CR>

" Search workspace symbols.
nnoremap <silent> <space>s	:<C-u>CocList -I symbols<CR>

" Implement methods for trait
nnoremap <silent> <space>i	:call CocActionAsync('codeAction', '', 'Implement missing members')<CR>

" Show actions available at this location
nnoremap <silent> <space>a	:CocAction<CR>

" TagBar "

let g:rust_use_custom_ctags_defs = 1
let g:tagbar_type_rust = {
	\ 'ctagsbin' : '/usr/bin/ctags-universal',
	\ 'ctagstype' : 'rust',
	\ 'kinds' : [
		\ 'n:modules',
		\ 's:structures:1',
		\ 'i:interfaces',
		\ 'c:implementations',
		\ 'f:functions:1',
		\ 'g:enumerations:1',
		\ 't:type aliases:1:0',
		\ 'v:constants:1:0',
		\ 'M:macros:1',
		\ 'm:fields:1:0',
		\ 'e:enum variants:1:0',
		\ 'P:methods:1',
	\ ],
	\ 'sro': '::',
	\ 'kind2scope' : {
		\ 'n': 'module',
		\ 's': 'struct',
		\ 'i': 'interface',
		\ 'c': 'implementation',
		\ 'f': 'function',
		\ 'g': 'enum',
		\ 't': 'typedef',
		\ 'v': 'variable',
		\ 'M': 'macro',
		\ 'm': 'field',
		\ 'e': 'enumerator',
		\ 'P': 'method',
	\ },
\ }
