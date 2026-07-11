--- 调用 config：setfenv 注入 utils 为可直接使用的名字
--- Call config with utils injected as bare names via setfenv
---
--- lua_ls：Pack.lsp activate 时挂载 lsp_plugin/pack_utils.lua（不在 hooks 启动时碰 vim.lsp）
--- lua_ls: attach pack_utils.lua on Pack.lsp activate (do not touch vim.lsp at hooks boot)
---@param config_fn function
---@param plugin any
---@param utils table<string, any>
---@return boolean ok
---@return any err
return function(config_fn, plugin, utils)
	if type(utils) == "table" and next(utils) then
		local env = {}
		for k, v in pairs(utils) do
			env[k] = v
		end
		-- 始终挂到 _G，避免多次 setfenv 经 __index 链残留旧 utils
		-- Always index _G so repeated setfenv does not chain stale utils
		setmetatable(env, { __index = _G })
		setfenv(config_fn, env)
	end
	return pcall(config_fn, plugin)
end
