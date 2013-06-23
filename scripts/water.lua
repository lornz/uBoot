
function showWaterLevel(value)
	waterLevel = value
	local tempYScale = (waterLevel/100)
	transition.to( waterBar, { time=500, yScale=tempYScale} )
	--print("WaterLevel: "..value)
	transition.to( waterAnimation, {time = 500, y=waterBar.y - waterBar.height*tempYScale - 16})
	print("WaterLevel: "..value)
end

function updateWaterLevel(direction)
	local nenner = Level[currentLevel].taskGoal * #connectedClient
	if (direction == "down") then
		waterLevel = waterLevel - (Level[currentLevel].waterStart / nenner)
		print(direction)
	elseif (direction == "up") then
		waterLevel = waterLevel + (Level[currentLevel].waterStart / nenner)
	end
	--print("Water went "..direction)
	sendStuff(waterLevel,"water",gameChannel)
	if (waterLevel <= 0) then
		print("Level done")
		sendStuff("next","level",gameChannel)
	end

	if (waterLevel >= 100) then
		--print("GAME OVER!")
		sendStuff("lost","level",gameChannel)
	end
end