return {
	enabled = true,
	'hiattp/splitwise.nvim',
	dev = vim.fn.isdirectory(vim.fn.expand("~/repos/splitwise.nvim")) == 1,
	opts = {
		ignore_winfixwidth = true,
	},
}
