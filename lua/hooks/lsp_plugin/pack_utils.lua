--- Pack.utils → lua_ls：解析 utils 表，虚拟注入 if false 全局声明（不改磁盘文件）
--- Pack.utils → lua_ls: parse utils table, virtually inject if-false global stubs (no disk writes)
---
--- 由 Pack.lsp activate → ensure_lua_ls_plugin 挂到 Lua.runtime.plugin
--- Attached via Pack.lsp activate → ensure_lua_ls_plugin as Lua.runtime.plugin

---@class diff
---@field start integer
---@field finish integer
---@field text string

---@param uri string
---@param text string
---@return diff[]|nil
function OnSetText(uri, text)
	-- 仅处理 packages/configs/*.lua
	-- Only packages/configs/*.lua
	if not uri:match("[/\\]packages[/\\]configs[/\\][^/\\]+%.lua$") then
		return nil
	end

	local block = text:match("utils%s*=%s*(%b{})")
	if not block then
		return nil
	end

	-- lowercase-global：注入的 menu=... 是小写全局；本文件为 setfenv 约定，关闭该检查
	-- lowercase-global: injected menu=... are lowercase globals; disable for setfenv configs
	local lines = {
		"---@diagnostic disable: lowercase-global\n",
		"if false then --[[ Pack.utils → lua_ls ]]\n",
	}
	local n = 0
	for name, path in block:gmatch("([%a_][%w_]*)%s*=%s*[\"']([^\"']+)[\"']") do
		n = n + 1
		lines[#lines + 1] = ("  ---@type table\n  %s = require(%q)\n"):format(name, path)
	end
	if n == 0 then
		return nil
	end
	lines[#lines + 1] = "end\n"

	---@type diff[]
	return {
		{
			start = 1,
			finish = 0,
			text = table.concat(lines),
		},
	}
end
