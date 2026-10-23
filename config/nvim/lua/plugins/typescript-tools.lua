return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		root_dir = function(fname)
			local util = require("lspconfig.util")
			-- Only attach if we find package.json or tsconfig.json
			return util.root_pattern("package.json", "tsconfig.json")(fname)
		end,
	},
}
