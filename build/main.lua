-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

-- require controller module
local storyboard = require "storyboard"

local function printMemUsage()          
	local memUsed = (collectgarbage("count")) / 1000
	local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000
        
	print("\n---------MEMORY USAGE INFORMATION---------")
	print("System Memory Used:", string.format("%.03f", memUsed), "Mb")
	print("Texture Memory Used:", string.format("%.03f", texUsed), "Mb")
	print("------------------------------------------\n")
     
	return true
end

timer.performWithDelay( 5000, printMemUsage, 0 )

-- load first screen
storyboard.gotoScene( "source.scenes.splashScene" )
--storyboard.gotoScene( "source.scenes.gameScene" )
--storyboard.gotoScene( "source.scenes.levelSelectionScene" )

