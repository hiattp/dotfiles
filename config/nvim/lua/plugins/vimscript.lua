return {
	{ "janko-m/vim-test" },
	{ "pbrisbin/vim-mkdir" },
	{ "tpope/vim-sleuth" },
	{
		"tpope/vim-rails",
		config = function()
			-- disable autocmd set filetype=eruby.yaml
			vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
				pattern = { "*.yml" },
				callback = function()
					vim.bo.filetype = "yaml"
				end,
			})
		end,
	},
	{
		"tpope/vim-projectionist",
		init = function()
			vim.cmd([[
				let g:rails_projections = {
						\ "app/components/*.rb": {
								\ "type": "component",
								\ "related": "app/components/{}.html.erb",
								\ "alternate": [
										\ "spec/components/{}_spec.rb"
								\ ]
						\ },
						\ "app/components/*.html.erb": {
								\ "type": "component",
								\ "related": "app/components/{}.rb",
								\ "alternate": [
										\ "spec/components/{}_spec.rb",
								\ ]
						\ },
						\ "spec/components/*_spec.rb": {
								\ "type": "component",
								\ "related": "app/components/{}.html.erb",
								\ "alternate": [
										\ "app/components/{}.rb",
								\ ]
						\ }
				\}
			]])
		end,
	},
}
