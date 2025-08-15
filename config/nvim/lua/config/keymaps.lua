-- -- All Modes -- --
vim.keymap.set("", "<leader>h", "^") -- Easier beginning of line
vim.keymap.set("", "<leader>l", "$") -- Easier end of line
-- -- Normal Mode -- --
vim.keymap.set("n", "<leader><leader>", "<C-^>", { noremap = true }) -- Switch between last two files
vim.keymap.set("n", ";", ":", { noremap = true }) -- Save a shift stroke on initiating commands
vim.keymap.set("n", "R", ":%s/", { noremap = true }) -- Enter substitute faster
vim.keymap.set("n", "<leader>w", "<CMD>up<CR>") -- Save faster
vim.keymap.set("n", "<leader>q", "<CMD>q<CR>") -- Quit faster
vim.keymap.set("n", "<leader>/", "<CMD>nohlsearch<CR>") -- Clear search highlight
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float) -- Open diagnostics in float
vim.keymap.set("n", "yp", ":call setreg('+', expand('%:p'))<CR>") -- Copy (yank) current file path to clipboard
vim.keymap.set("n", "<leader>k", "kj") -- Move current line to end of line above
vim.keymap.set("n", "Di", "ddO") -- Delete line and start editing at proper indent
vim.keymap.set("n", "Wj", "<CMD>set paste<CR>m`o<Esc>``<CMD>set nopaste<CR>", { noremap = true, silent = true }) -- Add whitespace line below
vim.keymap.set("n", "Wk", "<CMD>set paste<CR>m`O<Esc>``<CMD>set nopaste<CR>", { noremap = true, silent = true }) -- Add whitespace line above
vim.keymap.set("n", "<C-S>", "<CMD>FzfLua grep_cword<CR>", { noremap = true }) -- Search current word
vim.keymap.set("n", "j", "gj", { noremap = true }) -- Don't skip the second part of a broken line
vim.keymap.set("n", "k", "gk", { noremap = true }) -- Don't skip the second part of a broken line
-- -- Visual Mode -- --
vim.keymap.set("v", "R", ":s/", { noremap = true }) -- Enter visual substitute faster
