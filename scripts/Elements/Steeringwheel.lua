local sprite = require("sprite")

local function updateRotation(newRotation)
	steeringwheel.rotation = newRotation
	steeringwheel.degrees.text = steeringwheel.rotation .. "°"
end

local function setupSteeringwheel(group, imageBackground)
	local steeringwheel = display.newImage("media/gfx/steuerrad.png")
	steeringwheel.x = imageBackground.x + 64
	steeringwheel.y = imageBackground.y + 64
	steeringwheel.rotation = 0
	steeringwheel.degrees = display.newText(steeringwheel.rotation .. "°", 0, 0, native.systemFont, 32)
	steeringwheel.degrees:setReferencePoint(display.CenterReferencePoint)
	steeringwheel.degrees.x = steeringwheel.x
	steeringwheel.degrees.y = steeringwheel.y
	group:insert(steeringwheel)
	group:insert(steeringwheel.degrees)
	---steeringwheel:setTextColor(0, 255, 0)
	return steeringwheel
end

local function setupSteeringwheelFunctionality(steeringwheel, element) 
	local oldX = 0
	local oldY = 0
	local yLeft = 0
	local yRight = 0
	local circulation = 0

	local function isBetween(x,z1,z2) 
		--checks if x is between z1 and z2 (with z1 < z2)
		if(x >= z1 and x <= z2) then
			return true
		else
			return false
		end
	end
	
	local function rotateSteeringWheel(event) 
		local t = event.target
		local phase = event.phase
		local oldRotation = t.rotation
		if(phase == "began") then
			display.getCurrentStage():setFocus( t, event.id )
			t.isFocus = true
			t.x0 = event.x
			t.x5 = event.x + 1
			oldX = event.x
		elseif(t.isFocus) then
			if "moved" == phase then
				if(isBetween(event.x,t.x0,t.x5)) then
					if(event.x > oldX) then
						yRight = event.y
					elseif(event.x < oldX) then
						yLeft = event.y
					end
				end
				if(yRight > yLeft) then 
					circulation = -1
				elseif(yLeft > yRight) then
					circulation = 1
				end
				if((circulation == 1 and event.x < t.x0) or (circulation == -1 and event.x < t.x0)) then
					t.rotation = oldRotation + (oldY - event.y)/10
				else 
					t.rotation = oldRotation + (event.y - oldY)/10
				end
				t.degrees.text = math.floor(t.rotation) .. "°"
			end
			oldX = event.x
			oldY = event.y
		end
		if(event.phase == "ended" or phase == "cancelled") then
			display.getCurrentStage():setFocus(t, nil )
			t.isFocus      = false
			element.value = math.floor(t.rotation)
			sendStuff(element,"update",gameChannel) --Nachricht an Server absetzen über Statusänderung
		end
	end	
	steeringwheel:addEventListener("touch", rotateSteeringWheel)
end



function createSteeringwheel(imageBackground, element, group) 
	steeringwheel = setupSteeringwheel(group, imageBackground)
	updateRotation(element.value)
	setupSteeringwheelFunctionality(steeringwheel, element)		
end