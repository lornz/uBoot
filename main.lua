require("scripts.Client")
require("scripts.Board")
require("scripts.Element")

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



local function displayImage(element)

	

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

	end
end

local client1 = Client:new()

i = 1
while(not(client1.board.elements[i] == nil)) do 
	print ("position = " .. client1.board.elements[i].position .. " , size = " ..client1.board.elements[i].sizeX .. " , skinID = " .. client1.board.elements[i].skinID)
	displayImage(client1.board.elements[i])
	i = i + 1
end


