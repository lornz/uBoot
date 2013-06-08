connectedClient = {}

function initUBoot()	-- initialisiert das uBoot bei allen Spielern
	local i = 1
	for key, value in pairs(player) do 
		connectedClient[i] =  Client:new(value.uuid)
		sendStuff(connectedClient[i],"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
		i = i + 1
    end
end


