--[[

登录框

]]

local KNBtn = require "GameLuaScript/Common/KNBtn"
local M = {}


function M:create( ... )
	local layer = display.newLayer()


	--[[创建输入框]]
	local textfiled = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 48);
	textfiled:setString("web")
	--[[设置颜色]]
	textfiled:setColor( ccc3(255 , 255 , 0) )
	textfiled:setColorSpaceHolder( ccc3(255 , 255 , 0) )

	display.align(textfiled , display.CENTER , display.cx , display.cy + 100)
	layer:addChild( textfiled )


	--[[绑定事件]]
	local onAttachWithIME = true
	textfiled:attachWithIME()
	layer:addTouchEventListener( function()
		if onAttachWithIME then
			echoLog("Login" , "detachWithIME")

			textfiled:detachWithIME()
			onAttachWithIME = false
		else
			echoLog("Login" , "attachWithIME")

			textfiled:attachWithIME()
			onAttachWithIME = true
		end

		return false
	end )
	layer:setTouchEnabled( true )



	--[[登录按钮]]
	local login_callback = function()
		echoLog("Login" , "Click Login Button")
		-- echoLog("Login" , textfiled:getString() )
		local open_id = textfiled:getString()
		open_id = string.trim( open_id )

		if open_id == "" then
			-- 错误提示
			KNMsg:getInstance():flashShow("请输入OPEN ID")
			return
		end

		-- 发请求
		HTTPS:send("Landed" , {m="login",a="develop",open_id = open_id} )    -- 登录
	end

	
--跳 过按钮
	local login_button = KNBtn:new(COMMONPATH,{"login.png"},110,400,{
		scale = true,
		callback = login_callback})
	layer:addChild(login_button:getLayer())

	local exit = KNBtn:new("image/scene/fighting/",{"fighting_quit.png"},420,800,{
		scale = true,
		priority = -199,
		callback = 
		function()
			switchScene("fighting")
		end})
	layer:addChild(exit:getLayer())

	return layer
end

return M
