require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")
--require("scripts.game")
require("scripts.Task")
require("scripts.Level")
require("scripts.Command")
require("scripts.FileAccess")
require("scripts.debugLorenz")

storyboard = require( "storyboard" )


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )