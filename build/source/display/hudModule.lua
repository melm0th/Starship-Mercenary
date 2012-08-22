local M = {}


local gameDisplayModule = require "source.display.gameDisplayModule"
local shipModule = require "source.ships.shipModule"
local enemyModule = require "source.ships.enemyModule"

local gameDisplayGroup, ship, activeEnemies, hudWidth, hudHeight, hudDisplayX, hudDisplayY,
	hudDisplay, gameBeginningContentWidth, gameBeginningContentHeight, integrityLabel, backHealthBar,
	healthBar, hudScreenDisplay, hudShipDisplay

local setup = function()
	gameDisplayGroup = gameDisplayModule.getGameDisplayGroup()
	ship = shipModule.getShip()	
	activeEnemies = enemyModule.getActiveEnemies()
	
	hudWidth = (display.contentWidth - display.screenOriginX*2) / 3
	hudHeight = hudWidth
	hudDisplayX = display.contentWidth - display.screenOriginX - hudWidth
	hudDisplayY = display.contentHeight - display.screenOriginY - hudHeight
	hudDisplay = display.newRoundedRect( hudDisplayX, hudDisplayY, hudWidth, hudHeight,2 )
	hudDisplay:setFillColor(190, 190, 190)
	hudDisplay.alpha = 0.4
	hudDisplay.strokeWidth = 2
	hudDisplay:setStrokeColor(210, 210, 100)
	
	gameBeginningContentWidth = gameDisplayGroup.contentWidth
	gameBeginningContentHeight = gameDisplayGroup.contentHeight
	local hudScreenWidth = (display.contentWidth - display.screenOriginX*2) * hudWidth / gameBeginningContentWidth
	local hudScreenHeight = (display.contentHeight - display.screenOriginY*2) * hudHeight / gameBeginningContentHeight
	
	integrityLabel = display.newText("integrity: " .. ship.HP, display.screenOriginX, display.contentHeight - display.screenOriginY - 24, native.systemFont, 20)
	integrityLabel.alpha = 0.4

	backHealthBar = display.newRoundedRect(display.screenOriginX + integrityLabel.width, display.contentHeight - display.screenOriginY - 17, 50, 15, 4)
	backHealthBar.alpha = 0.4
	backHealthBar.strokeWidth = 3
	backHealthBar:setFillColor(0, 0, 0)
	backHealthBar:setStrokeColor(0, 0, 180)
	
	healthBar = display.newRoundedRect(display.screenOriginX + integrityLabel.width, display.contentHeight - display.screenOriginY - 17, 50, 15, 4)
	healthBar.alpha = 0.4
	healthBar:setReferencePoint(display.TopLeftReferencePoint)
	healthBar:setFillColor(200, 0, 0)

	hudScreenDisplay = display.newRoundedRect( 0, 0, hudScreenWidth, hudScreenHeight, 2)
	hudScreenDisplay:setFillColor(240, 240, 240)
	hudScreenDisplay.alpha = 0.5
	hudScreenDisplay:setReferencePoint(display.TopLeftReferencePoint)

	hudShipDisplay = display.newCircle( 0, 0, 3 )
end
M.setup = setup

local updateHud = function( event )

	healthBar.xScale = ship.HP / ship.startingHP
	integrityLabel.text = "integrity: "
	
	-- build HUD screen inlay
	-- game.x/game.contextwidth = x / hudWidth
	local xOffset = (gameBeginningContentWidth/2 - gameDisplayGroup.x + display.screenOriginX) * hudWidth / gameBeginningContentWidth
	local yOffset = (gameBeginningContentHeight/2 - gameDisplayGroup.y + display.screenOriginY ) * hudHeight / gameBeginningContentHeight
	hudScreenDisplay.x, hudScreenDisplay.y = hudDisplayX + xOffset, hudDisplayY + yOffset
	--print("game.x - gameBeginningContentWidth/2: " .. game.x - gameBeginningContentWidth/2 .. "display.contentWidth - display.screenOriginX*2: " .. display.contentWidth - display.screenOriginX*2 )
	--print("game.x: " .. game.x .. "  gameBeginningContentWidth: " .. gameBeginningContentWidth.. "  xOffset: " .. xOffset .. "   hudWidth: " .. hudWidth  )
	--print("  xOffset: " .. xOffset .. "   yOffset: " .. yOffset  )
	
	-- build ship
	-- ship.x/(gameBeginningContentWidth/2) == x/100
	xOffset = ( ( ship.x + gameBeginningContentWidth/2 ) * hudWidth / ( gameBeginningContentWidth ) )
	yOffset = ( ( ship.y + gameBeginningContentHeight/2 ) * hudHeight / ( gameBeginningContentHeight ) )
	hudShipDisplay.x, hudShipDisplay.y = hudDisplayX + xOffset, hudDisplayY + yOffset
	--print("ship.x: " .. ship.x .. "  ship.y: " .. ship.y.. "  xOffset: " .. xOffset .. "   yOffset: " .. yOffset  )

	for i=1, activeEnemies.numChildren do	
		local activeEnemy = activeEnemies[i]
		
		if math.abs(activeEnemy.x) < gameBeginningContentWidth/2 - display.screenOriginX and
			math.abs(activeEnemy.y) < gameBeginningContentHeight/2 - display.screenOriginY then
			
			if activeEnemy.hudDisplay == nil then
				activeEnemy.hudDisplay = display.newCircle( 0, 0, 2 )
				activeEnemy.hudDisplay:setFillColor(255,0,0)
			end
			
			xOffset = ( ( activeEnemy.x + gameBeginningContentWidth/2 ) * hudWidth / ( gameBeginningContentWidth ) )
			yOffset = ( ( activeEnemy.y + gameBeginningContentHeight/2 ) * hudHeight / ( gameBeginningContentHeight ) )

			activeEnemy.hudDisplay.x, activeEnemy.hudDisplay.y = hudDisplayX + xOffset, hudDisplayY + yOffset
		end
	end
	
	return true
end
M.updateHud = updateHud

local destroy = function()
	hudDisplay:removeSelf(); hudDisplay = nil
	integrityLabel:removeSelf(); integrityLabel = nil
	backHealthBar:removeSelf(); backHealthBar = nil
	healthBar:removeSelf(); healthBar = nil
	hudScreenDisplay:removeSelf(); hudScreenDisplay = nil
	hudShipDisplay:removeSelf(); hudShipDisplay = nil	
end
M.destroy = destroy

return M