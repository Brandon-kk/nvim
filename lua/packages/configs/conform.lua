Pack.register({
	spec = "https://github.com/stevearc/conform.nvim",
	module = "conform",
	deps = {
		{
			src = "https://github.com/mason-org/mason.nvim",
			module = "mason",
			setup = function(plugin)
				plugin.setup({
					PATH = "prepend",
					ui = {
						width = 0.65,
						height = 0.75,
					},
				})
			end,
			deps = {
				"https://github.com/mason-org/mason-registry",
			},
		},
	},
}):load({
	event = "BufReadPost",
	once = true,
	time_sequence = true,
	config = function(plugin)
		plugin.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "oxfmt", "cbfmt" },
				javascript = { "oxfmt" },
				typescript = { "oxfmt" },
				json = { "oxfmt" },
				jsonc = { "oxfmt" },
				json5 = { "oxfmt" },
				jsonnet = { "oxfmt" },
				vue = { "oxfmt" },
				css = { "oxfmt" },
				scss = { "oxfmt" },
				less = { "oxfmt" },
				html = { "oxfmt" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
			formatters = {
				cbfmt = {
					command = "cbfmt",
					args = {
						"--write",
						"--best-effort",
						"--config",
						vim.fn.expand("~/.config/nvim/cbfmt.toml"),
						"$FILENAME",
					},
					stdin = false,
				},
			},
		})
	end,
})
