local sprite = require("sprite")

Element = {}
usedSkins = {}

labelBank = {} --labelBank für alle Labels, jedes Label liegt an labelBank[skinID]

buttonLabels = {}

--etwas blöder Code, der hoffentlich bald durch FileReader ersetzt wird
buttonLabels[1] = "Megaquark"
buttonLabels[2] = "Quantumbose"
buttonLabels[3] = "Periskopum"
buttonLabels[4] ="Hyperdrill"
buttonLabels[5] ="Gravitator"
buttonLabels[6] ="Lyghtbums"
buttonLabels[7] ="Pullmorser"
buttonLabels[8] ="Zytenborst"

for i = 1, #buttonLabels do 
	labelBank[100 + i] = buttonLabels[i]
end

steeringwheelLabels = {}

steeringwheelLabels[1] = "Course"
steeringwheelLabels[2] = "Engine-Temperatur"
steeringwheelLabels[3] = "Quantrum"
steeringwheelLabels[4] = "Steerix"
steeringwheelLabels[5] = "Controx"
steeringwheelLabels[6] = "Roboxon"
steeringwheelLabels[7] = "Billie"
steeringwheelLabels[8] = "Nuclear Rembose"

for i = 1, #steeringwheelLabels do 
	labelBank[150 + i] = buttonLabels[i]
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
	
	return type
end

local function chooseSkin(sizeX)
	local skinID = math.random(sizeX*100, (sizeX*100)+100) -- 1 breite Skins bei 100 bis 199

	--es gibt nur bestimmte Anzahl an buttonLabels, daher darf die skinID nicht beliebig groß sein
	if(skinID < 150) then
		skinID = math.random(1, #buttonLabels) + 100
	end

	if(skinID >= 150) then
		skinID = math.random(1, #steeringwheelLabels) + 150
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

	if(element.type == 1) then
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
		button.label = display.newText(labelBank[id], 0, 0, native.systemFont, 25)
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
				element.state = true
				sendStuff(element,"update",gameChannel)--TODO: hier Nachricht an Server absetzen über Statusänderung
			elseif(state == 1) then
				button:prepare("button1")
				button:play()
				button.state = 0
				element.state = false
				sendStuff(element,"update",gameChannel)--TODO: hier Nachricht an Server absetzen über Statusänderung
			end
			print("button " .. id .. ": state = " .. state)
		end
		button:addEventListener("tap", buttonTap)
	elseif(element.type == 2) then
		local steeringwheel = display.newImage("media/gfx/steuerrad.png")
		steeringwheel.x = imageBackground.x + 64
		steeringwheel.y = imageBackground.y + 64
		steeringwheel.rotation = 0
		steeringwheel.label = display.newText(labelBank[id] .. "°", 0, 0, native.systemFont, 32)
		steeringwheel.label:setReferencePoint(display.CenterReferencePoint)
		steeringwheel.label.x = steeringwheel.x
		steeringwheel.label.y = steeringwheel.y - 34
		steeringwheel.degrees = display.newText(steeringwheel.rotation .. "°", 0, 0, native.systemFont, 32)
		steeringwheel.degrees:setReferencePoint(display.CenterReferencePoint)
		steeringwheel.degrees.x = steeringwheel.x
		steeringwheel.degrees.y = steeringwheel.y
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
					print(circulation)
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