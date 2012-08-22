---------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local text1, text2

-- Touch event listener 
local function onSceneTouch( event )
	if event.phase == "began" then
		
		storyboard.gotoScene( "source.scenes.levelSelectionScene", "fade", 400  )
		
		return true
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	text1 = display.newText( "Spash for Starship Mercenary", 0, 0, native.systemFontBold, 24 )
	text1:setTextColor( 255 )
	text1:setReferencePoint( display.CenterReferencePoint )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	screenGroup:insert( text1 )
	
	text2 = display.newText( "touch screen to start", 0, 0, native.systemFontBold, 16 )
	text2.isVisible = false
	text2:setTextColor( 255 )
	text2:setReferencePoint( display.CenterReferencePoint )
	text2.x, text2.y = display.contentWidth * 0.5, 100
	screenGroup:insert( text2 )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	local startTouchListener = function()
		Runtime:addEventListener( "touch", onSceneTouch )
		text2.isVisible = true
	end
	
	timer.performWithDelay( 3000, startTouchListener, 1 )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	-- remove touch listener for image
	Runtime:removeEventListener( "touch", onSceneTouch )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene