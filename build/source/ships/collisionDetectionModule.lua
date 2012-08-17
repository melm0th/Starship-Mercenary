local collisionDetections = {}
-- from http://developer.coronalabs.com/forum/2010/10/25/collision-filters-helper-chart

--	1	2	4	8	16
--1			x	x
--2			x
--4	x	x
--8	x


local shipCollisionFilter = { categoryBits = 1, maskBits = 12 }
local bulletCollisionFilter = { categoryBits = 2, maskBits = 4 }
local enemyCollisionFilter = { categoryBits = 4, maskBits = 3 }
local enemyBulletCollisionFilter = { categoryBits = 8, maskBits = 1 }
collisionDetections["shipCollisionFilter"] = shipCollisionFilter
collisionDetections["bulletCollisionFilter"] = bulletCollisionFilter
collisionDetections["enemyCollisionFilter"] = enemyCollisionFilter
collisionDetections["enemyBulletCollisionFilter"] = enemyBulletCollisionFilter

return collisionDetections