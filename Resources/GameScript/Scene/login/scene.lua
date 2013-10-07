--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local loginbox_layer = requires(SRC.."Scene/login/loginbox")



local M = {}

function M:create()
	local scene = display.newScene("login")
	if FileManager.readfile("savefile.txt" , "sound" , "=") == "0" then
		audio.playMusic( SOUND.."login_bg.ogg" , true )
	else
		audio.stopMusic( false )
		audio.disable()
	end
	---------------插入layer---------------------
	scene:addChild( loginbox_layer:create() )
	---------------------------------------------

	return scene
end

return M
