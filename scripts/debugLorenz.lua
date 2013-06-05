--gameChannel = "test"
--subscribe(gameChannel)
--timer.performWithDelay( 5000, chooseServer, 0)

local testBoard = { elements = { 	sizeX = 20,	
									position = 2,
									state = true,
									value = 0, -- zu Beginn jeder Regler auf Null, jeder Schalter aus
									skinID = 5,} 
								}


createUUID()
lobbyChannel = "lobby_lorenz"

deviceID = (system.getInfo( "deviceID" ))
print(deviceID)