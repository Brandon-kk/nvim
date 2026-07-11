--- 解析 deps 条目为规范化依赖表
--- Resolve a deps entry into a normalized dep table
---
--- 支持 / Supports:
---   "https://..."                          -- 纯 URL（仅 packadd，无 module）
---   { "https://...", module = "...", setup = fn }  -- 有 setup 时 module 必填
---   { src = "https://...", ... }           -- 显式 src
---   { spec = { src = "..." }, ... }        -- spec 仅 table
---@param dep any
---@return table
return function(dep)
	local Pack = _G.Pack
	if type(dep) == "string" then
		local name = Pack.parse(dep)
		return {
			spec = { src = dep },
			name = name,
		}
	end

	if type(dep) ~= "table" then
		error("dep must be string or table: " .. vim.inspect(dep))
	end

	-- [1] 字符串 → src
	local src = dep.src
	local spec = dep.spec
	if type(dep[1]) == "string" then
		if src or spec then
			error("dep: use either [1] URL or src/spec, not both: " .. vim.inspect(dep))
		end
		src = dep[1]
	end

	if type(spec) == "string" then
		error('dep.spec must be a table like { src = "..." }, not a string')
	end
	if type(spec) == "table" then
		-- ok
	elseif type(src) == "string" and src ~= "" then
		spec = { src = src, name = dep.name, version = dep.version }
	else
		error("dep table must have [1] URL, src, or spec={src=...}: " .. vim.inspect(dep))
	end

	local name = dep.name and Pack.parse(dep.name) or Pack.parse(spec)
	local module = dep.module
	if dep.setup ~= nil then
		if type(module) ~= "string" or module == "" then
			error("dep with setup requires module (string): " .. name)
		end
	elseif module ~= nil and (type(module) ~= "string" or module == "") then
		error("dep.module must be a non-empty string: " .. name)
	end

	return {
		spec = spec,
		name = name,
		module = module,
		setup = dep.setup,
		build_cmd = dep.build_cmd,
		deps = dep.deps,
		immediately = dep.immediately == true,
	}
end
