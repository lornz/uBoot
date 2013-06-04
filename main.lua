require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")

storyboard = require( "storyboard" )


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )



