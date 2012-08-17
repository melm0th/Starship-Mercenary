-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

-- require controller module
local storyboard = require "storyboard"

-- load first screen
storyboard.gotoScene( "source.scenes.splashScene" )
--storyboard.gotoScene( "source.scenes.gameScene" )
--storyboard.gotoScene( "source.scenes.levelSelectionScene" )