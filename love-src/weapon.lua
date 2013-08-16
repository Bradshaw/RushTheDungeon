local weapon_mt = {}
weapon = {}

function weapon.new(origin)
	local self = setmetatable({},{__index = weapon_mt})
	self.whammo = 0
	self.whammat = 0
	self.fadespeed = 20
	self.origin = origin
	return self
end

function weapon_mt:strike(position)
	self.whammo = 1
	self.whammat = position
	for i,v in ipairs(player.tracked) do
		if self.origin and self.origin~=v and v.time==2 then
			if math.abs(v.position-self.origin.position)<50 then
				v.runspeed= v.runspeed+ 100*math.sign(v.position-self.origin.position)
			end
		end
	end

	for i,v in ipairs(monster.all) do
		if self.origin then
			if math.abs(v.position-self.origin.position)<50 then
				v:strike()
			end
		end
	end
end

function weapon_mt:update(dt)
	self.whammo = math.max(0, self.whammo-dt*self.fadespeed)
end

function weapon_mt:draw(voff)
	if self.whammo>0 then
		love.graphics.circle("fill",self.whammat,love.graphics.getHeight()-voff,50)
	end
end

