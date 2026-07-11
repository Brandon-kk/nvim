Pack.register({
	"https://github.com/stevearc/overseer.nvim",
	module = "overseer",
}):load({
	event = "UIEnter",
	once = true,
	time_sequence = true,
	config = function(plugin)
		plugin.setup({
			dap = false,
			task_list = {
				direction = "left",
			},
		})
	end,
})
