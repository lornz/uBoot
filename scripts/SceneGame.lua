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

        
        
        -- ## TASK  FUNCTIONS ##   
        taskCountdown = display.newText("15", 0, 0, native.systemFont, 32)
        taskCountdown:setReferencePoint(display.CenterReferencePoint)
        taskCountdown.x = _W
        taskCountdown.y = _H+_H-50
        taskCountdown:setTextColor(0,255,0)
        group:insert(taskCountdown)

        timerVisual(group)

        local function drawElements(content)
                local i = 1
                while(not(content.board.elements[i] == nil)) do 
                --print ("position = " .. content.board.elements[i].position .. " , size = " ..content.board.elements[i].sizeX .. " , skinID = " .. content.board.elements[i].skinID)
                displayImage(content.board.elements[i],group)
                i = i + 1
                end
        end
        drawElements(playerBoard)

        -- ## WATER LEVEL ##
        local waterBarBG = display.newRect(20, 200, 64, (_H*2)-50 )
        waterBarBG:setReferencePoint(display.BottomCenterReferencePoint)
        waterBarBG.x = 64
        waterBarBG.y = (_H*2)-20
        waterBarBG:setFillColor(100, 100, 100, 100)
        group:insert(waterBarBG)

        waterBar = display.newRect(20, 200, 64, (_H*2)-50 )
        waterBar:setReferencePoint(display.BottomCenterReferencePoint)
        waterBar.x = 64
        waterBar.y = (_H*2)-20
        waterBar.yScale = 0.001 -- 0 setzen leider nicht erlaubt
        waterBar:setFillColor(0, 100, 255, 100)
        group:insert(waterBar)
        local sheetData = { width=64, height=32, numFrames=16, sheetContentWidth=1024, sheetContentHeight=32 }
        local mySheet = graphics.newImageSheet( "media/gfx/wellenSprite.png", sheetData )
        local sequenceData = {
        { name = "normal", start=1, count=16, time=3200 },
        }
        waterAnimation = display.newSprite( mySheet, sequenceData )
        group:insert(waterAnimation)
        waterAnimation.x = waterBar.x
        waterAnimation.y = waterBar.y
        waterAnimation:play()
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
        storyboard.removeScene( "scripts.SceneGameIntro" )

        -- ## KOMMANDO ZEILE ##
        local commandBase = setupCommandBase(group)
        commandBase.command.text = "Stay cool!"

        if(connectionMode == 1) then
                initTasks()
        end

        showWaterLevel(waterLevel)

        local function suddenTaskValue()
                local suddenValue = suddenTask()
                if not(suddenValue == nil) then
                        print(suddenValue)
                end
        end
        if (connectionMode == 1) then
                suddenTaskTimer = timer.performWithDelay( Level[currentLevel].suddenTime, suddenTaskValue, 0 )
        end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------
        if (connectionMode == 1) then
                timer.cancel( suddenTaskTimer )
        end

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