local sprite = require("sprite")

function initMarkerDisplay(marker, sliderBoard)
	-- 1 -> -85 , 2 -> -44, 3 -> 0, 4 -> 45, 5 -> +85
	if(marker.value == 1) then
		marker.x = sliderBoard.x - 85
	elseif(marker.value == 2) then
		marker.x = sliderBoard.x - 44
	elseif(marker.value == 3) then
		marker.x = sliderBoard.x
	elseif(marker.value == 4) then
		marker.x = sliderBoard.x + 45
	elseif(marker.value == 5) then
		marker.x = sliderBoard.x + 85
	end
	marker.y = sliderBoard.y
	return marker
end

function setupSlider(imageBackground, group, element) 
	local sliderBoard = display.newImage( "media/gfx/sliderBoard.png" )
	sliderBoard:setReferencePoint(display.CenterReferencePoint)
	sliderBoard.x = imageBackground.x + 128
	sliderBoard.y = imageBackground.y + 64
	group:insert(sliderBoard)

	local marker = display.newImage( "media/gfx/greenMarker2.png" )
	marker:setReferencePoint(display.CenterReferencePoint)
	marker.value = element.value
	marker = initMarkerDisplay(marker, sliderBoard)
	group:insert(marker)
	return marker, sliderBoard
end

function setupSliderFunctionality(marker, sliderBoard, element)
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

function createSlider(imageBackground, element, group)
	marker, sliderBoard = setupSlider(imageBackground, group, element)
	setupSliderFunctionality(marker, sliderBoard, element)
end