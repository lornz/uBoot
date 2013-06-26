
function showWaterLevel(value)
	waterLevel = value
	local tempYScale = (waterLevel/100)
	
	if (waterBar ~= nil) and (waterBar.height ~= nil) then
		transition.to( waterBar, { time=500, yScale=tempYScale} )
		transition.to( waterAnimation, {time = 500, y=waterBar.y - waterBar.height*tempYScale - 16})
	end
end

function updateWaterLevel(direction)
	local nenner = Level[currentLevel].taskGoal * #connectedClient
	if (direction == "down") then
		waterLevel = waterLevel - (Level[currentLevel].waterStart / nenner)
	elseif (direction == "up") then
		waterLevel = waterLevel + (Level[currentLevel].waterStart / nenner)
	end
	sendStuff(waterLevel,"water",gameChannel)
	if (waterLevel <= 0) then
		print("Level done")
		sendStuff("next","level",gameChannel)
	end

	if (waterLevel >= 100) then
		--print("GAME OVER!")
		sendStuff("lost","level",gameChannel)
	end
	print("Water went "..direction)
end