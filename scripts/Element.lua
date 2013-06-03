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
		local sheet1 = sprite.newSpriteSheet( "media/gfx/11buttonSprite.png", 96, 96 )
		local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 2)
		sprite.add( spriteSet1, "button1", 1, 1, 1, 0 )
		sprite.add( spriteSet1, "button2", 2, 1, 1, 0 )  
		local button = sprite.newSprite( spriteSet1 )
		button:prepare("button1")
		button:play()       
		button.x = imageBackground.x + 64
		button.y = imageBackground.y + 64
		button.state = 0

		function buttonTap(event)
			local button = event.target
			local state = event.target.state
			print("state = " .. state)
			if(state == 0) then
				button:prepare("button2")
				button:play()
				button.state = 1
				--TODO: hier Nachricht an Server absetzen über Statusänderung
			elseif(state == 1) then
				button:prepare("button1")
				button:play()
				button.state = 0
				--TODO: hier Nachricht an Server absetzen über Statusänderung
			end
		end
		button:addEventListener("tap", buttonTap)
	end
end