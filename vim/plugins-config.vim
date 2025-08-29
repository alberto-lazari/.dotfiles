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
" Avoid white flash on startup
set background=dark
" Set light/dark theme dynamically
if executable('system-theme')
  " Check for theme change and set the right one
  function! UpdateTheme(theme) abort
    if a:theme ==# &background || $USER == 'root'
        return
    endif
    if a:theme ==# 'light'
      set background=light
    elseif a:theme ==# 'dark'
      set background=dark
    endif
  endfunction
  " Async polling function
  if has('nvim')
    function! PollThemeChange(timer) abort
      function! Callback(job_id, data, event) abort
        call UpdateTheme(a:data[0])
      endfunction
      call jobstart(['system-theme'], {
            \ 'stdout_buffered': v:true,
            \ 'on_stdout': function('Callback')
            \ })
    endfunction
  else
    function! PollThemeChange(timer) abort
      function! Callback(job_id, data) abort
        call UpdateTheme(a:data)
      endfunction
      call job_start(['system-theme'], { 'out_cb': function('Callback') })
    endfunction
  endif
  " Run once immediately
  call PollThemeChange(0)
  " Poll for a theme change every 5 seconds
  if has('timers')
    call timer_start(5000, 'PollThemeChange', {'repeat': -1})
  endif
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
" Custom flags from my fork
let g:cpp_custom_type_name_highlight = 1
let g:cpp_custom_macro_highlight = 1
let g:cpp_custom_scope_highlight = 1

" Enable fzf history
let g:fzf_history_dir = g:config_dir . '/cache/fzf-history'
" Change fzf key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
\ }
