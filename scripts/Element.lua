local sprite = require("sprite")

Element = {}


local function chooseSkin(sizeX)
	local skinID = math.random(sizeX*100, (sizeX*100)+99) -- 1 breite Skins bei 100 bis 199

	return skinID
end

function Element:new(sizeX,position)
	local element = {}

	element.sizeX = sizeX

	element.position = position

	element.state = true

	element.value = 0 -- zu Beginn jeder Regler auf Null, jeder Schalter aus

	element.skinID = chooseSkin(sizeX)

	return element
end

local function toggleButtonPressed(event) 
	t = event.target
	if(event.phase == "ended") then
		if(t.state == false) then
			old = t
			t = display.newImage( "media/gfx/11buttonGreen.png" )
			t.x = old.x
			t.y = old.y
			old:removeSelf()
			t.state = true
			t:addEventListener("touch", toggleButtonPressed)
			return true
		else
			old = t
			t = display.newImage( "media/gfx/11buttonRed.png" )
			t.x = old.x
			t.y = old.y
			old:removeSelf()
			t.state = false
			t:addEventListener("touch", toggleButtonPressed)
			return false
		end
	end
end


function displayImage(element)
	local s = element.sizeX
	print("s = " .. s)
	local imageBackground = nil
	if(s == 1) then
		imageBackground = display.newImage( "media/gfx/11bg.png" )
	elseif(s == 2) then
		imageBackground = display.newImage( "media/gfx/12bg.png" )
	elseif(s == 3) then
		imageBackground = display.newImage( "media/gfx/13bg.png" )
	elseif(s == 4) then
		imageBackground = display.newImage( "media/gfx/14bg.png" )
	else
		print("couldn't find matching background image")
	end
	imageBackground:setReferencePoint(display.TopLeftReferencePoint)
	imageBackground.x = 144 + math.mod((element.position-1),4)*128
	imageBackground.y = 72 + (math.floor(element.position/5))*128

	if(s == 1) then
		local currentButton = display.newImage( "media/gfx/11buttonRed.png" )
		currentButton.x = imageBackground.x + 64
		currentButton.y = imageBackground.y + 64
		currentButton.isVisible = true
		currentButton.state = false
		local buttonState = 0
		print(buttonState)
		buttonState = currentButton:addEventListener("touch", toggleButtonPressed) -- hier kommt irgendwie immer nil als return, TODO: herausfinden warum das so ist, eigentlich braucht man an dieser Stelle den neuen Status
		print(buttonState)
		textLabel = display.newText(element.skinID,0, 0, native.systemFont, 16)
		textLabel:setReferencePoint(display.CenterReferencePoint)
		textLabel.x = currentButton.x
		textLabel.y = currentButton.y
	end
end
