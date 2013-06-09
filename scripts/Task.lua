Task = {}

local function chooseValue(type)
	local value
	print("type = "..tostring(type))
	
	if (type == 1) then
		value = math.random (0,1)
	elseif (type == 2) then
		value = math.random(0,360)
	elseif (type == 3) then
		value = math.random(1,10)
	elseif (type == 4) then
		value = math.random(1,5)
	else
		value = 999
	end
	return value
end


function decreaseTime()
   taskTime = taskTime-1
   taskCountdown.text = taskTime
   if(taskTime == 0) then
   		-- Bestrafung!
   	end
end

function Task:new(element,uuid)

	local task = {}

	task.skinID = element.skinID -- ID des ELements, auf das sich der Task bezieht
	
	task.value = chooseValue(element.type)

	task.uuid = uuid -- welche uuid bekommt den task angezeigt

	task.time = 15 -- TODO: je nach type des Elements Zeit wählen und je nach Level

	Task[task] = task
	--print("created task: "..tostring(task))

	return task
end

function initTasks()
	-- initialisiert Tasks für alle Spieler
	local randomClient
	local randomElement
	local tempTask
	for key, value in pairs(connectedClient) do 
		randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
		randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus

		-- TODO: Prüfen, ob für ein Element schon ein Task besteht
		tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement],connectedClient[key].uuid) -- Erstellt neuen Task für gewähltes Element
		sendStuff(tempTask,"task",gameChannel,connectedClient[key].uuid)
    end
    --printTasksDebug()
end

function taskDone(element,senderUUID)
	-- löscht einen Task für ein Element, wenn er erfüllt wurde und erzeugt einen neuen
	for key, value in pairs(Task) do 
		if (key.skinID == element.skinID) then
			print("neuer Wert: "..tostring(element.value) )
			print("zu erreichender Wert: "..tostring(key.value) )
			if (element.value == key.value) then
				print("Task erfüllt")

				local randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
				local randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus
				local tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement],Task[key].uuid)

				sendStuff(tempTask,"task",gameChannel,Task[key].uuid)
				print("Neuer Task versendet!")
				Task[key] = nil -- alten Task löschen
			end
		end
	end
end