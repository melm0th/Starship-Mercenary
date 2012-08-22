local levels = {}

levels.levelComplete = false

local setup = function()
	levels.levelComplete = false
end
levels.setup = setup

local runLevel = function( )
	local player = require "source.playerModule"
	local enemyModule = require("source.ships.enemyModule")
	local activeEnemies = enemyModule.getActiveEnemies()
	
	if levels[player.level] == nil then
		print("level " .. player.level .. " complete")
		return
	end
	
	if activeEnemies.numChildren == 0 then
		player.wave = player.wave + 1	
		local wave = levels[player.level]["wave" .. player.wave]
		
		if wave == nil then 
			print ("levelComplete = true")
			levels.levelComplete = true
			return
		end
	
		for i = 1, wave.enemyNumber, 1 do
			enemyModule.buildEnemy( wave.enemyType )
		end
	end

	return
end
levels.runLevel = runLevel

levels[1] = {
	name = "level 1",
	wave1 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=1
	},
	wave3 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=5
	}
}

levels[2] = {
	name = "level 2",
	wave1 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=5
	},
	wave2 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=10
	}
}
levels[3] = {
	name = "level 3",
	wave1 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=5
	},
	wave2 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=10
	}
}
levels[4] = {
	name = "level 4",
	wave1 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=5
	},
	wave2 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=10
	}
}
levels[5] = {
	name = "level 5",
	wave1 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=50
	},
	wave2 = {
		enemyType="enemyTypeFighter1",
		enemyNumber=10
	}
}
return levels