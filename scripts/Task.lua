Task = {}

function Task:new(element,uuid)

	local task = {}

	task.skinID = element.skinID -- ID des ELements, auf das sich der Task bezieht
	
	task.value = getAllowedValues(element.type,element.value)

	task.uuid = uuid -- welche uuid bekommt den task angezeigt

	task.time = 10*Level[currentLevel].timeFactor -- TODO: je nach type des Elements Zeit wählen

	Task[task] = task

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

		tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement],connectedClient[key].uuid) -- Erstellt neuen Task für gewähltes Element
		sendStuff(tempTask,"task",gameChannel,connectedClient[key].uuid)
    end
end

function decreaseTime()
   taskTime = taskTime-1
   taskCountdown.text = taskTime

   if(taskTime == 0) then
   		-- Bestrafung!
   		local taskMissed = {}
   		taskMissed.value = 9999
   		sendStuff(taskMissed,"update",gameChannel)-- Nachricht an Server absetzen über Statusänderung
   		--sendStuff("up","water",gameChannel)
   else
   		--update timerBar
   		--timerBar.xScale = taskTime/15 --taskTime/initialTime
   		timerBar.xScale = taskTime/(Level[currentLevel].timeFactor * 10) --taskTime/initialTime
	end
end

function taskDone(element,senderUUID)
	-- löscht einen Task für ein Element, wenn er erfüllt wurde und erzeugt einen neuen

	for key, value in pairs(Task) do 
		if (key.skinID == element.skinID) then
			if (element.value == key.value) then
				-- Task rechtzeitig erledigt
				print("Task erfüllt, sende neuen")				
				updateWaterLevel("down")
				

				local randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
				local randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus
				local tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement],Task[key].uuid)

				sendStuff(tempTask,"task",gameChannel,Task[key].uuid)
				Task[key] = nil -- alten Task löschen

			end
		end
	end
	
	if (element.value == 9999) then
		-- Task nicht rechtzeitig erledigt
		for key, value in pairs(Task) do 
			if (key.uuid == senderUUID) then
				print("Task NICHT erfüllt, sende neuen")
				updateWaterLevel("up")

				local randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
				local randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus
				local tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement],Task[key].uuid)
				
				sendStuff(tempTask,"task",gameChannel,Task[key].uuid)
				Task[key] = nil -- alten Task löschen
			end
		end
	end

end

function suddenTask()
	local suddenValue = math.random(1,12)
	print("suddenValue: "..suddenValue)
	if (suddenValue > 10) then
		if (suddenValue == 11) then
			return "Shake your uBoot!"
		elseif (suddenValue == 12) then
			return "Turn your uBoot around!"
		end
	else
		return nil
	end
end

function timerVisual(parentGroup)
	timerBarLength = 512
	timerBar = display.newRect( parentGroup, 144, 8, timerBarLength, 64 )
	timerBar:setFillColor(0, 255, 0, 100)
end