-- ==============================================================
-- 执行启动流程
-- configs/*.lua 内通过 Pack.register(P) 声明 spec / disabled
-- ==============================================================

Pack.restart()

local config_path = vim.fn.stdpath("config") .. "/lua/packages/configs"
if vim.fn.isdirectory(config_path) == 1 then
	for name, type in vim.fs.dir(config_path) do
		if type == "file" and name:match("%.lua$") then
			local mod = "packages.configs." .. name:gsub("%.lua$", "")
			local ok, err = pcall(require, mod)
			if not ok then
				vim.notify("插件配置加载失败: " .. mod .. "\n" .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end
end

Pack.boot()
