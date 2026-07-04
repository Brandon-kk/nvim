return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = Pack.root({ ".luarc.json", ".luarc.jsonc" }),
	settings = {
		Lua = {
			diagnostics = {
				globals = { "Pack", "Snacks" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
}
