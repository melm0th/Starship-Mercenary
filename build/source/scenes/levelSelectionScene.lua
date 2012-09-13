---------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local text1
local buttonTable = {}

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	text1 = display.newText( "Choose a level", 0, 0, native.systemFontBold, 24 )
	text1:setTextColor( 255 )
	text1:setReferencePoint( display.CenterReferencePoint )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	screenGroup:insert( text1 )
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view
	-- remove previous scene's view
	local priorScene = storyboard.getPrevious()
    storyboard.purgeScene( priorScene )
	
	local widget = require "widget"
	local levels = require "source.levels.levelModule"
	local player = require "source.playerModule"
	
	local function onButtonRelease( event )
		local button = event.target
		player.level = button.id
		player.wave = 0
		storyboard.gotoScene( "source.scenes.gameScene", "fade", 800  )
	end

	row = 1
	column = 1
	local buttonWidth = display.contentWidth/3 - 30
	for k,level in ipairs(levels) do 		
		local button = widget.newButton{
			id = k,
			label = level.name,
			width = buttonWidth,
			height = 28,
			emboss = true,
			cornerRadius = 8,
			left = 30 + ((column - 1) * ( buttonWidth + 10 ) ),
			top = 130 + ( row * 40 ),
			onRelease = onButtonRelease
		}
		screenGroup:insert( button )
		table.insert(buttonTable,button)
		
		column = column + 1
		if column > 3 then
			column = 1
			row = row + 1
		end
	end
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	-- remove touch listener for image
	Runtime:removeEventListener( "touch", onSceneTouch )
	for k,button in ipairs(buttonTable) do
		button:removeSelf()
		button = nil
	end
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene