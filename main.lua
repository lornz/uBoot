require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")
require("scripts.debugLorenz")

storyboard = require( "storyboard" )


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )

connectedClient = {}
function initUBoot()
	-- initialisiert das uBoot bei allen Spielern
	for key, value in pairs(player) do 
		connectedClient[key] = Client:new()
		sendStuff(connectedClient[key],"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
    end
end
