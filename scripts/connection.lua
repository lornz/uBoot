require ("pubnub")

connectionMode = 0 -- 0: nicht verbunden, 1: Server, 2: Client

multiplayer = pubnub.new({
    publish_key   = "pub-c-0a08fcd9-9f7f-4d08-8d4e-2268d802db02",
    subscribe_key = "sub-c-2ad01006-cc6b-11e2-ba80-02ee2ddab7fe",
    secret_key    = "sec-c-ZmE0YWFjYTUtMzg0My00NWNiLWIwYTUtNDllM2VjN2U3M2M5",
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})



player = {} -- speicher alle anwesenden Spieler
local playerNumber = 1 -- bisher ungenutzt
local function addPlayer(playerUUID)
	if (player[playerUUID] == nil) then
		player[playerUUID] = { uuid = playerUUID, playerNumber = playerNumber, ready = false}
		playerNumber = playerNumber + 1
		print("player added")
	else
		print("player already in list")
	end
end

local function chooseServer()
    -- ermittelt wer Server ist und wer Client ist
	local temp = uuid

    -- kleinste uuid in der Liste aller "player" finden
	for key, value in pairs(player) do 
		if (key < temp) then
			temp = key
		end
	end
	print("server uuid: "..temp)
    print("eigene uuid: "..uuid)
	if (temp == uuid) then
		print("Hurra, ich bin der Server!")
        connectionMode = 1 --server
	else
		print("Hurra, ich bin nur Client!")
        connectionMode = 2 --client
	end
end

local function connectMessage(content,senderUUID)
    -- reagiert auf ping/pong Nachrichten
    if(content == "ping") then
            sendStuff("pong","connect",gameChannel)
            addPlayer(senderUUID)
    elseif(content == "pong") then
            addPlayer(senderUUID)
    end
end

local function initMessage(content,senderUUID)
    -- reagiert auf initialisierungs Nachrichten (Board erstellen)
    local i = 1
    while(not(content.board.elements[i] == nil)) do 
        print ("position = " .. content.board.elements[i].position .. " , size = " ..content.board.elements[i].sizeX .. " , skinID = " .. content.board.elements[i].skinID)
        displayImage(content.board.elements[i])
        i = i + 1
    end
end

local function readyMessage(content,senderUUID)
    -- reagiert auf "ready" Nachrichten
    local function checkReadyStatus()
        local startGame = true
        -- prüft, ob alle Spieler (auch man selbst) "Ready" sind
        for key, value in pairs(player) do 
            --print(key)
            --print (value.ready)
            if (value.ready == false) then
                startGame = false
            end
        end

        if (startGame == true) then
            chooseServer() -- bestimme wer Server ist
            if (connectionMode == 1) then
                -- Nur der Server prüft ob ALLE ready sind, und startet das Spiel dann
                print("Spiel kann starten!!!")
                initUBoot()
            end
        end

    end

    player[senderUUID].ready = content -- setze Spieler mit senderUUID auf ready/not-ready
    checkReadyStatus()
end

local function receiveMessage(content,mode,senderUUID,destination)
    -- Nachrichten je nach"mode" weitergeben
    if (mode == "connect") then
        connectMessage(content,senderUUID)
    end

    if (mode == "init") then
        if (destination == uuid) then
            -- ist die Nachricht für mich?
            initMessage(content,senderUUID)
        end
    end

    if (mode == "ready") then
        readyMessage(content,senderUUID)
    end
end

function subscribe(channel)
    multiplayer:subscribe({
        channel = channel,
        connect = function()
            print("Connected to ".. channel)
            uuid = multiplayer:UUID()

            sendStuff("ping","connect",gameChannel)
        end,
        callback = function(message)
        	-- message received -> do something
            print(message.mode.." Nachricht empfangen")
        	receiveMessage(message.content,message.mode,message.uuid,message.destination)
        end,
        errorback = function()
            print("Network Connection Lost")
        end
    })
end

function sendStuff(content,mode,channel,destination)
	multiplayer:publish({
	    channel  = channel,
	    message  = { content = content, mode = mode, uuid = uuid, destination = destination},
	    callback = function(info)
	        -- WAS MESSAGE DELIVERED?
	        if info[1] then
	            --print("MESSAGE DELIVERED SUCCESSFULLY!")
	        else
	            print("MESSAGE FAILED BECAUSE -> " .. info[2])
	        end
	    end
	})
end