--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
requires(SRC.."Scene/home/homelayer")

requires(SRC.."Scene/common/notice")


local M = {}

function M:create()
	local scene = display.newScene("home")

	
	if FileManager.readfile("savefile.txt" , "sound" , "=") == "0" then
	
	else
		audio.stopMusic( false )
		audio.disable()
	end
	
	if FileManager.readfile("savefile.txt" , "audio" , "=") == "0" then
		audio.setIsEffect( true )
	else
		audio.setIsEffect( false )
	end
	
	if audio.isMusicPlaying() == false then
		audio.preloadMusic( SOUND.."home_bg.ogg")
		SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1)
		audio.playMusic( SOUND.."home_bg.ogg" , true )
	end
	
	---------------插入layer---------------------
	scene:addChild(HomeLayer:create(0,0))

--	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create("home"):getLayer())
	if DATA_User:get("on_off") ~= 1 then 
		if GONGGAO == 0 then
			scene:addChild(NoticeLayer:create():getLayer())
			GONGGAO = 1
		end	
	else
		if DATA_User:get("on_off") == 1 then Guide:show() end
	end
	
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
