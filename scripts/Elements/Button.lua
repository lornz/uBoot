local sprite = require("sprite")

local function setupButton(element, imageBackground, group) 
	local sheet1 = sprite.newSpriteSheet( "media/gfx/11buttonSprite.png", 96, 96 )
	local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 2)
	sprite.add( spriteSet1, "button1", 1, 1, 1, 0 )
	sprite.add( spriteSet1, "button2", 2, 1, 1, 0 )  
	local button = sprite.newSprite( spriteSet1 )
	if(element.value == 0) then
		button:prepare("button1")
	elseif(element.value == 1) then
		button.prepare("button2")
	end
	button:play()
	button.x = imageBackground.x + 64
	button.y = imageBackground.y + 64
	button.state = element.value
	button.skinID = element.skinID
	group:insert(button)
	return button
end

function createButton(imageBackground, element, group)
	button = setupButton(element, imageBackground, group)       
	

	--Button Funcionality
	function buttonTap(event)
		local button = event.target
		local state = event.target.state
		local id = event.target.skinID
		if(state == 0) then
			button:prepare("button2")
			button:play()
			button.state = 1
			element.state = true
		elseif(state == 1) then
			button:prepare("button1")
			button:play()
			button.state = 0
			element.state = false
		end
	end
	element.value = button.state
	sendStuff(element,"update",gameChannel)-- Nachricht an Server absetzen über Statusänderung
	button:addEventListener("tap", buttonTap)
end