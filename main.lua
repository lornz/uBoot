require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")

<<<<<<< HEAD
storyboard = require( "storyboard" )
=======
<<<<<<< HEAD
require("scripts.debugLorenz")

storyboard = require( "storyboard" )

=======
storyboard = require( "storyboard" )
>>>>>>> master
>>>>>>> origin/connection


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )


function initUBoot()
	-- initialisiert das uBoot bei allen Spielern
	for key, value in pairs(player) do 
		local newClient = Client:new()
		sendStuff(newClient,"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
    end
	
end
