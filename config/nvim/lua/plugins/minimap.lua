return {
	"Isrothy/neominimap.nvim",
	version = "v3.x.x",
	lazy = false, -- NOTE: NO NEED to Lazy load
	-- Optional. You can alse set your own keybindings
	keys = {
		-- Global Minimap Controls
		{ "<leader>mm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
	},
	init = function()
		--- Put your configuration here
		---@type Neominimap.UserConfig
		vim.g.neominimap = {
			auto_enable = false,
		}
	end,
}
