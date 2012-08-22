local game = {}

local isTouch = false
local touchEvent, checkBordersTimer, checkLevelTimer

local function onMoveShip( event )
	local shipModule = require "source.ships.shipModule"
	if isTouch == true then	shipModule.moveShip(touchEvent)	end
	return true
end

local function onScreenTouch( event )
	local shipModule = require "source.ships.shipModule"
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

local function checkLevel(event)
	local levels = require "source.levels.levelModule"
	if levels.levelComplete then
		local storyboard = require( "storyboard" )
		storyboard.gotoScene( "source.scenes.levelSelectionScene", "fade", 400  )
	end
end

local function gameLoop(event)
	local shipModule = require "source.ships.shipModule"
	local gameDisplayModule = require "source.display.gameDisplayModule"
	local levels = require "source.levels.levelModule"
	local hudModule = require "source.display.hudModule"
	local enemyModule = require "source.ships.enemyModule"
	onMoveShip(event)
	gameDisplayModule.moveCamera(event)
	levels.runLevel()
	hudModule.updateHud(event)
	enemyModule.moveEnemy(event)
	shipModule.shootBullet()
	enemyModule.enemyFire()		
end

local function startGame()
	local gameDisplayModule = require "source.display.gameDisplayModule"
	
	local shipModule = require "source.ships.shipModule"
	local ship = shipModule.getShip()
	gameDisplayModule.getGameDisplayGroup():insert( ship )
	
	Runtime:addEventListener( "enterFrame", gameLoop )
	Runtime:addEventListener( "touch", onScreenTouch )
	checkBordersTimer = timer.performWithDelay( 1000, gameDisplayModule.checkBorders, 0 )
	checkLevelTimer = timer.performWithDelay( 1000, checkLevel, 0 )	
end
game.startGame = startGame

local setup = function( view )
	local gameDisplayModule = require "source.display.gameDisplayModule"
	gameDisplayModule.setGameDisplayGroup( view )
	local shipModule = require "source.ships.shipModule"	
	local hudModule = require "source.display.hudModule"
	local enemyModule = require "source.ships.enemyModule"
	local shipCommonModule = require "source.ships.shipCommonModule"
	local levels = require "source.levels.levelModule"
	levels.setup()
	shipModule.setup()
	enemyModule.setup()
	hudModule.setup()
	shipCommonModule.setup()
end
game.setup = setup

local function endGame()
	Runtime:removeEventListener( "enterFrame", gameLoop )
	Runtime:removeEventListener( "touch", onScreenTouch )
	timer.cancel( checkBordersTimer )
	timer.cancel( checkLevelTimer )
	local shipModule = require "source.ships.shipModule"
	local gameDisplayModule = require "source.display.gameDisplayModule"
	local hudModule = require "source.display.hudModule"
	local enemyModule = require "source.ships.enemyModule"
	local shipCommonModule = require "source.ships.shipCommonModule"
	hudModule.destroy()
	gameDisplayModule.destroy()
	shipModule.destroy()
	enemyModule.destroy()
	shipCommonModule.destroy()
end
game.endGame = endGame


return game