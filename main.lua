local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

adid="--ad id goes here--"
bannerAd = "--banner ad id goes here--"


 ads = require( "ads" )

 function adListener( event )
    if ( event.isError ) then
        --Failed to receive an ad
    end
end

gameNetwork = require "gameNetwork"
widget = require "widget"

-- Init game network to use Google Play game services
gameNetwork.init("google")

ads.init("admob", adid, adListener)
ads.init("admob", bannerAd, adListener)

storyboard.gotoScene( "intro" )
display.setStatusBar( display.HiddenStatusBar )