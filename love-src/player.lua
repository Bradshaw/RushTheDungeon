local player_mt ={}

require("weapon")
require("useful")
require("connections")

player ={}
player.tracked = {}
player.averagepos = love.graphics.getWidth()/2
player.floatyavpos = love.graphics.getWidth()/2

player_mt.hitpoints = 100
player_mt.position = 0
player_mt.weapon = weapon.new()

function player.new(control)
	local self = setmetatable({},{__index = player_mt})
	self.control = control or connections.new()

	local runbump = math.random()*2
	local runbumpspeed = math.random()+4.5
	function self.runbounce()
		runbump = (runbump+love.timer.getDelta()*runbumpspeed) % 2
		return math.pow(math.abs(1-self.time),10) * 5 * -math.abs(math.pow((runbump-1),4))
	end

	self.time = 2

	self.bouncepow = math.random(3,6)
	self.bouncespeed = 3
	self.position = (math.random()*2-1)*love.graphics.getWidth()/4+love.graphics.getWidth()/2
	self.bounceheight = 60
	self.weapon = weapon.new(self)

	local f1,f2,f3 = math.random(),math.random(),math.random()
	local o1,o2,o3 = math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2
	function self.vertoff()
		return math.sin(love.timer.getTime()*f1+o1)+math.sin(love.timer.getTime()*f2+o2)+math.sin(love.timer.getTime()*f3+o3)
	end

	self.runspeed = 0

	return self
end

function player.newTracked(...)
	local self = player.new(...)
	table.insert(player.tracked, self)
	return self
end

function player.update(dt)
	local i = 1
	local avpos = 0
	while i<=#player.tracked do
		local v = player.tracked[i]
		if v.purge then
			table.remove(player.tracked, i)
		else
			v:update(dt)
			avpos = avpos+v.position
			if i>1 and v.vertoff()>player.tracked[i-1].vertoff() then
				player.tracked[i-1],player.tracked[i] = player.tracked[i],player.tracked[i-1]
			end
			i=i+1
		end
	end
	if #player.tracked>0 then
		player.averagepos = avpos/#player.tracked
		player.floatyavpos = math.lerp(player.floatyavpos, player.averagepos, 0.1*dt)
	end
	for i,v in ipairs(player.tracked) do
		--v.position = v.position+(love.graphics.getWidth()-player.floatyavpos)
	end
end

function player_mt:update(dt)
	local event = self.control:trigger()
	if self.slashing and self.time == 2 then
		self.weapon:strike(self.position)
		self.slashing = false
		--self.bounceheight = 0
	end
	if self.time==2 and self.control:test() then
		--self.bounceheight=math.min(60,self.bounceheight+dt*100)
	end
	if event == 1 and self.time==2 then
		--self.runspeed= self.runspeed+20
		self.time = 0
		self.slashing = true
	end
	self.time = math.min(2,self.time+dt*self.bouncespeed)
	self.position = self.position + self.runspeed * dt
	if self.time==2 then
		for i,v in ipairs(player.tracked) do
			if v~=self and v.time==2 then
				if math.abs(self.position-v.position)<20 then
					self.runspeed= self.runspeed+ 10*dt*math.sign(self.position-v.position)
				end
			end
		end
	end
	self.runspeed = self.runspeed + math.clamp(player.averagepos-self.position, -dt, dt)*2
	self.runspeed = self.runspeed + math.clamp(love.graphics.getWidth()/3-self.position, -dt, dt)*20
	self.runspeed = self.runspeed-self.runspeed*dt
	self.weapon:update(dt)
end

function player.draw()
	for i,v in ipairs(player.tracked) do
		v:draw()
	end
end

function player_mt:draw()
	local voff = 100+self.bounceheight-math.abs((self.time-1)^self.bouncepow)*self.bounceheight+self.vertoff()*10
	+ self.runbounce()
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle("fill",self.position-1,love.graphics.getHeight()-21-voff, 10, 18)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",self.position,love.graphics.getHeight()-20-voff, 8, 16)
	love.graphics.print(self.bouncepow,self.position,love.graphics.getHeight()-35-voff)
	self.weapon:draw(voff)
end