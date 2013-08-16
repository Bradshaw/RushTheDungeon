local connections_mt = {}

connections_mt.triggered = false

function connections_mt:test()
	return false
end

function connections_mt:trigger()
	if self:test() then
		if self.triggered then
			return 0
		else
			self.triggered = true
			return 1
		end
	else
		if self.triggered then
			self.triggered = false
			return -1
		else
			return 0
		end
	end
end

connections = {}
connections.joy = {}
connections.key = {}

function connections.new()
	local self = setmetatable({},{__index = connections_mt})
	return self
end

function connections.newJoyButton(joy, btn, ...)
	local self = connections.new(...)
	if not connections.joy[joy] then
		connections.joy[joy] = {}
	end
	if not connections.joy[joy][btn] then
		self.test = function(self) return love.joystick.isDown(joy, btn) end
		connections.joy[joy][btn] = self
		return self
	end
end

function connections.newKeyButton(key, ...)
	local self = connections.new(...)
	if not connections.key[key] then
		self.test = function(self) return love.keyboard.isDown(key) end
		connections.key[key] = self
		return self
	end
end

