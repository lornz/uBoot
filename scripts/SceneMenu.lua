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
        menuGroup = self.view

        -----------------------------------------------------------------------------

        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.

        -----------------------------------------------------------------------------

        --Provisorium!!!
        local textStart = display.newText("Create uBoot!", 0, 0, native.systemFont, 72)
        textStart:setReferencePoint(display.centerReferencePoint)
        textStart.x =  display.viewableContentWidth/2
        textStart.y =  display.viewableContentHeight-100
        menuGroup:insert(textStart)
        local function textStartTap(event)
                createGame()
        end
        textStart:addEventListener("tap", textStartTap)

        local textStart2 = display.newText("or jump in another uBoot", 0, 0, native.systemFont, 30)
        textStart2:setReferencePoint(display.centerReferencePoint)
        textStart2.x =  display.viewableContentWidth/2
        textStart2.y =  display.viewableContentHeight-40
        menuGroup:insert(textStart2)
        
        local textStart3 = display.newText("Avaible uBoots:", 0, 0, native.systemFont, 30)
        textStart3:setReferencePoint(display.centerReferencePoint)
        textStart3.x =  150
        textStart3.y =  30
        menuGroup:insert(textStart3)

        subscribe(lobbyChannel)

        local function alive(game)
                --print("noch da? ")
                --print(games[game])
                timer.cancel(games[game].timer)
                games[game].text:removeSelf()
                games[game] = nil
                updateLobby()
        end

        local function discover()
                sendStuff("hi","discover",lobbyChannel)
                for key, value in pairs(games) do
                        --print(games[key])
                        games[key].timer = timer.performWithDelay( 2000, function() 
                                                                                alive(key)
                                                                        end
                                , 1)
                end
        end
        discoverTimer = timer.performWithDelay( 2000, discover, 0)
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
        timer.cancel( discoverTimer ) 
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