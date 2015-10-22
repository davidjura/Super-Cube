local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
math.randomseed(os.time())

local x
--1 = up, 2 = level, 3 = down
local birdPos = 1
local birdTitle
local incdec
local counter = 1
local fade = true
--Going straight = 0
--Going right = 1
--Going left = 2
local rotation = 0
local isMoving = 0
local tmRight
local tmLeft
local score
local scoreDrop
local sc
local level = 1500
local birdStatus = "blue"
local lastBirdStatus = "red"
local tmcloud = 650

local ping = audio.loadSound("src/score.wav")
local move = audio.loadSound("src/move.wav")
local crunch = audio.loadSound("src/crunch.wav")

local ego = require "ego"
local saveFile = ego.saveFile
local loadFile = ego.loadFile

highscore = loadFile("highscore.txt")
local function checkForFile ()
	if highscore == "empty" then
		highscore = 0
		saveFile("highscore.txt", highscore)
	end
end

checkForFile()

currscore = 0
truehs = 0
lasths = nil

function scene:createScene( event )
  local group = self.view

  display.setDefault( "magTextureFilter", "nearest" )
  display.setDefault( "minTextureFilter", "nearest" )

  local bg = display.newImageRect("src/bg.png", display.contentWidth/2,display.contentHeight/2)
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(2,2)
  group:insert(bg)

  scoreDrop = display.newText("0", (display.contentWidth/2)+4, (display.contentHeight/4)+4, "04b", 32)
  score = display.newText("0", display.contentWidth/2, display.contentHeight/4, "04b", 32)
  scoreDrop:setFillColor( black )
  score:setFillColor(255/255, 245/255, 195/255)
  group:insert(scoreDrop)
  group:insert(score)

  sc = display.newImage("src/holder.png", display.contentWidth/2, display.contentHeight/2)
  sc:scale(4,4)
  group:insert(sc)

  birdTitle = display.newImage( "src/birdUp.png", display.contentWidth/2,display.contentHeight/2)
  birdTitle:scale( 4, 4)
  birdTitle.y = (display.contentHeight/2)+60
  group:insert(birdTitle)

  btnLeft = display.newImage( "src/btnFlyLeft.png", (display.contentWidth/2)-100, (display.contentHeight/2)+150)
  btnLeft:scale(4,4)
  btnLeft.alpha = 0.3
  group:insert(btnLeft)

  btnRight = display.newImage( "src/btnFlyRight.png", (display.contentWidth/2)+100, (display.contentHeight/2)+150)
  btnRight:scale(4,4)
  btnRight.alpha = 0.3
  group:insert(btnRight)

  x = display.newImage("src/x.png", display.contentWidth/2, display.contentHeight/2)
  x:scale(2,2)
  x.alpha = 0
  group:insert(x)


  ball = {}

  for i = 1,4 do
  	if math.random(1,2) == 1 then
		ball[i] = display.newImage( "src/bBall.png", display.contentWidth/2-50, display.contentHeight/2-310)
	else
		ball[i] = display.newImage( "src/bBall.png", display.contentWidth/2+50, display.contentHeight/2-310)
	end
  	ball[i].status = "blue"
  	ball[i]:scale( 4, 4)
  	group:insert(ball[i])
  end

  for i = 4,8 do
  	if math.random(1,2) == 1 then
		ball[i] = display.newImage( "src/rBall.png", display.contentWidth/2-50, display.contentHeight/2-310)
	else
		ball[i] = display.newImage( "src/rBall.png", display.contentWidth/2+50, display.contentHeight/2-310)
	end
  	ball[i].status = "red"
  	ball[i]:scale( 4, 4)
  	group:insert(ball[i])
  end
end

local function updateBird(event)
	if birdTitle ~= nil then
	local x = birdTitle.x
	local y = birdTitle.y
	local rt = sc.rotation
	if birdPos == 1 then
		birdTitle:removeSelf()
		birdTitle = nil
		incdec = 1
		if birdStatus == "blue" then
			birdTitle = display.newImage( "src/birdUp.png", display.contentWidth/2,display.contentHeight/2)
		else
			birdTitle = display.newImage( "src/birdUpRed.png", display.contentWidth/2,display.contentHeight/2)
		end
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdTitle.rotation = rt
		birdPos = 2
	elseif birdPos == 2 and incdec == 1 then
		birdTitle:removeSelf()
		birdTitle = nil
		if birdStatus == "blue" then
			birdTitle = display.newImage( "src/birdMid.png", display.contentWidth/2,display.contentHeight/2)
		else
			birdTitle = display.newImage( "src/birdMidRed.png", display.contentWidth/2,display.contentHeight/2)
		end
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdPos = 3
		birdTitle.rotation = rt
		incdec = 0
	elseif birdPos == 2 and incdec == 0 then
		birdTitle:removeSelf()
		birdTitle = nil
		if birdStatus == "blue" then
			birdTitle = display.newImage( "src/birdMid.png", display.contentWidth/2,display.contentHeight/2)
		else
			birdTitle = display.newImage( "src/birdMidRed.png", display.contentWidth/2,display.contentHeight/2)
		end
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdTitle.rotation = rt
		birdPos = 1
	elseif birdPos == 3 then
		birdTitle:removeSelf()
		birdTitle = nil
		if birdStatus == "blue" then
			birdTitle = display.newImage( "src/birdDown.png", display.contentWidth/2,display.contentHeight/2)
		else
			birdTitle = display.newImage( "src/birdDownRed.png", display.contentWidth/2,display.contentHeight/2)
		end
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdTitle.rotation = rt
		birdPos = 2
		incdec = 0
	end
	btnRight:toFront()
	btnLeft:toFront()
	scoreDrop:toFront()
	score:toFront()
end
end

function scene:enterScene( event )
  local group = self.view
  storyboard.removeScene("menu")
  storyboard.removeScene("score")
  ads.hide()
  ads.load( "interstitial", { appId=adid, testMode=false } )
  timerFlap = timer.performWithDelay( 100, updateBird, 0 )
  timerCloud = timer.performWithDelay( tmcloud, startFall, 0 )
  btnRight:addEventListener( "touch", triggerRight)
  btnLeft:addEventListener( "touch", triggerLeft )
  Runtime:addEventListener( "enterFrame", collide )
end

function scene:exitScene( event )
  local group = self.view
  		if fade == true then
  			Runtime:removeEventListener("enterFrame", collide)
  			group:insert(birdTitle)
  			audio.dispose()
			transition.cancel()
  		else
			birdTitle:removeSelf()
			birdTitle = nil
			audio.dispose()
			transition.cancel()
		end

end

function scene:didExitScene( event )
        local group = self.view
        if math.random(1,2) == 2 then
			ads.show("interstitial", {appId = adid})
		end
end

function cloudFall(obj)
	if level > 1100 then
		transition.to(obj, {time = level, delay = 0, y = display.contentHeight/2+260, onComplete = resetCloud})
		level = level - 10
			tmcloud = level/(1500/650)
			timerCloud._delay = tmcloud
	else
		transition.to(obj, {time = level, delay = 0, y = display.contentHeight/2+260, onComplete = resetCloud})
	end
end

function resetCloud(obj)
	if obj.status ~= birdStatus and LastBirdStatus ~= obj.status then
		obj.y = display.contentHeight/2-310
		math.randomseed(os.time())
		if math.random(1,2) == 1 then
			obj.x = display.contentWidth/2-50
		else
			obj.x = display.contentWidth/2+50
		end
	else
		x.x = obj.x
		x.y = display.contentHeight/2+225
		x.alpha = 1
		audio.play(move)
		kill()
	end
end

function startFall(event)
	math.randomseed(os.time())
local pick = math.random(1,8)
	while ball[pick].y ~= display.contentHeight/2-310 do
		pick = math.random(1,8)
	end

cloudFall(ball[pick])
end
function kill(event)
	timer.cancel( timerFlap )
	timer.cancel( timerCloud )
	if tmRight ~= nil then
		timer.cancel(tmRight)
	end
	if tmLeft ~= nil then
		timer.cancel(tmLeft)
	end
		if currscore > tonumber(highscore) then 
			lasths = truehs
			saveFile("highscore.txt", currscore)
			highscore = loadFile("highscore.txt")
		end
		truehs = highscore
	storyboard.gotoScene( "score" , {effect = "fade", time = 500})
	return
end
function collide(event)
	if birdTitle ~= nil then
		birdTitle.rotation = sc.rotation
	end

	for i=1,8 do
		if ball[i].y ~= display.contentHeight/2-310 then
			if hasCollided(ball[i], birdTitle) and birdStatus ~= ball[i].status then
				audio.play(crunch)
				kill()
			elseif hasCollided(ball[i], birdTitle) and birdStatus == ball[i].status then
				currscore = currscore + 1
				score.text = currscore
				audio.play(ping)
				scoreDrop.text = currscore
				transition.cancel(ball[i])

				if birdStatus == "blue" then
					lastBirdStatus = birdStatus
					birdStatus = "red"
				else
					lastBirdStatus = birdStatus
					birdStatus = "blue"
				end
				ball[i].y = display.contentHeight/2-310
				math.randomseed(os.time())
				local rnd = math.random(1,2)
				if rnd == 1 then
					ball[i].x = display.contentWidth/2-50
				else
					ball[i].x = display.contentWidth/2+50
				end

			end
		end
	end
end

function moveLeft(event)
	if isMoving == 2 then
		if birdTitle ~= nil  then
			if birdTitle.x < display.contentWidth/2-40 then
				timer.cancel(tmLeft)
				transition.to(sc, {time = 45, rotation = 0})
				return
			end
		birdTitle.x = birdTitle.x - 10
		end

	else
		timer.cancel( tmLeft )
	end
end


function moveRight(event)
	if isMoving == 1 then
		if birdTitle ~= nil then
			if birdTitle.x > display.contentWidth/2+40 then
				timer.cancel(tmRight)
				transition.to(sc, {time = 45, rotation = 0})
				return
			end
		birdTitle.x = birdTitle.x + 10
		end

	else
		timer.cancel( tmRight )
	end
end

function triggerLeft(event)
	if event.phase == "began" then
		btnLeft.y = btnLeft.y + 3
		if isMoving ~= 2 then
			if tmRight ~= nil then
				timer.cancel( tmRight )
			end
			audio.play(move)
			speedRight = 0.2
			transition.to(sc, {time = 45, rotation = -50})
			isMoving = 2
			tmLeft = timer.performWithDelay( 1, moveLeft, 0 )
		end
	end
	if event.phase == "ended" then
		btnLeft.y = btnLeft.y - 3
	end
end

function triggerRight(event)
	if event.phase == "began" then
		btnRight.y = btnRight.y + 3
		if isMoving ~= 1 then
			if tmLeft ~= nil then
				timer.cancel( tmLeft )
			end
			audio.play(move)
			speedLeft = 0.2
			transition.to(sc, {time = 45, rotation = 50})
			isMoving = 1
			tmRight = timer.performWithDelay( 1, moveRight, 0 )
		end
	end
	if event.phase == "ended" then
		btnRight.y = btnRight.y - 3
	end
end

function hasCollided(obj1, obj2)
 if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end

   local dx = obj1.x - obj2.x
   local dy = obj1.y - obj2.y

   local distance = math.sqrt( dx*dx + dy*dy )
   local objectSize = (obj2.contentWidth/2)-20 + (obj1.contentWidth/2)

   if ( distance < objectSize ) then
      return true
   end
   return false
end

scene:addEventListener( "createScene", scene )
 
scene:addEventListener( "enterScene", scene )
 
scene:addEventListener( "exitScene", scene )
 
scene:addEventListener( "didExitScene", scene )
 
return scene
