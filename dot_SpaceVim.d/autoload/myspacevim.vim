function! myspacevim#before() abort

endfunction

function! myspacevim#after() abort
  highlight Comment cterm=italic gui=italic

  " always show sign column
  set signcolumn=yes
endfunction
