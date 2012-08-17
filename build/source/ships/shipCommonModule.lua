local M = {}

local weaponTypes = require "source.ships.weaponTypesModule"
local collisionDetections = require "source.ships.collisionDetectionModule"

local bullets = display.newGroup()
local getBullets = function()
	return bullets
end
M.getBullets = getBullets

local isShot = function( event )
	if event.phase == "began" then
	 
		if (event.other.class == "enemy") then
			event.other:gotShot(event.target)
		elseif  (event.other.class == "ship") then
			event.other:gotShot(event.target)
		end
		-- remove the bullet
		event.target:doRemove()
	end
	
	return true
end
M.isShot = isShot

local shoot = function( ship )
	local weapon = weaponTypes[ship["weapon"]][ship["weaponLevel"]]
	local systemTime = system.getTimer()
	
	if systemTime < ship["lastFired"] + weapon["refireTime"] then
		return true
	end
	
	ship["lastFired"] = systemTime
	
	--for k,v in pairs(weapon) do print(k,v) end
	local bullet = display.newCircle( bullets, 0, 0, weapon["radius"] )
	bullet:setFillColor(weapon["color"][1], weapon["color"][2], weapon["color"][3])
	
	-- copy bullet type into bullet
	for k,v in pairs(weapon) do bullet[k]=v end
	
	local collisionDetectionFilter
	if (ship.class == "ship") then
		collisionDetectionFilter = collisionDetections["bulletCollisionFilter"]
	else
		collisionDetectionFilter = collisionDetections["enemyBulletCollisionFilter"]
	end
	
	physics.addBody( bullet, "dynamic", { friction=0, bounce=0, density=1, radius=weapon["radius"], filter=collisionDetectionFilter } )
	bullet.isBullet = true
	bullet.isSensor = true
	
	local radian = math.rad(ship.rotation)
	local force_x = math.sin(radian)
	local force_y = math.cos(radian)
	
	bullet.x=ship.x + force_x * ship.height/2
	bullet.y=ship.y - force_y * ship.height/2
		
	bullet:applyForce( force_x*weapon["force"], force_y*-weapon["force"], bullet.x, bullet.y )
	
	bullet:addEventListener( "collision", isShot )
	
	--audio.play( shootSound )
	
	function bullet:doRemove()
		self:removeEventListener( "collision", isShot )
		display.remove(self)
	end
	
	return true
end
M.shoot = shoot

return M