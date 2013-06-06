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
	local id = element.skinID
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

	if(s == 1 and id < 150) then
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
		button.skinID = element.skinID
		button.label = display.newText(element.skinID, 0, 0, native.systemFont, 25)
		button.label:setReferencePoint(display.centerReferencePoint)
		button.label.x = button.x
		button.label.y = button.y

		function buttonTap(event)
			local button = event.target
			local state = event.target.state
			local id = event.target.skinID
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
			print("button " .. id .. ": state = " .. state)
		end
		button:addEventListener("tap", buttonTap)
	elseif(s == 1 and id >= 150) then
		local steeringwheel = display.newImage("media/gfx/steuerrad.png")
		steeringwheel.x = imageBackground.x + 64
		steeringwheel.y = imageBackground.y + 64
		steeringwheel.rotation = 0
		steeringwheel.label = display.newText(steeringwheel.rotation .. "°", 0, 0, native.systemFont, 32)
		steeringwheel.label:setReferencePoint(display.CenterReferencePoint)
		steeringwheel.label.x = steeringwheel.x
		steeringwheel.label.y = steeringwheel.y
		---steeringwheel:setTextColor(0, 255, 0)

		local function rotateSteeringWheel(event) 
			local t = event.target
			local phase = event.phase
			local oldRotation = t.rotation
			print(phase)
			if(phase == "began") then
				display.getCurrentStage():setFocus( t, event.id )
				t.isFocus = true
				t.x0 = event.x
			elseif(t.isFocus) then
				if "moved" == phase then
					t.rotation = oldRotation + (event.x - t.x0)/500
					t.label.text = math.floor(t.rotation) .. "°"
				end
			end
			if(event.phase == "ended" or phase == "cancelled") then
				display.getCurrentStage():setFocus(t, nil )
				t.isFocus      = false
			end
		end	

		steeringwheel:addEventListener("touch", rotateSteeringWheel)
	end

	if(s == 3) then
		local sheetPumpe = sprite.newSpriteSheet( "media/gfx/roterKnopfSprite.png", 64, 64 )
		local spriteSetPumpe = sprite.newSpriteSet(sheetPumpe, 1, 2)
		sprite.add( spriteSetPumpe, "pumpe1", 1, 1, 1, 0 )
		sprite.add( spriteSetPumpe, "pumpe2", 2, 1, 1, 0 )  
		local pumpe = sprite.newSprite( spriteSetPumpe )
		pumpe:prepare("pumpe1")
		pumpe:play()       
		pumpe.x = imageBackground.x + 64
		pumpe.y = imageBackground.y + 64
		pumpe.value = 0
		pumpe.state = 0
		pumpe.valueText = display.newText(pumpe.value, 0, 0, native.systemFont, 64)
		pumpe.valueText:setReferencePoint(display.CenterReferencePoint)
		pumpe.valueText.x = imageBackground.x + 192
		pumpe.valueText.y = imageBackground.y + 64
		pumpe.skinID = element.skinID

		local function movePumpe(event) 
			local t = event.target
			local phase = event.phase
			if(phase == "began") then
				display.getCurrentStage():setFocus( t, event.id )
				t.isFocus = true
				t.x0 = event.x - t.x
				t.y0 = event.y - t.y
			elseif(t.isFocus) then
				if "moved" == phase then
					t.x = event.x - t.x0
					--t.value = t.value - 1
					if(t.x > imageBackground.x + 384 - 64) then
						if(t.state == 0) then
							t.value = t.value - 1
						end
						t.x = imageBackground.x + 384 - 64
						t.state = 1
						t.valueText.text = t.value
					elseif(t.x < imageBackground.x + 64) then
						if(t.state == 1) then
							t.value = t.value - 1
						end
						t.x = imageBackground.x + 64
						t.state = 0
						t.valueText.text = t.value
					end
				end
			end
			if(phase == "ended" or phase == "cancelled") then
				display.getCurrentStage():setFocus(t, nil )
				t.isFocus      = false
			end
		end	

		pumpe:addEventListener("touch", movePumpe)
	end
end