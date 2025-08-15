return {
	{ "janko-m/vim-test" },
	{ "pbrisbin/vim-mkdir" },
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-rails" },
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
		end
	},
}
