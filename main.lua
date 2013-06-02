require("scripts.Client")
require("scripts.Board")
require("scripts.Element")

local client1 = Client:new()

i = 1
while(not(client1.board.elements[i] == nil)) do 
	print ("position = " .. client1.board.elements[i].position .. " , size = " ..client1.board.elements[i].sizeX .. " , skinID = " .. client1.board.elements[i].skinID)
	i = i + 1
end