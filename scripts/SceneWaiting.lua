local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------


-- local forward references should go here --


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.

        -----------------------------------------------------------------------------

        --## READY BUTTON ## (Provisorium)
        local textStart = display.newText("Ready?", 0, 0, native.systemFont, 72)
        textStart:setReferencePoint(display.centerReferencePoint)
        textStart.x =  display.viewableContentWidth/2
        textStart.y =  display.viewableContentHeight/2
        group:insert(textStart)

        imReady = false
        local function textStartTap(event)
                if(event.phase == "ended") then
                        if (imReady == false) then
                                imReady = true
                                textStart.text = "I'm ready"
                                sendStuff(imReady,"ready",gameChannel)
                        elseif (imReady == true) then
                                imReady = false
                                textStart.text = "Ready?"
                                sendStuff(imReady,"ready",gameChannel)
                        end
                end
        end
        textStart:addEventListener("touch", textStartTap)

        --## ROOM NAME ##
        local roomName = display.newText("uBoot: "..gameChannel, 0, 0, native.systemFont, 30)
        roomName:setReferencePoint(display.centerReferencePoint)
        roomName.x =  display.viewableContentWidth/2
        roomName.y =  50
        group:insert(roomName)

        -- ## PLAYER NAMES ##
        playerName = {}
        function showPlayers(localPlayer)
                if (playerName[localPlayer.uuid] == nil) then
                        -- wenn Spieler noch nicht in Liste, füge ihn hinzu
                        print(localPlayer.deviceID)
                        playerName[localPlayer.uuid] = display.newText(localPlayer.deviceID, 0, 0, native.systemFont, 30)
                        playerName[localPlayer.uuid]:setReferencePoint(display.centerReferencePoint)
                        playerName[localPlayer.uuid].x =  display.viewableContentWidth/2
                        playerName[localPlayer.uuid].y =  250+(50*localPlayer.playerNumber)
                        group:insert(playerName[localPlayer.uuid])
                        if (localPlayer.ready == false) then
                                playerName[localPlayer.uuid]:setTextColor(250,50,0)
                        elseif (localPlayer.ready == true) then
                                 playerName[localPlayer.uuid]:setTextColor(50,250,0)
                        end 
                end
                if (playerName[localPlayer.uuid] ~= nil) then
                         if (localPlayer.ready == false) then
                                playerName[localPlayer.uuid]:setTextColor(250,50,0)
                        elseif (localPlayer.ready == true) then
                                 playerName[localPlayer.uuid]:setTextColor(50,250,0)
                        end 
                end
        end

        -- ## GAME FUNCTIONS ##
        connectedClient = {}
        function initUBoot()    -- initialisiert das uBoot bei allen Spielern
                local i = 1
                for key, value in pairs(player) do 
                        connectedClient[i] =  Client:new(value.uuid)
                        sendStuff(connectedClient[i],"init",gameChannel,value.uuid) -- schickt "Board" an alle Spieler
                        i = i + 1
                end
                sendStuff(Level[currentLevel].waterStart,"water",gameChannel)
                waterLevel = Level[currentLevel].waterStart
        end
end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

        -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene