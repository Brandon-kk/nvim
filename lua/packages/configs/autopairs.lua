Pack.register({
	spec = "https://github.com/windwp/nvim-autopairs",
	module = "nvim-autopairs",
}):load({
	event = "InsertEnter",
	once = true,
	config = function(plugin)
		plugin.setup({})
	end,
})
