local function select(capture, group)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture, group or "textobjects")
	end
end

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	opts = {
		select = {
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			-- You can choose the select mode (default is charwise 'v')
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			-- Extend textobjects to include surrounding whitespace, like `ap`
			include_surrounding_whitespace = false,
		},
	},
	keys = {
		-- You can use the capture groups defined in textobjects.scm
		{ "af", select("@function.outer"), mode = { "x", "o" }, desc = "Select outer function" },
		{ "if", select("@function.inner"), mode = { "x", "o" }, desc = "Select inner function" },
		{ "am", select("@function.outer"), mode = { "x", "o" }, desc = "Select outer function" },
		{ "im", select("@function.inner"), mode = { "x", "o" }, desc = "Select inner function" },
		{ "ar", select("@block.outer"), mode = { "x", "o" }, desc = "Select outer block" },
		{ "ir", select("@block.inner"), mode = { "x", "o" }, desc = "Select inner block" },
		{ "ac", select("@class.outer"), mode = { "x", "o" }, desc = "Select outer class" },
		{ "ic", select("@class.inner"), mode = { "x", "o" }, desc = "Select inner part of a class region" },
		{ "ao", select("@comment.outer"), mode = { "x", "o" }, desc = "Select outer comment" },
		-- You can also use captures from other query groups like `locals.scm`
		{ "as", select("@local.scope", "locals"), mode = { "x", "o" }, desc = "Select language scope" },
	},
}
