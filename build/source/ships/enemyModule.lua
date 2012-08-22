local M = {}

local physics = require "physics"
local utilityModule = require "source.utility.utilityModule"
local physics = require "physics"
local gameDisplayModule = require "source.display.gameDisplayModule"
local shipModule = require "source.ships.shipModule"
local enemyTypes = require "source.ships.enemyTypesModule"
local collisionDetections = require "source.ships.collisionDetectionModule"
local shipCommonModule = require "source.ships.shipCommonModule"

local activeEnemies, ship

local setup = function()
	ship = shipModule.getShip()
	local gameDisplayGroup = gameDisplayModule.getGameDisplayGroup()
	activeEnemies = display.newGroup()
	gameDisplayGroup:insert( activeEnemies )
end
M.setup = setup

local getActiveEnemies = function()
	return activeEnemies
end
M.getActiveEnemies = getActiveEnemies

local buildEnemy = function(enemyType)
	local enemy = display.newImage( enemyTypes[enemyType]["image"] )
	
	-- copy enemy type into enemy
	for k,v in pairs(enemyTypes[enemyType]) do enemy[k]=v end
	
	enemy.HP=enemy.startingHP
	enemy["lastFired"] = math.random(0,2000)
	
	local gameDisplayGroup = gameDisplayModule.getGameDisplayGroup()
	local healthBar = display.newRect( 0 , 0, enemy["healthBarWidth"] , 4 )
	enemy.bar = healthBar
	gameDisplayGroup:insert( healthBar )
	healthBar.isVisible = false
	healthBar:setFillColor(155, 0, 0)
	
	function enemy:moveHealthBar()
		self.bar.x, self.bar.y = self.x,self.y-20		
		return true
	end
	
	function enemy:gotShot(bullet)
		self.bar.isVisible = true
		self.bar.width = ( self.HP / self.startingHP ) * enemy["healthBarWidth"]
		self.HP = self.HP - bullet.damage
		if self.HP <= 0 then
			self:doRemove()
		end		
	end
	
	function enemy:doRemove()
		if self.bar ~= nul then 
			self.bar:removeSelf() 
			self.bar = nil 
		end
		if self.hudDisplay ~= nul then 
			self.hudDisplay:removeSelf()
			self.hudDisplay = nil			
		end
		self:removeSelf()
		self = nil
	end
	
	local start = gameDisplayModule.getRandomStart()
	enemy.x, enemy.y = start.x,start.y
	physics.addBody( enemy, "dynamic", 
		{ density=.1, friction=8.5, bounce=0.1, shape=enemy.shape1, filter=collisionDetections["enemyCollisionFilter"] },
		{ density=.1, friction=8.5, bounce=0.1, shape=enemy.shape2, filter=collisionDetections["enemyCollisionFilter"] }
	)
	enemy.isBullet = true
	enemy.linearDamping = .6
	enemy.angularDamping = .7
	activeEnemies:insert( enemy )
	return enemy
end
M.buildEnemy = buildEnemy

local moveEnemy = function( event )
	for i=1, activeEnemies.numChildren do
		local enemy = activeEnemies[i]
		activeEnemies[i]:moveHealthBar()
		
		-- get angle between enemy and ship
		local angle = utilityModule.angleBetween(enemy, ship)
		if angle < 0 then angle = angle + 360 end
			
		-- get ship rotation
		local enemyRotation = enemy.rotation
		if math.abs(enemyRotation) > 360 then enemyRotation = enemyRotation % 360 end
		if enemyRotation < 0 then enemyRotation = 360 + enemyRotation end

		if math.abs(angle - enemyRotation) > 10 then
			-- get adjusted angle from ship rotation to touch
			local adjustedAngle = 360 - enemyRotation + angle
			if math.abs(adjustedAngle) > 360 then adjustedAngle = adjustedAngle % 360 end
				
			if adjustedAngle > 180 then
				enemy:rotate(-2)
			else
				enemy:rotate(2)
			end
			--print("enemyRotation: " .. enemyRotation .. "  angle: " .. angle .. "  adjustedAngle: " .. adjustedAngle)
		end
		
		if math.abs(angle - enemyRotation) < 10 then
			local radian = math.rad(enemy.rotation)
			local forceMultiplier=.2
			force_x = math.sin(radian) * forceMultiplier
			force_y = math.cos(radian) * -forceMultiplier
				
			enemy:applyForce( force_x, force_y, enemy.x, enemy.y )
		end
	end
end
M.moveEnemy = moveEnemy

local enemyFire = function( event )
	for i=1, activeEnemies.numChildren do
		shipCommonModule.shoot(activeEnemies[i])
	end
	return true
end
M.enemyFire = enemyFire

local destroy = function()
	activeEnemies:removeSelf(); activeEnemies = nil
end
M.destroy = destroy

return M