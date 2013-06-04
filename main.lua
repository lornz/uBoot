require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")
<<<<<<< HEAD
require("scripts.debugLorenz")
=======
storyboard = require( "storyboard" )
>>>>>>> 0429df22129e5ca9fa1de17210095e943a21a429


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )



