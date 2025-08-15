return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"ruby",
					"javascript",
					"typescript",
					"python",
					"sql",
					"html",
					"yaml",
					"xml",
					"json",
					"terraform",
					"scss",
					"css",
					"csv",
					"gitignore",
					"gitcommit",
					"gitattributes",
					"git_rebase",
					"dockerfile",
				},
				sync_install = false,
				indent = { enable = true },
				highlight = {
					enable = true,
				},
			})
		end,
	},
}
