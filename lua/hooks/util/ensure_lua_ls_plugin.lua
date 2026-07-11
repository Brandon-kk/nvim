--- 内置挂载 Pack.utils 的 lua_ls 插件（无需外部 .luarc / lsp 配置）
--- Built-in: attach Pack.utils lua_ls plugin (no external .luarc / lsp config)
---
--- 须在 Pack.lsp activate 时调用，勿在 hooks 初始化调用（会提前 require vim.lsp）
--- Call from Pack.lsp activate only; not at hooks init (would eager-load vim.lsp)
local applied = false

---@return string
local function plugin_path()
	local src = debug.getinfo(1, "S").source
	if type(src) == "string" and src:sub(1, 1) == "@" then
		local here = vim.fs.normalize(src:sub(2))
		return vim.fs.normalize(vim.fs.dirname(here) .. "/../lsp_plugin/pack_utils.lua")
	end
	return vim.fn.stdpath("config") .. "/lua/hooks/lsp_plugin/pack_utils.lua"
end

--- 合并进 vim.lsp.config("lua_ls")；可重复调用
--- Merge into vim.lsp.config("lua_ls"); safe to call repeatedly
return function()
	if applied then
		return
	end
	applied = true

	local path = plugin_path()
	-- 此处才会触发 vim.lsp 懒加载（应已到首个 FileType）
	-- Accessing vim.lsp here triggers lazy load (should be first FileType)
	vim.lsp.config("lua_ls", {
		-- 跳过「是否信任插件」询问（插件由 hooks 内置提供）
		-- Skip "trust this plugin?" prompt (plugin is built into hooks)
		init_options = {
			trustByClient = true,
		},
		settings = {
			Lua = {
				runtime = {
					plugin = path,
				},
			},
		},
	})
end
