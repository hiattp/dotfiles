return {
	"lewis6991/gitsigns.nvim",
	opts = {},
	lazy = false,
	keys = {
		{
			"<leader>bb",
			"<CMD>Gitsigns blame<CR>",
			desc = "Show git blame for the file",
		},
		{
			"<leader>gd",
			"<CMD>Gitsigns diffthis<CR>",
			desc = "Show git diff for the current file",
		},
	},
}
