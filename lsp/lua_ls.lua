return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = Pack.root({ ".luarc.json", ".luarc.jsonc", "nvim-pack-lock.json" }),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
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
