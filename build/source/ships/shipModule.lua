local M = {}

local physics = require "physics"
local collisionDetections = require "source.ships.collisionDetectionModule"
local utilityModule = require "source.utility.utilityModule"
local shipCommonModule = require "source.ships.shipCommonModule"

local ship = display.newGroup()

local shipImageSheet = graphics.newImageSheet( "graphics/ship1_ss.png",  {width = 50, height = 60, numFrames = 5} )
--local sequenceData = { { name="rightTurn",frames={1,2,3,4,5} }, { name="leftTurn", loopDirection = "bounce",frames={1,2,3,4,5}}}

local shipImage = display.newSprite( shipImageSheet, {{start=1,count=5}} )
shipImage:setFrame(3)

local exhaustIamge = display.newImage( "graphics/Exhaust.png" )
--local ship = display.newCircle( 0,0, 3 )
ship:insert( shipImage )
ship:insert( exhaustIamge )
exhaustIamge.isVisible = false
exhaustIamge.x, exhaustIamge.y = 0,shipImage.height*.5
exhaustIamge:toBack()
shipImage.x, shipImage.y = 0,0
ship.x, ship.y = 0,0
-- -22 for x, values -26 for y
local hullShape = { 3,-26, 13,-9, 13,7, 9,22, -9,22, -13,7, -13,-9, -3,-26 }
local wingShape = { 13,9, 22,23, -22,23, -13,9}
ship.HP = 100
ship.startingHP = 100
ship.class = "ship"
ship.weapon = "particleCannon"
ship.weaponLevel = "level2"
ship.lastFired = 0
ship.isBullet = true
ship.isMoving = false
 
function ship:gotShot(bullet)
	self.HP = self.HP - bullet.damage
end
	
physics.addBody( ship, "dynamic",
	{ density=1.5, friction=0.5, bounce=0.1, shape=hullShape, filter=collisionDetections["shipCollisionFilter"] },
	{ density=1.5, friction=0.5, bounce=0.1, shape=wingShape, filter=collisionDetections["shipCollisionFilter"] }
)
ship.linearDamping = .6
ship.angularDamping = .7

-- AUDIO
	
--local shootSound = audio.loadSound( "Laser_Shoot.wav" )
local engineSound = audio.loadSound( "audio/engine.wav" )
local engineSoundChannel = 4
	
local getShip = function()
	return ship
end
M.getShip = getShip

local shipIsStopped = function( )
	audio.stop( engineSoundChannel )
	exhaustIamge.isVisible = false
	ship.isMoving = false
	shipImage:setFrame(3)
end
M.shipIsStopped = shipIsStopped

local tilt = function(direction)
	if direction == "right" then
		if shipImage.frame < 5 then
			shipImage:setFrame( shipImage.frame + 1 )
		end
	elseif direction == "left" then
		if shipImage.frame > 1 then
			shipImage:setFrame( shipImage.frame - 1 )
		end
	end
end

local moveShip = function( event )
	-- changes to get ship appear to be moving
	if ship.isMoving == false then
		audio.play( engineSound, { loops=-1, channel=4 }  )
		exhaustIamge.isVisible = true
		ship.isMoving = true
	end
	
	-- get angle between touch and ship
	local angle = utilityModule.angleBetweenWithSrcLocalToContent(ship, event)
	if angle < 0 then angle = angle + 360 end
		
	-- get ship rotation
	local shipRotation = ship.rotation
	if math.abs(shipRotation) > 360 then shipRotation = shipRotation % 360 end
	if shipRotation < 0 then shipRotation = 360 + shipRotation end

	if math.abs(angle - shipRotation) > 10 then
		-- get adjusted angle from ship rotation to touch
		local adjustedAngle = 360 - shipRotation + angle
		if math.abs(adjustedAngle) > 360 then adjustedAngle = adjustedAngle % 360 end
			
		if adjustedAngle > 180 then
			ship:rotate(-5)
			tilt("left")
		else
			ship:rotate(5)
			tilt("right")
		end
		--print("shipRotation: " .. shipRotation .. "  angle: " .. angle .. "  adjustedAngle: " .. adjustedAngle)
	end
		
	local radian = math.rad(ship.rotation)
	local forceMultiplier=20
	local force_x = math.sin(radian) * forceMultiplier
	local force_y = math.cos(radian) * -forceMultiplier
		
	ship:applyForce( force_x, force_y, ship.x, ship.y )
end
M.moveShip = moveShip


local shootBullet = function( event )
	shipCommonModule.shoot(ship)
	return true
end
M.shootBullet = shootBullet

return M