Task = {}

function Task:new(element,uuid)

	local task 	= {}

	task.skinID = element.skinID -- ID des ELements, auf das sich der Task bezieht
	
	task.value 	= getAllowedValues(element.type,element.value)

	task.uuid 	= uuid -- welche uuid bekommt den task angezeigt

	task.time 	= 10*Level[currentLevel].timeFactor 

	Task[task] 	= task

	return task
end

function initTasks()
	-- initialisiert Tasks für alle Spieler
	local randomClient
	local randomElement
	local tempTask
	for key, value in pairs(connectedClient) do 
		randomClient 	= math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
		randomElement 	= math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus

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
   else
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

function createShakeEvent()
	if (suddenTaskActivated == false) then
		-- nur wenn bisher kein suddenTask im Raum steht

		local function onShake (event)
	    	if event.isShake then
	    		Runtime:removeEventListener( "accelerometer", onShake )
	    		suddenTaskActivated = false
	    		timer.cancel( shakeEventTimer )
	    		shakebackground:setFillColor( 20, 190, 20)
	        	shakeCommand.text = "Shaked!"

	        	local function hideShake()
	        		storyboard.hideOverlay("scripts.SceneShake", transitionOptions)
	        	end
	        	timer.performWithDelay( 500, hideShake,  1)
	    	end
		end
		Runtime:addEventListener("accelerometer", onShake)

		local function suddenTaskFailed(event)
			Runtime:removeEventListener( "accelerometer", onShake )
			suddenTaskActivated = false
			sendStuff("failed","suddenTask",gameChannel)
			shakebackground:setFillColor( 225, 50, 20)
			shakeCommand.text = "Failed!"
			
			local function hideShake()
	        		storyboard.hideOverlay("scripts.SceneShake", transitionOptions)
	        end
			timer.performWithDelay( 500, hideShake,  1)
		end
		shakeEventTimer = timer.performWithDelay( 5000, suddenTaskFailed,  1)
		print("Shake your uBoot!")

		suddenTaskActivated = true
		storyboard.showOverlay("scripts.SceneShake", transitionOptions)
	end
end

suddenTaskActivated = false
function suddenTask()
	local suddenValue = math.random(1,12)
	print("suddenValue: "..suddenValue)
	if (suddenValue < 12) then
		sendStuff("shake","suddenTask",gameChannel)
	end
	if (suddenValue == 12) then
		sendStuff("flip","suddenTask",gameChannel)
	end
end

function timerVisual(parentGroup)
	timerBarLength = 512
	timerBar = display.newRect( parentGroup, 144, 8, timerBarLength, 64 )
	timerBar:setFillColor(0, 255, 0, 100)
end