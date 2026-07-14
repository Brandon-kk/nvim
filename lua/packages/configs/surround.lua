Pack.register({
	spec = {
		src = "https://github.com/kylechui/nvim-surround",
		version = vim.version.range("4.x"),
	},
	module = "nvim-surround",
}):load({
	event = "BufReadPost",
	config = function(plugin)
		plugin.setup({})
	end,
})
