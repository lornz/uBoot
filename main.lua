require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")
require("scripts.debugLorenz")




local client1 = Client:new()

i = 1
while(not(client1.board.elements[i] == nil)) do 
	print ("position = " .. client1.board.elements[i].position .. " , size = " ..client1.board.elements[i].sizeX .. " , skinID = " .. client1.board.elements[i].skinID)
	displayImage(client1.board.elements[i])
	i = i + 1
end

gameChannel = "test"
subscribe(gameChannel)


