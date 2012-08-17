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

-- Touch event listener 


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	physics.start()
	physics.setPositionIterations( 16 )
	physics.setGravity( 0, 0 )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local gameDisplayGroup = self.view

	-- remove previous scene's view
	storyboard.purgeScene( "source.scenes.levelSelectionScene" )
	
	local gameDisplayModule = require "source.display.gameDisplayModule"
	local shipModule = require "source.ships.shipModule"
	local isTouch = false
	local touchEvent

	gameDisplayModule.setGameDisplayGroup(gameDisplayGroup)
	
	local ship = shipModule.getShip()
	gameDisplayGroup:insert( ship )
	
	gameDisplayModule.moveCamera(event)
	
	local hudModule = require("source.display.hudModule")

	local enemyModule = require("source.ships.enemyModule")
	enemyModule.buildEnemy("enemyTypeFighter1")
	enemyModule.buildEnemy("enemyTypeFighter1")
	enemyModule.buildEnemy("enemyTypeFighter1")

	local function onMoveShip( event )
		if isTouch == true then	shipModule.moveShip(touchEvent)	end
		return true
	end

	local function onScreenTouch( event )
		if event.phase == "began" then
			touchEvent = event
			isTouch = true
		elseif event.phase == "moved" then
			touchEvent = event
		elseif event.phase == "ended" or event.phase == "cancelled" then
			isTouch = false
			shipModule.shipIsStopped()
		end
		return true
	end
	
	local function gameLoop(event)
		onMoveShip(event)
		gameDisplayModule.moveCamera(event)
		hudModule.updateHud(event)
		enemyModule.moveEnemy(event)
		shipModule.shootBullet()
		enemyModule.enemyFire()
	end
	
	Runtime:addEventListener( "enterFrame", gameLoop )
	Runtime:addEventListener( "touch", onScreenTouch )
	timer.performWithDelay( 1000, gameDisplayModule.checkBorders, 0 )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	-- remove listeners
	Runtime:removeEventListener( "enterFrame", gameLoop )
	Runtime:removeEventListener( "touch", onScreenTouch )
	
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