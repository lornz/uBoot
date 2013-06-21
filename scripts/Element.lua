local sprite = require("sprite")
require("scripts.FileAccess")
require("scripts.Elements.Button")
require("scripts.Elements.Steeringwheel")
require("scripts.Elements.Pumpe")
require("scripts.Elements.Slider")
require("scripts.Elements.BinaryControl")

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
binaryLabels = loadLabels("binaryLabels.txt", 400)

function getAllowedValues(elementType,currentValue)
	-- gibt für einen bestimmten Element-type einen zufälligen erlaubten Wert zurück 
	-- der vom aktuellen Wert verschieden ist
	if (elementType == 1) then
		-- TOGGLE BUTTON --
		value = math.random (0,1)
	elseif (elementType == 2) then
		-- STEERING WHEEL --
		value = math.random(0,359)
	elseif (elementType == 3) then
		-- PUMPE --
		value = math.random(1,10)
	elseif (elementType == 4) then
		-- SLIDER --
		value = math.random(1,5)
	elseif (elementType == 5) then
		-- BINARY --
		value = math.random(0,15)
	end

	if (value == currentValue) then
		print("Wert "..value.." bereits gesetzt, wähle neuen")
		return getAllowedValues(elementType,currentValue)
	else
		return value
	end
end

local function chooseElement(sizeX)

	local function validSkinID(skinID)
		if (usedSkins[skinID] == nil) then
			usedSkins[skinID] = skinID
			return true
		else
			print("skinID in use")
			return false
		end
	end

	local function randomSkinID(sizeX)
		local skinID = math.random(sizeX*100, (sizeX*100)+100) -- 1 breite Skins bei 100 bis 199
		local elementType = nil

		--es gibt nur bestimmte Anzahl an buttonLabels, daher darf die skinID nicht beliebig groß sein
		if(skinID < 150) then
			-- TOGGLE BUTTON --
			elementType = 1
			skinID = math.random(1, #buttonLabels) + 100
		end

		if(skinID >= 150 and skinID < 200) then
			-- STEERING WHEEL --
			elementType = 2
			skinID = math.random(1, #steeringwheelLabels) + 150
		end

		if(skinID >= 200 and skinID < 300) then
			-- SLIDER --
			elementType = 4
			skinID = math.random(1, #sliderLabels) + 200
		end

		if(skinID >= 300 and skinID < 400) then
			-- PUMPE --
			elementType = 3
			skinID = math.random(1, #pumpeLabels) + 300
		end

		if(skinID >= 400 and skinID < 500) then
			-- Binary --
			elementType = 5
			skinID = math.random(1, #binaryLabels) + 400
		end

		return skinID, elementType
	end

	skinID, elementType = randomSkinID(sizeX)
	while (not(validSkinID(skinID))) do
		skinID, elementType = randomSkinID(sizeX)
	end

	return skinID, elementType
end

function Element:new(sizeX,position)
	local element = {}

	element.sizeX = sizeX

	element.position = position

	element.state = true -- nicht in Benutzung?

	element.skinID, element.type = chooseElement(sizeX)

	element.value = getAllowedValues(element.type,999)

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
		createSteeringwheel(imageBackground, element, group)
	end

	if(element.type == 3) then
		createPumpe(imageBackground, element, group)
	end

	if(element.type == 4) then
		createSlider(imageBackground, element, group)
	end

	if(element.type == 5) then
		createBinaryControl(imageBackground, element, group)
	end

	print(id)
	elementLabel = display.newText(labelBank[id], imageBackground.x, imageBackground.y, native.systemFont, 24)
	elementLabel:setReferencePoint(display.CenterReferencePoint)
	elementLabel.x = imageBackground.x + (s*64)
	print(elementLabel.x)
	group:insert(elementLabel)
end