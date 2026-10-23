return {
	"zbirenbaum/copilot.lua",
	enabled = false,
	lazy = false,
	opts = {
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = false,
			auto_trigger = false,
			keymap = {
				accept = "<CR>",
			},
		},
	},
	keys = {
		{
			"<C-l>",
			function()
				require("blink.cmp").hide()
				require("copilot.suggestion").next()
			end,
			mode = "i",
			noremap = true,
			desc = "Trigger Copilot suggestion in insert mode",
		},
	},
}
