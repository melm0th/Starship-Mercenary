local enemyTypes = {}

local enemyTypeFighter1 = {
	name = "figher1",
	image = "graphics/enemy1.png",
	startingHP = 17,
	healthBarWidth = 20,
	class = "enemy",
	weapon = "particleCannon",
	weaponLevel = "level1",
	-- x = -19   y = -23
	shape1 = {12,-23, 18,-4, 14,14, 0,23, 0,-11},
	shape2 = {-12,-23, 0,-11, 0,23, -14,14, -18,-4}
}
enemyTypes["enemyTypeFighter1"] = enemyTypeFighter1

return enemyTypes