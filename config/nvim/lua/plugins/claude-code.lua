return {
	"greggh/claude-code.nvim",
	dev = vim.fn.isdirectory(vim.fn.expand("~/repos/claude-code.nvim")) == 1,
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	opts = {
		window = {
			split_ratio = 0.4,
		},
		keymaps = {
			send_context = {
				normal = "<C-.>", -- Normal mode keymap for toggling Claude Code, false to disable
				visual = "<C-.>", -- Normal mode keymap for toggling Claude Code, false to disable
			},
			toggle = {
				normal = "<leader>c", -- Normal mode keymap for toggling Claude Code, false to disable
				terminal = "<C-.>", -- Terminal mode keymap for toggling Claude Code, false to disable
				-- variants = {
				-- 	continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
				-- 	verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
				-- },
			},
			window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
			scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
		},
	},
}
