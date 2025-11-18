return {
	"vim-test/vim-test",
	keys = {
		{
			"<leader>t",
			"<CMD>TestFile<CR>",
			{ silent = true, desc = "Test all specs in file" },
		},
		{
			"<leader>s",
			"<CMD>TestNearest<CR>",
			{ silent = true, desc = "Test spec nearest the cursor" },
		},
		{
			"<leader>L",
			"<CMD>TestLast<CR>",
			{ silent = true, desc = "Run the most recent spec" },
		},
		{
			"<leader>a",
			"<CMD>TestSuite<CR>",
			{ silent = true, desc = "Run the entire test suite" },
		},
		{
			"<leader>gt",
			"<CMD>TestVisit<CR>",
			{ silent = true, desc = "Go to the spec file you most recently ran" },
		},
	},
	init = function()
		vim.cmd([[
			"let test#strategy = "neovim"
			let test#strategy = "basic"
			let test#ruby#rspec#options = {
				\ 'file':    '--format documentation',
				\ 'suite':   '--fail-fast',
			\}
			let test#ruby#rspec#file_pattern = '_spec\.rb'
			let test#python#runner = 'pytest'
			let g:test#no_alternate = 1
		]])
	end,
}
