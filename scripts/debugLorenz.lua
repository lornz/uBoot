gameChannel = "test"
subscribe(gameChannel)
timer.performWithDelay( 5000, chooseServer, 0)

local testBoard = { elements = { 	sizeX = 20,	
									position = 2,
									state = true,
									value = 0, -- zu Beginn jeder Regler auf Null, jeder Schalter aus
									skinID = 5,} 
								}

local function sendBoard()
	print("connectionMode: "..connectionMode)
	if not (connectionMode == 0) then
		sendStuff(client1,"init",gameChannel,uuid)
	end
end
--timer.performWithDelay( 10000, sendBoard, 1)


local function sendReady()
	--print("connectionMode: "..connectionMode)
	--if not (connectionMode == 0) then
		sendStuff(true,"ready",gameChannel)
	--end
end

timer.performWithDelay( 10000, sendReady, 1)

gameChannel = "test"
subscribe(gameChannel)
timer.performWithDelay( 5000, chooseServer, 0)

--timer.performWithDelay( 10000, sendReady, 1)

lobbyChannel = "lobby"

