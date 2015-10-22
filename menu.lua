local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
--1 = up, 2 = level, 3 = down
local birdPos = 1
local birdTitle
local incdec
local move = audio.loadSound("src/move.wav")
local btnPlay
local btnScore

counter = 0
dir = 2

function scene:createScene( event )
  local group = self.view
  storyboard.removeScene("hlp1")

   gameNetwork.request("login",
    {
      userInitiated = false
    })
  display.setDefault( "magTextureFilter", "nearest" )
  display.setDefault( "minTextureFilter", "nearest" )

  ads.show( "banner", { x=0, y=0, appId=bannerAd } )

  local bg = display.newImageRect("src/bg.png", display.contentWidth/2,display.contentHeight/2 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(2,2)
  group:insert(bg)

  local titleDrop = display.newText("SUPER CUBE", (display.contentWidth/2)+4, (display.contentHeight/4)+4, "04b", 32)
  local title = display.newText("SUPER CUBE", display.contentWidth/2, display.contentHeight/4, "04b", 32)
  titleDrop:setFillColor( black )
  title:setFillColor(255/255, 245/255, 195/255)
  group:insert(titleDrop)
  group:insert(title)

  birdTitle = display.newImage( "src/birdUp.png", display.contentWidth/2,display.contentHeight/2)
  birdTitle:scale( 4, 4 )
  birdTitle.y = (display.contentHeight/2)-40
  group:insert(birdTitle)

  btnPlay = display.newImage( "src/btnPlay.png", (display.contentWidth/2), (display.contentHeight/2)+130)
  btnPlay:scale( 4, 4 )
  group:insert(btnPlay)

  btnScore = display.newImage( "src/pbScore.png", (display.contentWidth/2)+50,(display.contentHeight/2)+50)
  btnScore:scale( 3, 3 )
  group:insert(btnScore)

  btnHelp = display.newImage("src/btnHelp.png",(display.contentWidth/2)-50,(display.contentHeight/2)+50)
  btnHelp:scale(3,3)
  group:insert(btnHelp)
end

local function updateBird(event)
	local x = birdTitle.x
	local y = birdTitle.y
	if birdPos == 1 then
		birdTitle:removeSelf()
		birdTitle = nil
		incdec = 1
		birdTitle = display.newImage( "src/birdUp.png", display.contentWidth/2,display.contentHeight/2)
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdPos = 2
	elseif birdPos == 2 and incdec == 1 then
		birdTitle:removeSelf()
		birdTitle = nil
		birdTitle = display.newImage( "src/birdMid.png", display.contentWidth/2,display.contentHeight/2)
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdPos = 3
		incdec = 0
	elseif birdPos == 2 and incdec == 0 then
		birdTitle:removeSelf()
		birdTitle = nil
		birdTitle = display.newImage( "src/birdMid.png", display.contentWidth/2,display.contentHeight/2)
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdPos = 1
	elseif birdPos == 3 then
		birdTitle:removeSelf()
		birdTitle = nil
		birdTitle = display.newImage( "src/birdDown.png", display.contentWidth/2,display.contentHeight/2)
		birdTitle:scale( 4, 4 )
		birdTitle.y = y
		birdTitle.x = x
		birdPos = 2
		incdec = 0
	end
end

local function updatePos(event)
	if counter ~= 5 then
		birdTitle.y = birdTitle.y + dir
		counter = counter + 1
	else

		counter = 0
		dir = -dir
	end
end

local function goToGame(event)
	if event.phase == "ended" then
		btnPlay.y = btnPlay.y - 3
		audio.play(move)
		timer.cancel( timer1 )
		timer.cancel( timer2 )
		storyboard.gotoScene("game", {effect = "crossFade", time = 500})
	end

	if event.phase == "began" then
		btnPlay.y = btnPlay.y + 3
	end
end

local function goToScore(event)
	if event.phase == "ended" then
		btnScore.y = btnScore.y - 3
		audio.play(move)
		timer.cancel( timer1 )
		timer.cancel( timer2 )
		storyboard.gotoScene("score", {effect = "crossFade", time = 500})
	elseif event.phase == "began" then
		btnScore.y = btnScore.y + 3
	end
end

local function goToHelp(event)
	if event.phase == "ended" then
		btnHelp.y = btnHelp.y - 3
		audio.play(move)
		timer.cancel( timer1 )
		timer.cancel( timer2 )
		storyboard.gotoScene("hlp1", {effect = "crossFade", time = 500})
	elseif event.phase == "began" then
		btnHelp.y = btnHelp.y + 3
	end
end


function scene:enterScene( event )
  local group = self.view
  storyboard.removeAll()
  timer1 = timer.performWithDelay( 100, updateBird, 0 )
  timer2 = timer.performWithDelay( 50, updatePos, 0 )
  btnPlay:addEventListener( "touch", goToGame )
  btnScore:addEventListener( "touch", goToScore )
  btnHelp:addEventListener( "touch", goToHelp )
end
 

function scene:exitScene( event )
  local group = self.view
  		group:insert(birdTitle)
		audio.dispose()
end

 
scene:addEventListener( "createScene", scene )
 
scene:addEventListener( "enterScene", scene )
 
scene:addEventListener( "exitScene", scene )
 
 
return scene