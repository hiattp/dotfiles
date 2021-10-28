" MacVim Settings
colorscheme macvim
if strftime("%H") < 16
  set bg=light
else
  set bg=dark
endif
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guifont=Menlo\ Regular:h19
