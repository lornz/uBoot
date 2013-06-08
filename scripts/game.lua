connectedClient = {}

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
	local randomClient
	local randomElement
	local tempTask
	for key, value in pairs(connectedClient) do 
		randomClient = math.random(1,#connectedClient) -- wähle ein Zufälligen Clienten aus
		randomElement = math.random(1,#connectedClient[randomClient].board.elements) -- wählt ein zufälliges Board von dem Clienten aus

		tempTask = Task:new(connectedClient[randomClient].board.elements[randomElement]) -- Erstellt neuen Task für gewähltes Element
		sendStuff(tempTask,"task",gameChannel,connectedClient[key].uuid)
    end
end
