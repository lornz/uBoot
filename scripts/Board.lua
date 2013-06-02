Board = {}

local function calculateBoard()
	local elements = {}
	-- maximal 4 elemente in einer Zeile
	-- Erste Element zwischen 1 bis 4 = x (random) 
	-- -> nächste Element zwischen 1 bis (4-x) usw
	
	--debug
	i= 1
	position = 1
	while (position < 9 ) do
		if(position < 5) then
			sizeX = math.random(1,5-position)
		else 
			sizeX = math.random(1,9-position)
		end
		elements[i] = Element:new(sizeX,position)
		position = position + sizeX
		i = i + 1
	end


	

	return elements
end

function Board:new()
	local board = {}
	board.elements = calculateBoard()

	return board
end

