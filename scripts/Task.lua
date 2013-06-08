Task = {}

local function chooseValue(type)
	local value
	print("type = "..tostring(type))
	
	if (type == 1) then
		value = math.random (0,1)
	elseif (type == 2) then
		value = math.random(0,360)
	elseif (type == 3) then
		value = math.random(0,10)
	else
		value = 999
	end
	return value
end

function Task:new(element)

	local task = {}

	task.skinID = element.skinID -- ID des ELements, auf das sich der Task bezieht

	task.value = chooseValue(element.type)

	return task
end