local sprite = require("sprite")
require("scripts.FileAccess")
require("scripts.Elements.Button")

Element = {}
usedSkins = {}

labelBank = {} --labelBank für alle Labels, jedes Label liegt an labelBank[skinID]

local function loadLabels(labelList, labelBankStartIndex) 
	labelList = lines_from(labelList, system.ResourceDirectory)
	labelList.bankIndex = labelBankStartIndex
	for i = 1, #labelList do
		labelBank[labelBankStartIndex + i] = labelList[i]
	end
	return labelList
end

buttonLabels = loadLabels("buttonLabels.txt", 100)
steeringwheelLabels = loadLabels("steeringwheelLabels.txt", 150)
sliderLabels = loadLabels("sliderLabels.txt", 200)
pumpeLabels = loadLabels("pumpeLabels.txt", 300)
dummyLabels = loadLabels("dummyLabels.txt", 400)

for i = 1, #dummyLabels do
	print(dummyLabels[i])
end

local function detectType(s, id)
	local type

	-- Zuordnung von Type je nach skinID
	if(s == 1 and id < 150) then		-- Button:		Werte = 1/0 (an/aus)
		type = 1
	elseif(s == 1 and id >= 150) then	-- Steuerrad:	Werte = 0-360 (Grad)
		type = 2		
	end		
	if(s == 3)	then					-- Pumpe:		Werte = 0-10 (Füllstand)
		type = 3 	
	end

	if(s == 2) then
		type = 4                        --Slider: 		Werte = 1-5
	end
	
	return type
end

local function chooseSkin(sizeX)
	local skinID = math.random(sizeX*100, (sizeX*100)+100) -- 1 breite Skins bei 100 bis 199

	--es gibt nur bestimmte Anzahl an buttonLabels, daher darf die skinID nicht beliebig groß sein
	if(skinID < 150) then
		skinID = math.random(1, #buttonLabels) + 100
	end

	if(skinID >= 150 and skinID < 200) then
		skinID = math.random(1, #steeringwheelLabels) + 150
	end

	if(skinID >= 200 and skinID < 300) then
		skinID = math.random(1, #sliderLabels) + 200
	end

	if(skinID >= 300 and skinID < 400) then
		skinID = math.random(1, #pumpeLabels) + 300
	end

	if(skinID >= 400 and skinID < 500) then
		skinID = math.random(1, #dummyLabels) + 400
	end


	if (usedSkins[skinID] == nil) then
		usedSkins[skinID] = skinID
		return skinID
	else
		print("skinID "..skinID.." already in use - choosing another!")
		return chooseSkin(sizeX)
	end
end

function Element:new(sizeX,position)
	local element = {}

	element.sizeX = sizeX

	element.position = position

	element.state = true

	element.value = 0 -- zu Beginn jeder Regler auf Null, jeder Schalter aus

	element.skinID = chooseSkin(sizeX)

	element.type = detectType(sizeX,element.skinID) -- Typ des Buttons (normaler Button (an/aus), Steuerrad, Pumpe, etc) für die Tasks

	Element[element.skinID] = element

	return element
end



function displayImage(element,group)
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
	group:insert(imageBackground)
	


	if(element.type == 1) then
		createButton(imageBackground,element,group)
	end

	if(element.type == 2) then
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


		local oldX = 0
		local oldY = 0
		local yLeft = 0
		local yRight = 0
		local circulation = 0

		function isBetween(x,z1,z2) 
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

	if(element.type == 3) then
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

	if(element.type == 4) then
		local sliderBoard = display.newImage( "media/gfx/sliderBoard.png" )
		sliderBoard:setReferencePoint(display.CenterReferencePoint)
		sliderBoard.x = imageBackground.x + 128
		sliderBoard.y = imageBackground.y + 64
		group:insert(sliderBoard)

		local marker = display.newImage( "media/gfx/greenMarker2.png" )
		marker:setReferencePoint(display.CenterReferencePoint)
		-- 1 -> -85 , 2 -> -44, 3 -> 0, 4 -> 45, 5 -> +85
		marker.x = sliderBoard.x - 85
		marker.y = sliderBoard.y
		marker.value = 1
		group:insert(marker)

		local function moveMarker(event) 
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
					if(t.x - sliderBoard.x < -85) then
						t.x = sliderBoard.x - 85
					end
					if(t.x - sliderBoard.x > 85) then
						t.x = sliderBoard.x + 85
					end
				end
			end
			if(phase == "ended") then
				distance = t.x - sliderBoard.x
					
				if(distance < -62) then
					t.x = sliderBoard.x - 85
					t.value = 1
				elseif(distance >= -62 and distance < -22) then
					t.x = sliderBoard.x - 44
					t.value = 2
				elseif(distance >= -22 and distance < 22) then
					t.x = sliderBoard.x
					t.value = 3
				elseif(distance >= 22 and distance < 62) then
					t.x = sliderBoard.x + 45
					t.value = 4
				elseif(distance >= 62) then
					t.x = sliderBoard.x + 85
					t.value = 5
				end
				element.value = t.value
				sendStuff(element,"update",gameChannel) --Nachricht an Server absetzen über Statusänderung
				display.getCurrentStage():setFocus(t, nil )
				t.isFocus      = false
			end
		end
		marker:addEventListener("touch", moveMarker)
	end
	print(id)
	elementLabel = display.newText(labelBank[id], imageBackground.x, imageBackground.y, native.systemFont, 24)
	elementLabel:setReferencePoint(display.CenterReferencePoint)
	elementLabel.x = imageBackground.x + (s*64)
	print(elementLabel.x)
	group:insert(elementLabel)
end