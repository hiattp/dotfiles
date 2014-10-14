" Enable searching in project with :find
set path=$PWD/**

" Auto-indent in a way that makes sense
set autoindent

" Auto-complete brackets, braces and parens
inoremap {      {}<Left>
inoremap {{{    {{  }}<Left><Left><Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap []     []
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap '      ''<Left>
inoremap ''     '
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap "      ""<Left>
inoremap ""     "
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

" Reload the vimrc file
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Dodge a couple keystrokes on vim commands
nnoremap ; :

" highlight search results
set hlsearch

" Search settings
set ignorecase
set smartcase

" Line Numbers
set relativenumber

" Full line tab completion using Supertab
imap <C-l> <C-x><C-l>

" Paste from clipboard
map <leader>p :set paste<cr>:r !pbpaste<cr>:set nopaste<cr>
map <leader>bb :Gblame<CR>
" Navigate lines
map <leader>l $
map <leader>h ^
" Don't skip over second part of a broken line
nnoremap j gj
nnoremap k gk
" Adjust lines
map <leader>k kJ
" Paste over lines with whitespace (common when using snipmate)
nnoremap <expr> p getline('.') =~? '\v^\s+$' ? "\"_ddP" : "p"
" Clear search matches
map <leader>c :nohlsearch<CR>
" RSpec.vim settings and mappings
let g:rspec_command = 'time spring rspec {spec}'
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>ss :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
" Enter Explore faster
map <Leader>e :Explore<CR>

" Open new split panes to right and bottom, which feels more natural
" set splitbelow
" set splitright

"Ensure focused split is largest in window
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

runtime macros/matchit.vim

" Settings for vim-session
let g:session_autosave='no'
let g:session_autoload='no'
" Settings for syntastic
let g:syntastic_html_checkers=['']
