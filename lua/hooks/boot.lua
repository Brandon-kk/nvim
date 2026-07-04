--- 启动插件系统：同步加载 immediately 依赖，VimEnter 后异步安装其余插件
local function boot()
	local load = require("hooks.load")
	local install = require("hooks.install")

	load.eager()

	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.schedule(install)
		end,
	})
end

return boot
