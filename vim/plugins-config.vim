" Skip plugins configuration if they are not found
if !isdirectory(g:config_dir . '/pack/dotfiles')
  finish
endif

function! LoadPlugins(file)
  for plugin in readfile(a:file)
    if plugin =~ '^[^"#]'
      let name = substitute(plugin, '.*/', '', '')
      execute 'packadd!' name
    endif
  endfor
endfunction

" Disable custom filetype detection
let g:polyglot_disabled = ['ftdetect']

call LoadPlugins(g:config_dir . '/plugins.vim')

colorscheme one
set background=dark
" Set light/dark theme dynamically
if system('system-theme') == "light\n"
  set background=light
endif

" Custom autoclosing rules for LaTeX and Typst math mode
for filetype in ['tex', 'latex', 'typst']
  call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': filetype})
  call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': filetype})
  call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': filetype})
  call lexima#add_rule({'char': '<space>', 'at': '\$\%#\$', 'input_before': ' ', 'input_after': ' ', 'filetype': filetype})
  call lexima#add_rule({'char': '<BS>', 'at': '\$ \%# \$', 'delete': 1, 'filetype': filetype})
endfor

" Disable highlighting for Java identifiers and dots
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE

" C++ syntax highlighting flags
let g:cpp_attributes_highlight = 1
let g:cpp_operator_highlight = 1
" Custom flags from my fork
let g:cpp_custom_type_name_highlight = 1
let g:cpp_custom_macros_highlight = 1

" Enable fzf history
let g:fzf_history_dir = g:config_dir . '/cache/fzf-history'
" Change fzf key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
\ }
