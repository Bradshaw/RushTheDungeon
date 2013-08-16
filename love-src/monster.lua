local monster_mt = {}

monster_mt.position = love.graphics.getWidth()+20

monster = {}
monster.time = 0
monster.cooldown = 0.5
monster.all  ={}

function monster.new()
	local self = setmetatable({},{__index=monster_mt})
	self.hp = 5
	self.speed = math.random()*20+60
	self.knockback = 0

	local runbump = math.random()*2
	local runbumpspeed = math.random()+4.5
	function self.runbounce()
		runbump = (runbump+love.timer.getDelta()*runbumpspeed) % 2
		return 5 * -math.abs(math.pow((runbump-1),4))
	end


	local f1,f2,f3 = math.random(),math.random(),math.random()
	local o1,o2,o3 = math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2
	function self.vertoff()
		return math.sin(love.timer.getTime()*f1+o1)+math.sin(love.timer.getTime()*f2+o2)+math.sin(love.timer.getTime()*f3+o3)
	end
	return self
end

function monster.spawn(...)
	table.insert(monster.all,monster.new(...))
end

function monster.update(dt)
	local i =1
	while i<=#monster.all do
		local v = monster.all[i]
		if v.purge then
			table.remove(monster.all, i)
		else
			v:update(dt)
			i=i+1
		end
	end
	monster.time = monster.time - dt
	if monster.time<0 then
		monster.spawn()
		monster.time = monster.time + monster.cooldown
	end
end

function monster_mt:update(dt)
	self.position = self.position - dt*self.speed
	self.knockback = math.max(0,self.knockback-dt*500)
	self.position = self.position + self.knockback*dt
end


function monster.draw( )
	for i,v in ipairs(monster.all) do
		v:draw()
	end
end

function monster_mt:draw()
	local voff = 100+self.vertoff()*10+self.runbounce()
	love.graphics.setColor(0,64,0)
	love.graphics.rectangle("fill",self.position-1,love.graphics.getHeight()-21-voff, 10, 10)
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",self.position,love.graphics.getHeight()-20-voff, 8, 8)
end

function monster_mt:strike()
	self.hp = self.hp - 1
	self.knockback = 300
	if self.hp<=0 then
		self.purge = true
	end
end