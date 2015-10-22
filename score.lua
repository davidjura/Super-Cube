local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local move = audio.loadSound("src/move.wav")

local ego = require "ego"
local saveFile = ego.saveFile
local loadFile = ego.loadFile
local highscore = loadFile("highscore.txt")
local showMedal = true

local leaderboardId = "--id goes here--" 

local achievement5 = "--id goes here--" 
local achievement10 = "--id goes here--"
local achievement20 = "--id goes here--"
local achievement30 = "--id goes here--"
local achievement50 = "--id goes here--"

function scene:createScene( event )
  local group = self.view
  display.setDefault( "magTextureFilter", "nearest" )
  display.setDefault( "minTextureFilter", "nearest" )

  local bg = display.newImageRect("src/bg.png", display.contentWidth/2,display.contentHeight/2 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(2,2)
  group:insert(bg)

  local menu = display.newImage("src/menu.png", display.contentWidth/2,display.contentHeight/2.6)
  menu:scale(4,4)
  group:insert(menu)

  btnGo = display.newImage("src/btnPlay.png", (display.contentWidth/2),(display.contentHeight/2)+170)
  btnGo:scale(4,4)
  group:insert(btnGo)

  btnPbScore = display.newImage("src/btnScore.png", (display.contentWidth/2)+50,(display.contentHeight/2)+100)
  btnPbScore:scale(3,3)
  group:insert(btnPbScore)

  btnHelp = display.newImage("src/btnHelp.png",(display.contentWidth/2)-50,(display.contentHeight/2)+100)
  btnHelp:scale(3,3)
  group:insert(btnHelp)
  --------------
  local scLabel = display.newText("Score", (display.contentWidth/1.4)+2, (display.contentHeight/3.8)+2, "Pixelated", 24)
  scLabel:setFillColor(black)
  group:insert(scLabel)

  local scLabel2 = display.newText("Score", (display.contentWidth/1.4), (display.contentHeight/3.8), "Pixelated", 24)
  scLabel2:setFillColor(255/255, 245/255, 195/255)
  group:insert(scLabel2)

if currscore == nil then
  showMedal = false
  local sc = display.newText(" ", (display.contentWidth/1.4), (display.contentHeight/2.95), "Pixelated", 40)
  sc:setFillColor(255/255, 245/255, 195/255)
  group:insert(sc)
else

  local sc = display.newText(currscore, (display.contentWidth/1.4)+2, (display.contentHeight/2.95)+2, "Pixelated", 40)
  sc:setFillColor(black)
  group:insert(sc)
  local sc1 = display.newText(currscore, (display.contentWidth/1.4), (display.contentHeight/2.95), "Pixelated", 40)
  sc1:setFillColor(255/255, 245/255, 195/255)
  group:insert(sc1)

end

  local hsLabel = display.newText("HighScore", (display.contentWidth/1.4)+2, (display.contentHeight/2.4)+2, "Pixelated", 24)
  hsLabel:setFillColor(black)
  group:insert(hsLabel)
  local hsLabel1 = display.newText("HighScore", (display.contentWidth/1.4), (display.contentHeight/2.4), "Pixelated", 24)
  hsLabel1:setFillColor(255/255, 245/255, 195/255)
  group:insert(hsLabel1)

if truehs == nil then
  if highscore ~= "empty" then
    local hs = display.newText(highscore, (display.contentWidth/1.4)+2, (display.contentHeight/2)+2, "Pixelated", 40)
    hs:setFillColor(black)
    group:insert(hs)
    local hs1 = display.newText(highscore, (display.contentWidth/1.4), (display.contentHeight/2), "Pixelated", 40)
    hs1:setFillColor(255/255, 245/255, 195/255)
    group:insert(hs1)
  end
else
  if truehs ~= "empty" then
    local hs = display.newText(truehs, (display.contentWidth/1.4)+2, (display.contentHeight/2)+2, "Pixelated", 40)
    hs:setFillColor(black)
    group:insert(hs)
    local hs1 = display.newText(truehs, (display.contentWidth/1.4), (display.contentHeight/2), "Pixelated", 40)
    hs1:setFillColor(255/255, 245/255, 195/255)
    group:insert(hs1)
  end
end

  if showMedal == false then
  	local nmedal = display.newImage("src/noMedal.png", display.contentWidth/3.3, display.contentHeight/2.5)
  	nmedal:scale(6,6)
  	group:insert(nmedal)
  elseif currscore <= 10 then
  	local bmedal = display.newImage("src/medalBronze.png", display.contentWidth/3.3, display.contentHeight/2.5)
  	bmedal:scale(6,6)
  	group:insert(bmedal)
  elseif currscore <= 20 then
  	local smedal = display.newImage("src/medalSilver.png", display.contentWidth/3.3, display.contentHeight/2.5)
  	smedal:scale(6,6)
  	group:insert(smedal)
  else
  	local gmedal = display.newImage("src/medalGold.png", display.contentWidth/3.3, display.contentHeight/2.5)
  	gmedal:scale(6,6)
  	group:insert(gmedal)
  end


end

local function submitScore(score)
  if gameNetwork.request("isConnected") then
    gameNetwork.request("setHighScore", 
      {
        localPlayerScore = 
        {
          category = leaderboardId, -- Id of the leaderboard to submit the score into
          value = score -- The score to submit
        }
      })
  end
end

local function unlockAchievement(achId)
  if gameNetwork.request("isConnected") then
    gameNetwork.request("unlockAchievement",
      {
        achievement = 
        {
          identifier = achId -- The id of the achievement to unlock for the current user
        }
      })
  end
end

local function checkAchievment(event)
if currscore >= 5 and currscore < 10 then
      unlockAchievement(achievement5)
    elseif currscore >= 10 and currscore < 20 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
    elseif currscore >= 20 and currscore < 30 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
    elseif currscore >=30 and currscore < 40 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
      unlockAchievement(achievement30)
    elseif currscore >= 50 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
      unlockAchievement(achievement30)
      unlockAchievement(achievement50)
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

local function goToGame(event)
	if event.phase == "ended" then
		audio.play(move)
    btnGo.y = btnGo.y - 3
		storyboard.gotoScene("game", {effect = "fade", time = 500})
	end

	if event.phase == "began" then
		btnGo.y = btnGo.y + 3
	end
end

local function showLeaderboards( event )
    if event.phase == "began" then
      btnPbScore.y = btnPbScore.y + 3
    end
    if event.phase == "ended" then
      btnPbScore.y = btnPbScore.y - 3
    end

  if gameNetwork.request("isConnected") then
    if lasths ~= nil and lasths < tonumber(truehs) then
      submitScore(truehs)
    end
    gameNetwork.show("leaderboards")
  else
    -- Tries to login the user, if there is a problem then it will try to resolve it. eg. Show the log in screen.
    gameNetwork.request("login",
      {
        userInitiated = true
      })
    if gameNetwork.request("isConnected") then
    submitScore(truehs)
    checkAchievment()
    gameNetwork.show("leaderboards")
  end
  end

end

function scene:enterScene( event )
  local group = self.view
  ads.show( "banner", {x=0, y=0, appId=bannerAd } )
  storyboard.removeScene("game")
  storyboard.removeScene("menu")
  btnGo:addEventListener( "touch", goToGame )
  btnPbScore:addEventListener("touch", showLeaderboards)
  btnHelp:addEventListener( "touch", goToHelp )
  if gameNetwork.request("isConnected") then
    if lasths ~= nil and lasths < tonumber(truehs) then
      submitScore(truehs)
    end

    if currscore >= 5 and currscore < 10 then
      unlockAchievement(achievement5)
    elseif currscore >= 10 and currscore < 20 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
    elseif currscore >= 20 and currscore < 30 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
    elseif currscore >=30 and currscore < 40 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
      unlockAchievement(achievement30)
    elseif currscore >= 50 then
      unlockAchievement(achievement5)
      unlockAchievement(achievement10)
      unlockAchievement(achievement20)
      unlockAchievement(achievement30)
      unlockAchievement(achievement50)
    end
  end
end

function scene:exitScene( event )
  local group = self.view
 	audio.dispose()
 	currscore = 0
  storyboard.removeScene("game")
 	storyboard.purgeAll()
 	storyboard.removeAll()
end
 
 
scene:addEventListener( "createScene", scene )
 
scene:addEventListener( "enterScene", scene )
 
scene:addEventListener( "exitScene", scene )
 
 
return scene