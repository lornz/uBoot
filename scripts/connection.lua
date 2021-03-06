require ("pubnub")
deviceID = (system.getInfo( "deviceID" ))


connectionMode = 0 -- 0: nicht verbunden, 1: Server, 2: Client

multiplayer = pubnub.new({
    publish_key   = "pub-c-0a08fcd9-9f7f-4d08-8d4e-2268d802db02",
    subscribe_key = "sub-c-2ad01006-cc6b-11e2-ba80-02ee2ddab7fe",
    secret_key    = "sec-c-ZmE0YWFjYTUtMzg0My00NWNiLWIwYTUtNDllM2VjN2U3M2M5",
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})

function createUUID()
    if "Win" == system.getInfo( "platformName" ) then
        uuid = math.random(1,1000) --
    elseif "Android" == system.getInfo( "platformName" ) then
        --uuid = multiplayer:UUID() -- alte Methode über pubNub
        uuid = deviceID -- neue Methode über Geräte ID
    end
    print("UUID: "..uuid)
end
createUUID()

games   = {}                -- speichert alle verfügbaren Spiele
player  = {}                -- speichert alle anwesenden Spieler

local playerNumber = 1
local function addPlayer(playerUUID)
	if (player[playerUUID] == nil) then
        local tempPlayer = {}
        tempPlayer.uuid = playerUUID
        tempPlayer.playerNumber = playerNumber
        tempPlayer.ready = false
        tempPlayer.deviceID = deviceID
		--player[playerUUID] = { uuid = playerUUID, playerNumber = playerNumber, ready = false, deviceID = deviceID}
        player[playerUUID] = tempPlayer
		playerNumber = playerNumber + 1
		print("player added")
        showPlayers(tempPlayer)
	else
		print("player already in list")
	end
end

function createGame()
    connectionMode  = 1 -- Server
    gameChannel     = deviceID
    subscribe(gameChannel)
    sendStuff("ping","connect",gameChannel)
    storyboard.gotoScene( "scripts.SceneWaiting", transitionOptions )
end

local function joinGame(event)
    if (event.phase == "ended") then
        timer.cancel(discoverTimer)
        unsubscribe(lobbyChannel)

        connectionMode  = 2 -- Client
        gameChannel     = event.target.text 
        subscribe(gameChannel)
        sendStuff("ping","connect",gameChannel)  
        storyboard.gotoScene( "scripts.SceneWaiting", transitionOptions )
    end
end


function updateLobby()
    local i = 1
    -- zeigt alle verfügbaren Spiele in "games{}" an
    for key, value in pairs(games) do 
        --print("Spiel "..i..": "..key)
        if (value.show == true) then
            -- local myText = display.newText( key, 50, i*50, nil, display.contentWidth/23 )
            games[key].text = display.newText( key, 50, i*50, nil, display.contentWidth/23 )
            menuGroup:insert(games[key].text)
            games[key].text:addEventListener("touch", joinGame)
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
            sendStuff(imReady,"ready",gameChannel)
            addPlayer(senderUUID)
    elseif(content == "pong") then
            addPlayer(senderUUID)
            sendStuff(imReady,"ready",gameChannel)
    end
end

local function initMessage(content,senderUUID)
    -- reagiert auf initialisierungs Nachrichten (Board erstellen)
    storyboard.gotoScene( "scripts.SceneGameIntro", transitionOptions )
    if (connectionMode == 1) then
        unsubscribe(lobbyChannel)
    end
    playerBoard = content 
end

local function readyMessage(content,senderUUID)
    -- reagiert auf "ready" Nachrichten
    local players = 0
    local function checkReadyStatus()
        -- prüft, ob alle Spieler (auch man selbst) "Ready" sind
        local startGame = true
        for key, value in pairs(player) do 
            if (value.ready == false) then
                startGame = false
            else 
                players = players + 1    
            end     
        end

        if (startGame == true) then
            if (connectionMode == 1) and (players > 1) then
                -- Nur der Server prüft ob ALLE ready sind, und startet das Spiel dann
                print("Spiel kann starten!!!")
                initUBoot()
                print("Anzahl verbundene Spieler: "..players)
            end
        end

    end

    if not (player[senderUUID] == nil) then
        if (player[senderUUID].ready == false) then
            player[senderUUID].ready = content -- setze Spieler mit senderUUID auf ready/not-ready
            checkReadyStatus()
            showPlayers(player[senderUUID])
        elseif (player[senderUUID].ready == true) then
            player[senderUUID].ready = content -- setze Spieler mit senderUUID auf ready/not-ready
            checkReadyStatus()
            showPlayers(player[senderUUID])
        end
    end
end

local function updateMessage(content, senderUUID)
    -- diese empfangenen Werte an die "taskForce" übergeben
    if not(content.value == 9999) then
        Element[content.skinID].value = content.value -- Wert updaten (für Task erstellung)
    end
    taskDone(content,senderUUID)
end

local function levelMessage(content)
    if (content == "next") then
        if not (taskTimer == nil) then
            timer.cancel(taskTimer)
        end

        playerBoard = nil

        currentLevel = currentLevel + 1
        
        if (connectionMode == 1) then
            for key, value in pairs(connectedClient) do 
                connectedClient[key] = nil
                print("cleaned Client board")
            end
            initUBoot()
        end

        

        storyboard.gotoScene( "scripts.SceneGameIntro", transitionOptions )
    elseif (content == "lost") then
        -- GAME OVER!
        print("GAME OVER!")
        storyboard.gotoScene( "scripts.SceneGameOver", transitionOptions )
    end
end

local function waterMessage(content)
    showWaterLevel(content)
end

local suddenTaskfailed = false
local function suddenTaskMessage(content)
    if (content     == "failed") then
        -- suddenTask nicht rechtzeitig erledigt 
        if (connectionMode == 1) then -- nur der Server bestraft
            --> Bestrafung
            if (suddenTaskfailed == false) then -- nur eine Bestrafung pro Fail
                suddenTaskfailed = true
                print("SuddenTask failed")
                updateWaterLevel("up")
            end
        end
    elseif (content == "shake") then
        -- shake Event
        suddenTaskfailed = false
        createShakeEvent()
    elseif (conten  == "flip") then
        suddenTaskfailed = false
        -- flip Event
    end
end

local function taskMessage(content)
    if not (taskTimer == nil) then
        timer.cancel(taskTimer)
    end

    local name = labelBank[content.skinID]
    local taskString = "Adjust "..name.." to "..content.value
    commandBase.command.text = taskString

    taskTime = content.time
    taskTimer = timer.performWithDelay(1000,decreaseTime,taskTime)
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

            if (mode == "level") then
                levelMessage(content)
            end

            if (mode == "water") then
                waterMessage(content)
            end

            if (mode == "water") then
                waterMessage(content)
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

            if (mode == "suddenTask") then
                suddenTaskMessage(content)
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

            if (games[content].timer ~= nil) then
                timer.cancel(games[content].timer)
                print("still alive")
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