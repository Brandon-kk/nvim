--- build fingerprint stamp: kept under state (not in plugin dir; resists forged .build_done)
local M = {}

---@param dir string
---@return string
local function stamp_path(dir)
	-- Path hash avoids stamp collisions for same basename under different packs
	local key = vim.fn.sha256(vim.fs.normalize(dir)):sub(1, 16)
	local name = vim.fs.basename(vim.fs.normalize(dir))
	return vim.fn.stdpath("state") .. "/pack-hooks-build/" .. name .. "-" .. key .. ".stamp"
end

---@param dir string
---@return string
local function legacy_stamp_path(dir)
	return dir .. "/.build_done"
end

---@param build_cmd string|string[]|function
local function fingerprint(build_cmd)
	local base
	if type(build_cmd) == "function" then
		-- Bytecode hash (strip debug): changes only when the function body code
		-- changes — not when comments / line numbers elsewhere shift.
		-- Force rebuild: :PackReBuild!
		local ok, dumped = pcall(string.dump, build_cmd, true)
		if ok and type(dumped) == "string" then
			base = "fn:" .. vim.fn.sha256(dumped)
		else
			local info = debug.getinfo(build_cmd, "S")
			base = "fn:" .. tostring(info.source or "?")
		end
	elseif type(build_cmd) == "table" then
		local parts = {}
		for i, v in ipairs(build_cmd) do
			if type(v) ~= "string" then
				error("build argv[" .. i .. "] must be string")
			end
			parts[i] = v
		end
		base = table.concat(parts, "\0")
	else
		base = tostring(build_cmd)
	end
	return vim.fn.sha256(base)
end

---@param path string
---@param fp string
---@return boolean
local function matches(path, fp)
	if vim.fn.filereadable(path) == 0 then
		return false
	end
	local lines = vim.fn.readfile(path)
	return lines[1] == fp
end

---@param dir string
---@param build_cmd string|string[]|function
function M.current(dir, build_cmd)
	if not dir or vim.fn.isdirectory(dir) ~= 1 then
		return false
	end
	local fp = fingerprint(build_cmd)
	if matches(stamp_path(dir), fp) then
		return true
	end
	-- Legacy in-plugin .build_done; migrate to state on hit
	if matches(legacy_stamp_path(dir), fp) then
		M.write(dir, build_cmd)
		pcall(vim.fn.delete, legacy_stamp_path(dir))
		return true
	end
	return false
end

---@param dir string
---@param build_cmd string|string[]|function
function M.write(dir, build_cmd)
	local path = stamp_path(dir)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	local fp = fingerprint(build_cmd)
	local tmp = path .. ".tmp." .. tostring(vim.uv.os_getpid())
	vim.fn.writefile({ fp }, tmp)
	vim.uv.fs_rename(tmp, path)
	pcall(vim.fn.delete, legacy_stamp_path(dir))
end

function M.clear(dir)
	pcall(vim.fn.delete, stamp_path(dir))
	pcall(vim.fn.delete, legacy_stamp_path(dir))
end

return M
