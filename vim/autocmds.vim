" Indent with 4 spaces on specific file types
autocmd FileType java,kotlin,python,cs,cpp
  \ setlocal tabstop=4 shiftwidth=4

" Spellcheck specific file types (and force 2 spaces tabs)
autocmd FileType text,latex,tex,md,markdown,typst
  \ setlocal spell tabstop=2 shiftwidth=2

" Highlight all scripts with bash syntax
autocmd FileType sh setlocal filetype=bash
