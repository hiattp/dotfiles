return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	init = function()
		-- Some Command Line Tools linkers cannot read the macOS 27 SDK's
		-- arm64e.x1 entries. Use the installed compatible SDK inside Neovim only.
		local sdk = "/Library/Developer/CommandLineTools/SDKs/MacOSX26.5.sdk"
		if vim.fn.has("mac") ~= 1 or vim.env.SDKROOT or vim.fn.isdirectory(sdk) ~= 1 then
			return
		end
		local output = vim.fn.tempname()
		local command = { "/usr/bin/cc", "-x", "c", "-", "-o", output }
		local source = "int main(void) { return 0; }\n"
		local result = vim.fn.system(command, source)
		if vim.v.shell_error ~= 0 and result:find("arm64e.x1", 1, true) then
			vim.list_extend(command, { "-isysroot", sdk })
			vim.fn.system(command, source)
			if vim.v.shell_error == 0 then
				vim.env.SDKROOT = sdk
			end
		end
		vim.fn.delete(output)
	end,
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
}
