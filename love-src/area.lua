local area_mt = {}
area = {}

function area.new()
	local self = setmetatable({},{__index=area_mt})

	return self
end

function area_mt:update(dt)
end

function area_mt:draw()
end