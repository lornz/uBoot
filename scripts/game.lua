connectedClient = {}
function initUBootOld()
	-- initialisiert das uBoot bei allen Spielern
	for key, value in pairs(player) do 
		connectedClient[key] =  Client:new()
		sendStuff(connectedClient[key],"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
    end
end

function initUBoot()	-- initialisiert das uBoot bei allen Spielern
	local i = 1
	for key, value in pairs(player) do 
		connectedClient[i] =  Client:new(value.uuid)
		sendStuff(connectedClient[i],"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
		i = i + 1
    end
end

function initTasks()
	-- initialisiert Tasks für alle Spieler
	-- TODO: Task nicht immer fürs eigene Board!!!
	local randomClient
	local randomElement
	local tempTask
	--local i = 1
	for key, value in pairs(connectedClient) do 
		randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
		randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus
		--local taskTemp = Task:new(connectedClient[temp].board.elements)
		--print(temp)
		--print("---")
		--print(connectedClient[temp].board.elements[temp2].skinID)
		tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement]) -- Erstellt neuen Task für gewähltes Element
		sendStuff(tempTask,"task",gameChannel,connectedClient[key].uuid)
		--print("New task for Client: "..connectedClient[randomClient].uuid)
		--print(taskTemp.skinID)
		--print(taskTemp.value)
		--print("!!!!")
    end
end
