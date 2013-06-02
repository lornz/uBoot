Element = {}


local function chooseSkin(sizeX)
	local skinID = math.random(sizeX*100, (sizeX*100)+99) -- 1 breite Skins bei 100 bis 199

	return skinID
end

function Element:new(sizeX,position)
	local element = {}

	element.sizeX = sizeX

	element.position = position

	element.state = true

	element.value = 0 -- zu Beginn jeder Regler auf Null, jeder Schalter aus

	element.skinID = chooseSkin(sizeX)

	return element
end