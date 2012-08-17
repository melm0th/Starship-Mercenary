local weaponTypes = {}

local particleCannon = {
	level1 = {
		name = "particle cannon",
		damage = 3,
		class = "weapon",
		isCircle = true,
		radius = 2,
		force = 2,
		color = {20, 240, 130},
		refireTime = 2000
	},
	level2 = {
		name = "particle cannon",
		damage = 4,
		class = "weapon",
		isCircle = true,
		radius = 2,
		force = 4,
		color = {20, 130, 240},
		refireTime = 500
	}
}
weaponTypes["particleCannon"] = particleCannon

return weaponTypes