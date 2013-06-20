local sprite = require("sprite")

local function setupPumpe(imageBackground, group, element)
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
	group:insert(pumpe)
	group:insert(pumpe.valueText)
	return pumpe
end

local function setupPumpeFunctionality(pump, element, imageBackground)
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
						t.value = t.value + 1
					end
					t.x = imageBackground.x + 384 - 64
					t.state = 1
					t.valueText.text = t.value
				elseif(t.x < imageBackground.x + 64) then
					if(t.state == 1) then
						t.value = t.value + 1
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
			element.value = t.value
			sendStuff(element,"update",gameChannel) --Nachricht an Server absetzen über Statusänderung
		end
	end	
	pumpe:addEventListener("touch", movePumpe)
end

function createPumpe(imageBackground, element, group)
	pumpe = setupPumpe(imageBackground, group, element)
	setupPumpeFunctionality(pump, element, imageBackground)
end