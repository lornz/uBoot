require("scripts.Client")
require("scripts.Board")
require("scripts.Element")
require("scripts.connection")
--require("scripts.game")
require("scripts.Task")
require("scripts.debugLorenz")
require("scripts.Command")
require("scripts.FileAccess")

storyboard = require( "storyboard" )


transitionOptions =
{
    effect = "fade",
    time = 1000,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scripts.SceneMenu", transitionOptions )


-- tests the functions above
local file = 'buttonLabels.txt'
local lines = lines_from(file)

-- print all line numbers and their contents
for k,v in pairs(lines) do
  print('line[' .. k .. ']', v)
end

print("printed all buttonLabels")