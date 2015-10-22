local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.purgeAll()

function scene:createScene( event )
  local group = self.view

  display.setDefault( "magTextureFilter", "nearest" )
  display.setDefault( "minTextureFilter", "nearest" )

  local bg = display.newImageRect("src/bg.png", display.contentWidth/2,display.contentHeight/2 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(2,2)
  group:insert(bg)

  local logo = display.newImage("src/logo.png", display.contentWidth/2, display.contentHeight/2)
  logo:scale(3.4,3.4)
  group:insert(logo)

  local title = display.newText("Copyright ©  2015 David Jura", display.contentWidth/2, display.contentHeight/1.6, "b04b04", 10)
  title:setFillColor(18/255, 151/255, 147/255)
  group:insert(title)
end

local function trans(event)
	storyboard.gotoScene( "menu", {time=1000, effect="crossFade"})
end

function scene:enterScene( event )
  local group = self.view
  timer.performWithDelay(2500, trans, 1)
end
 

function scene:exitScene( event )
  local group = self.view
end

 
scene:addEventListener( "createScene", scene )
 
scene:addEventListener( "enterScene", scene )
 
scene:addEventListener( "exitScene", scene )
 
 
return scene