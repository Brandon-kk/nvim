return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	root_dir = Pack.root({
		"package.json",
		"jsconfig.json",
		"tsconfig.json",
		"package-lock.json",
	}),
	init_options = {
		hostInfo = "neovim",
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.fn.stdpath("data")
					.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
				languages = { "vue" },
				configNamespace = "typescript",
				enableForWorkspaceTypeScriptVersions = true,
			},
		},
	},
}
