local sprite = require("sprite")


local function setupBinaryControl(element, imageBackground, group) 
	--Hintergrund (Board)
	local board = display.newImage( "media/gfx/binaryControlBoard.png" )
	board:setReferencePoint(display.CenterReferencePoint)
	board.x = imageBackground.x + 256
	board.y = imageBackground.y + 64
	board.xScale = 2
	board.yScale = 2
	board.value = element.value
	group:insert(board)

	local sheet1 = sprite.newSpriteSheet( "media/gfx/binaryButton.png", 32, 32 )
	local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 2)
	sprite.add( spriteSet1, "an", 1, 1, 1, 0 )
	sprite.add( spriteSet1, "aus", 2, 1, 1, 0 )

	local initValue = element.value
	local buttons = {} 
	--buttons erzeugen und korrekt positionieren
	for i = 1, 4 do
		buttons[i] = {}
		buttons[i] = sprite.newSprite( spriteSet1 )
		buttons[i].number = math.pow(2,4-i)
		if(buttons[i].number <= initValue) then
			initValue = initValue - buttons[i].number
			buttons[i].state = true
			buttons[i]:prepare("an")
		else
			buttons[i].state = false
			buttons[i]:prepare("aus")
		end
		buttons[i]:play()
		buttons[i].x = board.x + (i-2)*128 - 64
		buttons[i].y = board.y - 16
		
		print(buttons[i].number)
		group:insert(buttons[i])
	end
	
	--Anzeige für eingestellte Zahl
	board.numberDisplay = display.newText(board.value, board.x, board.y + 24, native.systemFont,24)
	board.numberDisplay:setReferencePoint(display.CenterReferencePoint)
	board.numberDisplay.x = board.x
	group:insert(board.numberDisplay)
	return buttons, board
end

local function binaryControlFunctionality(element, buttons, board)
	--Button Funcionality
	local function buttonTap(event)
		local number = event.target.number
		local button = event.target
		local buttonState = event.target.state
		local id = event.target.skinID
		if(buttonState == false) then
			event.target.state = true
			button:prepare("an")
			button:play()
			board.value = board.value + number
		elseif(buttonState == true) then
			event.target.state = false
			button:prepare("aus")
			button:play()
			board.value = board.value - number
		end
		--update numberDisplay
		board.numberDisplay.text = board.value
		element.value = board.value
		sendStuff(element,"update",gameChannel)-- Nachricht an Server absetzen über Statusänderung
	end
	for i = 1, 4 do
		buttons[i]:addEventListener("tap", buttonTap)
	end
end

function createBinaryControl(imageBackground, element, group) 
	local buttons, board = setupBinaryControl(element, imageBackground, group)
	binaryControlFunctionality(element, buttons, board)
end