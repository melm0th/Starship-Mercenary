---------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local physics = require "physics"

-- listeners

-- Called when the scene's view does not exist:
function scene:createScene( event )
	physics.start()
	physics.setPositionIterations( 16 )
	physics.setGravity( 0, 0 )
	
	local gameModule = require "source.gameModule"
	gameModule.setup(self.view)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )	
	-- remove previous scene's view
	storyboard.purgeScene( "source.scenes.levelSelectionScene" )
	
	local gameModule = require "source.gameModule"
	gameModule.startGame()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local gameModule = require "source.gameModule"
	gameModule.endGame()
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