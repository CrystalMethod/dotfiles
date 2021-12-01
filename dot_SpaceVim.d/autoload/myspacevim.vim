function! myspacevim#before() abort

endfunction

function! myspacevim#after() abort
  highlight Comment cterm=italic gui=italic

  " always show sign column
  set signcolumn=yes

  let g:codestats_api_key = 'SFMyNTY.UTNKNWMzUmhiRTFsZEdodlpBPT0jI01UVXlNakk9.v_cWcZn34kYwvFTv-4cxAmBR34_aOliWi0okMJ8pssU'
endfunction
