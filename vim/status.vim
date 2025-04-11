" Status line
function! SimpleStatusLine()
  let directory="%{fnamemodify(getcwd(),':~:t')}"
  let file="%{expand('%')!=''?expand('%:~:.'):'<new>'}%m%r%h%w"
  let align_right='%='
  let lineinfo='ln %l col %c'
  return '[' . directory . '] ' . file . align_right . lineinfo
endfunction

" Pretty C-g output
function! StatusInfo()
  " Show file name as opened, relative if possible
  let filename = expand('%') != '' ? expand('%:~:.') : '<new>'
  let modified = &modified ? '[+]' : ''
  let readonly = &readonly ? '[RO]' : ''
  let lines = line('$') . ' lines'
  let indent = 'indent ' . ( &expandtab
    \ ? 'spaces ' . repeat('·', &shiftwidth)
    \ : 'tabs ' . repeat('-', &tabstop - 1) . '>'
  \ )

  " Find the first line with trailing whitespace
  let lnum = 1
  let trailing_line = ''
  while lnum <= line('$')
    if match(getline(lnum), '\s\+$') != -1
      let trailing_line = '!~ ln ' . lnum
      break
    endif
    let lnum += 1
  endwhile

  let elements = [
    \ filename . modified . readonly,
    \ lines,
    \ &fileencoding,
    \ &filetype,
    \ indent,
    \ trailing_line,
  \ ]
  echo join(filter(elements, 'v:val != ""'), ' | ')
endfunction

set laststatus=2 statusline=%!SimpleStatusLine()
nnoremap <C-g> :call StatusInfo()<CR>
