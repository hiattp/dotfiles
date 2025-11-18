return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			ruby = { "rubocop" },
			eruby = { "erb_lint" },
			terraform = { "terraform_fmt" },
		},
		formatters = {
			erb_lint = {
				stdin = false,
				tmpfile_format = ".conform.$RANDOM.$FILENAME",
				command = "bundle",
				args = { "exec", "erblint", "--autocorrect", "$FILENAME" },
			},
		},
		-- format_on_save = {
		-- 	pattern = { "*.lua" },
		-- 	-- These options will be passed to conform.format()
		-- 	timeout_ms = 500,
		-- 	lsp_format = "fallback",
		-- },
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					lsp_format = "fallback",
					timeout_ms = 3000,
				})
			end,
			desc = "Format current file",
		},
	},
}
