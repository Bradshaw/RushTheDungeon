local state = gstate.new()


function state:init()
	require("connections")
end


function state:enter()
	readying = 0
end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	local newControl = connections.newJoyButton(joystick, button)
	if newControl then
		player.newTracked(newControl)
	end
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
	local newControl = connections.newKeyButton(key)
	if newControl then
		player.newTracked(newControl)
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	player.update(dt)
	readying = readying + dt
	for i,v in ipairs(player.tracked) do
		if not v.control:test() then
			readying = 0
			break
		end
	end
	if #player.tracked==0 then
		readying = 0
	end
	if readying>=2.9 then
		gstate.switch(game)
	end
end


function state:draw()
	love.graphics.print("Players: "..#player.tracked, 20,20)
	player.draw()
	if readying==0 then
		love.graphics.print("Everyone hold your buttons!", 50,50)
	else
		love.graphics.print("Ready in "..3-math.floor(readying*100)/100, 50,50)
	end
end

return state