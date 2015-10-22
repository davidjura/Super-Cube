local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local showCross = false
local counter = 0

local bg
local inst
local inst1
local bird
local ball1
local ball2
local cross

function scene:createScene( event )
  local group = self.view
storyboard.removeAll()
  display.setDefault( "magTextureFilter", "nearest" )
  display.setDefault( "minTextureFilter", "nearest" )

  bg = display.newImageRect("src/help.png", display.contentWidth/2,display.contentHeight/2 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(2,2)
  group:insert(bg)
  bg:addEventListener( "touch", goTo2 )

  inst = display.newText("Avoid catching the\nball that's opposite of\nyour cube's current\ncolor", (display.contentWidth/2)-25, (display.contentHeight/2)-25, "b04b04", 15)
  inst:setFillColor(black)
  group:insert(inst)

  inst1 = display.newText("Avoid catching the\nball that's opposite of\nyour cube's current\ncolor", ((display.contentWidth/2)-25)-1, ((display.contentHeight/2)-25)-1, "b04b04", 15)
  inst1:setFillColor(18/255, 151/255, 147/255)
  group:insert(inst1)

  bird = display.newImage("src/birdUp.png", (display.contentWidth/2)+70, (display.contentHeight/2)+80)
  bird:scale(4,4)
  group:insert(bird)

  ball1 = display.newImage("src/rBall.png", (display.contentWidth/2)+70, (display.contentHeight/2)+30)
  ball1:scale(4,4)
  group:insert(ball1)

  ball2 = display.newImage("src/bBall.png", (display.contentWidth/2)-80, (display.contentHeight/2)-170)
  ball2:scale(4,4)
  group:insert(ball2)

  cross = display.newImage("src/hcross.png", (display.contentWidth/2)+70, (display.contentHeight/2)+50)
  cross:scale(5,5)
  cross.alpha = 0
  group:insert(cross)
end

local function animCross(event)
    if showCross == false and cross ~= nil then
      cross.alpha = 1
      showCross = true
    elseif showCross == true and cross ~= nil then
      cross.alpha = 0
      showCross = false
    end
end

function goTo2(event)
  if event.phase == "began" then
    if counter == 0 then
      bird:removeSelf()
      bird = nil
      bird = display.newImage("src/birdUpRed.png", (display.contentWidth/2)+70, (display.contentHeight/2)+80)
      bird:scale(4,4)

      ball1:removeSelf()
      ball1 = nil
      ball1 = display.newImage("src/bBall.png", (display.contentWidth/2)+70, (display.contentHeight/2)+30)
      ball1:scale(4,4)

      ball2:removeSelf()
      ball2 = nil
      ball2 = display.newImage("src/rBall.png", (display.contentWidth/2)-80, (display.contentHeight/2)-170)
      ball2:scale(4,4)

      cross:removeSelf()
      cross = nil
      cross = display.newImage("src/hcross.png", (display.contentWidth/2)+70, (display.contentHeight/2)+50)
      cross:scale(5,5)

      counter = 1
    elseif counter == 1 then
      bg:removeSelf()
      bg = nil
      bg = display.newImageRect("src/help2.png", display.contentWidth/2,display.contentHeight/2 )
      bg.x = display.contentWidth/2
      bg.y = display.contentHeight/2
      bg:scale(2,2)
      bg:addEventListener( "touch", goTo2 )

      bird:removeSelf()
      bird = nil
      bird = display.newImage("src/birdUp.png", (display.contentWidth/2)+70, (display.contentHeight/2)+80)
      bird:scale(4,4)

      ball1:removeSelf()
      ball1 = nil
      ball1 = display.newImage("src/bBall.png", (display.contentWidth/2)-82, (display.contentHeight/2)+190)
      ball1:scale(4,4)

      ball2:removeSelf()
      ball2 = nil

      cross:removeSelf()
      cross = nil
      cross = display.newImage("src/hcross.png", (display.contentWidth/2)-82, (display.contentHeight/2)+190)
      cross:scale(5,5)

      inst:removeSelf()
      inst = nil
      inst = display.newText("Careful! Don't let the ball\nthat matches the color\nof your cube pass by!", (display.contentWidth/2), (display.contentHeight/2)-25, "b04b04", 15)
      inst:setFillColor(black)

      inst1:removeSelf()
      inst1 = nil
      inst1 = display.newText("Careful! Don't let the ball\nthat matches the color\nof your cube pass by!", (display.contentWidth/2)-1, ((display.contentHeight/2)-25)-1, "b04b04", 15)
      inst1:setFillColor(18/255, 151/255, 147/255)

      counter = 2
    elseif counter == 2 then
      bird:removeSelf()
      bird = nil
      bird = display.newImage("src/birdUpRed.png", (display.contentWidth/2)+70, (display.contentHeight/2)+80)
      bird:scale(4,4)

      ball1:removeSelf()
      ball1 = nil
      ball1 = display.newImage("src/rBall.png", (display.contentWidth/2)-82, (display.contentHeight/2)+190)
      ball1:scale(4,4)

      counter = 3
    elseif counter == 3 then
      storyboard.gotoScene("menu", {effect = "crossFade", time = 500})
    end
  end
end

function scene:enterScene( event )
  local group = self.view
  timer.performWithDelay(500, animCross, 0)
end


function scene:exitScene( event )
  local group = self.view
  group:insert(bg)
  group:insert(bird)
  group:insert(ball1)
  group:insert(cross)
  group:insert(inst)
  group:insert(inst1)
end

 
scene:addEventListener( "createScene", scene )
 
scene:addEventListener( "enterScene", scene )
 
scene:addEventListener( "exitScene", scene )
 
 
return scene