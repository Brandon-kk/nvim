Pack.register({
	"https://github.com/mason-org/mason.nvim",
	module = "mason",
	dependencies = {
		"https://github.com/mason-org/mason-registry",
	},
}):load({
	cmd = "Mason",
	config = function(plugin)
		plugin.setup({
			PATH = "skip",
			ui = {
				width = 0.65,
				height = 0.75,
			},
		})
	end,
})
