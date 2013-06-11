createUUID()
lobbyChannel = "lobby_lorenz"
deviceID = (system.getInfo( "deviceID" ))
--print(deviceID)

function printTasksDebug()
	for key, value1 in pairs(Task) do 
		print("Task __ must be __")
		print(key)
		print(key.value)
	end
end
