local M = {}local enemyModulelocal shipModule = require("source.ships.shipModule")local shipCommonModule = require "source.ships.shipCommonModule"local gameDisplayGrouplocal borderthreshold = 100local halfWidth,halfHeight,cameraEndRight,cameraEndLeft,cameraEndBottom,cameraEndTop,	borderthresholdTop,borderthresholdBottom,borderthresholdRight,borderthresholdLeftlocal skylocal starts = {        { x=-100, y=display.contentCenterY },        { x=display.contentWidth+100, y=display.contentCenterY },        { x=display.contentCenterX, y=-100 },        { x=display.contentCenterX, y=display.contentHeight+100 },}local setGameDisplayGroup = function(passedInGameDisplayGroup)	gameDisplayGroup = passedInGameDisplayGroup	gameDisplayGroup.x = 0; gameDisplayGroup.y = 0	sky = display.newImage( "graphics/sky2.jpg", 600, 600 )	sky:scale( 1.8, 1.8 )	gameDisplayGroup:insert( sky )	sky.x = 0; sky.y = 0	halfWidth = ( display.contentWidth ) * .5	halfHeight = ( display.contentHeight ) * .5	cameraEndRight = gameDisplayGroup.contentWidth * .5 - halfWidth + display.screenOriginX	cameraEndLeft = -cameraEndRight	cameraEndBottom = gameDisplayGroup.contentHeight * .5 - halfHeight + display.screenOriginY	cameraEndTop = -cameraEndBottom	borderthreshold = 100	borderthresholdTop = -gameDisplayGroup.contentHeight/2-borderthreshold	borderthresholdBottom = gameDisplayGroup.contentHeight/2+borderthreshold	borderthresholdRight = gameDisplayGroup.contentWidth/2+borderthreshold	borderthresholdLeft = -gameDisplayGroup.contentWidth/2-borderthresholdendM.setGameDisplayGroup = setGameDisplayGrouplocal getRandomStart = function()	local randomX = math.random( borderthresholdLeft, borderthresholdRight )	local randomY = math.random( borderthresholdTop, borderthresholdBottom )	local starts = {        { x=borderthresholdRight, y=randomY },        { x=borderthresholdLeft, y=randomY },        { x=randomX, y=borderthresholdTop },        { x=randomX, y=borderthresholdBottom },	}	return starts[ math.random( 1, 4 ) ]endM.getRandomStart = getRandomStartlocal moveCamera = function()	local ship = shipModule.getShip()	if ship.x < cameraEndRight and ship.x > cameraEndLeft then		gameDisplayGroup.x = -ship.x + halfWidth	end	if ship.y < cameraEndBottom and ship.y > cameraEndTop then		gameDisplayGroup.y = -ship.y + halfHeight	endendM.moveCamera = moveCameralocal checkBorders = function( event )	enemyModule = enemyModule or require("source.ships.enemyModule")	local bullets = shipCommonModule.getBullets()	for i=1, bullets.numChildren do		local bullet = bullets[i]		if bullet ~= nil then 			if (bullet.x < borderthresholdLeft) then bullet:doRemove();			elseif (bullet.x > borderthresholdRight) then bullet:doRemove();			elseif (bullet.y < borderthresholdTop) then bullet:doRemove();			elseif (bullet.y > borderthresholdBottom) then bullet:doRemove(); end		end	end	return trueendM.checkBorders = checkBorderslocal getGameDisplayGroup = function()	return gameDisplayGroupendM.getGameDisplayGroup = getGameDisplayGrouplocal destroy = function()	sky:removeSelf(); sky = nilendM.destroy = destroyreturn M