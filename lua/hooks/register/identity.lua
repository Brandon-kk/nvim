--- 规范化 P.name（pack 目录名）；不再猜测 P.module
--- Normalize P.name (pack dir); do not infer P.module
local function identity(P)
	if not P then
		return P
	end

	local Pack = _G.Pack

	if P.spec then
		P.name = Pack.parse(P.spec)
	elseif P.name then
		P.name = Pack.parse(P.name)
	end

	return P
end

return identity
