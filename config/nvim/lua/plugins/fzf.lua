-- NOTE: In a future install, probably need to install fzf via homebrew.
-- See https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew
return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {
		keymap = {
			fzf = {
				["ctrl-q"] = "select-all+accept", -- Send all to quickfix
			},
		},
	},
	keys = {
		{
			"<C-p>",
			function()
				require("fzf-lua").files()
			end,
			desc = "Open fzf-lua file search",
		},
		{
			"<leader>S",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Open fzf-lua live_grep",
		},
		{
			"<leader>gs",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "Open fzf-lua git_status",
		},
	},
}
