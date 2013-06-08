require ("pubnub")

connectionMode = 0 -- 0: nicht verbunden, 1: Server, 2: Client

multiplayer = pubnub.new({
    publish_key   = "pub-c-0a08fcd9-9f7f-4d08-8d4e-2268d802db02",
    subscribe_key = "sub-c-2ad01006-cc6b-11e2-ba80-02ee2ddab7fe",
    secret_key    = "sec-c-ZmE0YWFjYTUtMzg0My00NWNiLWIwYTUtNDllM2VjN2U3M2M5",
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})

function createUUID()
    uuid = multiplayer:UUID()
end

games   = {}                -- speichert alle verfügbaren Spiele
player  = {}                -- speichert alle anwesenden Spieler

local playerNumber = 1      -- bisher ungenutzt
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

function createGame()
    connectionMode  = 1 -- Server
    gameChannel     = deviceID
    subscribe(gameChannel)
    storyboard.gotoScene( "scripts.SceneWaiting", transitionOptions )
end

local function joinGame(event)
    if (event.phase == "ended") then
        --sendStuff(gameChannel,"reply",lobbyChannel)
        unsubscribe(lobbyChannel)

        connectionMode  = 2 -- Client
        gameChannel     = event.target.text 
        subscribe(gameChannel)
        sendStuff("ping","connect",gameChannel)  
        storyboard.gotoScene( "scripts.SceneWaiting", transitionOptions )
    end
end

local i = 1
local function updateLobby()
    -- zeigt alle verfügbaren Spiele in "games{}" an
    for key, value in pairs(games) do 
        print("Spiel "..i..": "..key)
        if (value.show == true) then
            local myText = display.newText( key, 50, i*50, nil, display.contentWidth/23 )
            menuGroup:insert(myText)
            myText:addEventListener("touch", joinGame)
            i = i + 1
        end
        value.show = false
    end
    -- Erweiterung: Spiele die nicht mehr da sind löschen
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
    storyboard.gotoScene( "scripts.SceneGame", transitionOptions )
    if (connectionMode == 1) then
        unsubscribe(lobbyChannel)
    end
    
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
            if (value.ready == false) then
                startGame = false
            end
        end

        if (startGame == true) then
            --chooseServer() -- bestimme wer Server ist
            if (connectionMode == 1) then
                -- Nur der Server prüft ob ALLE ready sind, und startet das Spiel dann
                print("Spiel kann starten!!!")
                initUBoot()
            end
        end

    end
    if not (player[senderUUID] == nil) then
        if (player[senderUUID].ready == false) then
            player[senderUUID].ready = content -- setze Spieler mit senderUUID auf ready/not-ready
            checkReadyStatus()
        end
    end
end

local function updateMessage(content, senderUUID)
    -- print("Button: "..content.skinID)
    -- print(content.type)
    print("button " .. content.skinID .. ": Type = " .. content.type .. ": Value = ".. content.value)
    -- diese empfangenen Werte an die "taskForce" übergeben
end

local function updateMessage(content, senderUUID)
    print("button " .. content.skinID .. ": Type = " .. content.type .. ": Value = ".. content.value)
end

local function taskMessage(content)
    print("New task: Please adjust element "..content.skinID.." to: "..content.value)
end

local function receiveMessage(channel,content,mode,senderUUID,destination)
    if (channel == gameChannel) then-- Nachrichten je nach"mode" weitergeben
        if not (gameChannel == nil) then
            if (mode == "connect") then
                connectMessage(content,senderUUID)
                print("senderUUID: "..senderUUID)
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

            if (mode == "update") then
                if (connectionMode == 1) then
                    -- updates nur für Server relevant
                    updateMessage(content,senderUUID)
                end
            end

            if (mode == "task") then
                if (destination == uuid) then
                    -- ist die Nachricht für mich?
                    taskMessage(content)
                end
            end
        end
    end
    if (channel == lobbyChannel) then
        if (mode == "discover") then
            if (connectionMode == 1) then
                -- Antworte auf "discover" Nachrichten mit dem eigenen Spiel-Namen
                sendStuff(gameChannel,"reply",lobbyChannel)
                -- Erweiterung: Anzahl der Spieler im Raum zurück senden
            end
        end
        if (mode == "reply") then
            -- wenn eine Nachricht auf die "discover" Anfrage zurück kommt, wird der Raumname gespeichert und die Lobby aktualisiert
            if (games[content] == nil) then
                games[content] = {content = content, show = true}
                updateLobby()
            end
        end
    end
end

function subscribe(channel)
    multiplayer:subscribe({
        channel = channel,
        connect = function()
            print("Connected to ".. channel)
        end,
        callback = function(message)
        	-- message received -> do something
            --print(message.mode.." Nachricht empfangen in: "..channel)
        	receiveMessage(message.channel,message.content,message.mode,message.uuid,message.destination)
        end,
        errorback = function()
            print("Network Connection Lost")
        end
    })
end

function unsubscribe(channel)
    multiplayer:unsubscribe({
        channel  = channel,
    })
    print("unsubscribed from: "..channel)
end

function sendStuff(content,mode,channel,destination)
	multiplayer:publish({
	    channel  = channel,
	    message  = { channel = channel, content = content, mode = mode, uuid = uuid, destination = destination},
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