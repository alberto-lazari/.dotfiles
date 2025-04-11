" Easier go to start/end of line
nnoremap gs ^
vnoremap gs ^
onoremap gs ^
nnoremap gl $
vnoremap gl $
onoremap gl $
" More intuitive re-do
nnoremap U <C-r>
" Easier copy until end of line
nnoremap Y y$
" Prepend space to use the system clipboard
nnoremap <Space> "*
vnoremap <Space> "*

" Toggle undo tree
nnoremap <Space>u :UndotreeToggle<Return>
vnoremap <Space>u :UndotreeToggle<Return>

" Map fzf commands
nnoremap <Space>e :Files<Return>
nnoremap <Space>E :Files!<Return>
nnoremap <Space>b :Buffers<Return>
nnoremap <Space>B :Buffers!<Return>
nnoremap <Space>/ :RG<Return>
nnoremap <Space>? :RG!<Return>

" Neotree (only on nvim)
nnoremap <Space>t :Neotree toggle=true<Return>
