--[[

登录框

]]
local START, REGISTER, MANAGER = 1, 2, 3 
local PATH = IMG_SCENE.."login/"

local M = {
	layer,
	optLayer,
	account,
	password,
	account1,
	account2
}

local onAttachWithIME
local onAttachWithIME1
local onAttachWithIME2
local MY_STATE
function M:create( ... )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	local bg = newSprite(PATH.."login_bg.jpg")
	setAnchPos(bg, 0, 0)
	this.layer:addChild(bg)
	
	this:createOptBox(START)
--
--	
	
--
--跳 过按钮

	local exit = Btn:new(IMG_SCENE.."fighting/",{"fighting_quit.png"},420,800,{
		scale = true,
		priority = -199,
		callback = 
		function()
			
		end})
	this.layer:addChild(exit:getLayer())
	
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
	function(type,x,y)
		if type == CCTOUCHBEGAN then
			if this:getRange():containsPoint(ccp(x,y)) then
				if MY_STATE ~= 3 then
					if x > 124 and x < 384 and y > 386 and y < 427 then
						if this.account then
							if onAttachWithIME then				
								this.account:detachWithIME()
								onAttachWithIME = false
							else	
								this.account:attachWithIME()
								onAttachWithIME1 = false
								onAttachWithIME = true
							end
						end
					elseif x > 124 and x < 384 and y > 304 and y < 348 then
						if this.account1 then
							if onAttachWithIME1 then				
								this.account1:detachWithIME()
								onAttachWithIME1 = false
							else	
								this.account1:attachWithIME()
								onAttachWithIME = false
								onAttachWithIME1 = true
							end
						end
					end
				else
					if x > 124 and x < 384 and y > 482 and y < 526 then
						if this.account then
							if onAttachWithIME then				
								this.account:detachWithIME()
								onAttachWithIME = false
							else	
								this.account:attachWithIME()
								--onAttachWithIME1 = false
								onAttachWithIME = true
								onAttachWithIME1 = false
								onAttachWithIME2 = false
								onAttachWithIME3 = false
							end
						end
					elseif x > 124 and x < 384 and y > 404 and y < 449 then
						if this.account1 then
							if onAttachWithIME1 then				
								this.account1:detachWithIME()
								onAttachWithIME1 = false
							else	
								this.account1:attachWithIME()
								--onAttachWithIME = false
								onAttachWithIME1 = true
								onAttachWithIME2 = false
								onAttachWithIME3 = false
								onAttachWithIME = false
							end
						end
					elseif x > 124 and x < 384 and y > 326 and y < 367 then
						if this.account2 then
							if onAttachWithIME2 then				
								this.account2:detachWithIME()
								onAttachWithIME2 = false
							else	
								this.account2:attachWithIME()
								--onAttachWithIME = false
								onAttachWithIME2 = true
								onAttachWithIME3 = false
								onAttachWithIME1 = false
							end
						end
					end
				end
			end
		end
		return false
	end,false,-150,false)
	
	
	return this.layer
end

function M:createOptBox(state)
	if self.optLayer then
		self.layer:removeChild(self.optLayer,true)
		self.optLayer = nil
	end
	
	if state then	
		self.optLayer = CCLayer:create()
		
		local bg = newSprite(PATH.."login_opt_bg.png")
		setAnchPos(bg, 240, 425, 0.5, 0.5)
		self.optLayer:addChild(bg)
		
		local opt	
		--根据选择的操作 创建对应的布局与功能按钮
		if state == START then
			opt = {
				{"register",
					function()
						local user_name = FileManager.readfile("user.txt" , "username" , "=")	
						local user_password = FileManager.readfile("user.txt" , "password" , "=")
						--if user_name == "0" or user_name == nil then
							self:createOptBox()
							self:accountInput(1)
						--else  
							--Dialog.tip("您已经注册过，请登录！")
						--end
						
					end
				},
				{"login", -- 点击登陆按钮，则隐藏操作 选框并生成账号输入界面
					function()
						--local user_name = FileManager.readfile("user.txt" , "username" , "=")	
						--local user_password = FileManager.readfile("user.txt" , "password" , "=")
						--if user_name == "0" or user_name == nil then
						--	Dialog.tip("您还没有注册用户，请注册！")
						--else
							self:createOptBox()
							self:accountInput(2)
						--end
						
					end
				}
				,
				{"manager",
					function()
						self:createOptBox()
						self:accountInput(3)
					end
				}
				
			}
			
			local y = 550
			for i = 1, #opt do
				local optBtn = Btn:new(IMG_BTN,{"btn_bg_login.png", "btn_bg_login_press.png"},100,y,{
					front = {IMG_TEXT..opt[i][1]..".png", IMG_TEXT..opt[i][1].."_press.png"},
					callback = opt[i][2]
				})
				self.optLayer:addChild(optBtn:getLayer())
				y = y - 150
			end
		elseif state == REGISTER then
			
		elseif state == MANAGER then
		
		end 
		
		self.layer:addChild(self.optLayer)
	end
end

function M:accountInput(state)
	MY_STATE = state
	if self.optLayre then
		self.layer:removeChild(self.optLayer,true)
	end
	self.optLayer = newLayer()
	
	local accountLayer = newLayer()
	
	
	
	
	local user_name = FileManager.readfile("user.txt" , "username" , "=")	
	local user_password = FileManager.readfile("user.txt" , "password" , "=")
	
	if state == 1 then
		local login_button = Btn:new(IMG_BTN,{"btn_bg.png", "btn_bg_press.png"},150,100,{
				other = {IMG_TEXT.."register.png",105,37},
				callback = 
				function()
					--if user_name == "0" or user_name == nil then
						CONFIG_HTTP_URL = "http://ztczs.com:4755/"
						local open_id = self.account:getString()
						local open_id1 = self.account1:getString()
						open_id = string.trim( open_id )
						open_id1 = string.trim( open_id1 )
						if open_id == "" or open_id1 == "" then
							Dialog.tip("请输入用户名和密码")
							return
						end
						HTTPS:send("User" , {m="init",a="init",init = "register",name = self.account:getString(),password = self.account1:getString()} )    -- 登录
					--elseif user_password ~= "0" then
					--	Dialog.tip("您已经注册过，请登录！")
					--end
					
				end})
			self.optLayer:addChild(login_button:getLayer())
			
			self.layer:addChild(self.optLayer)
	elseif state == 2 then
		local login_button = Btn:new(IMG_BTN,{"login_opt.png", "login_opt_press.png"},150,100,{
			callback = 
			function()
				CONFIG_HTTP_URL = "http://ztczs.com:4755/"
				local open_id = self.account:getString()
				local open_id1 = self.account1:getString()
				open_id = string.trim( open_id )
				open_id1 = string.trim( open_id1 )
				if open_id == "" or open_id1 == "" then
					Dialog.tip("请输入用户名和密码")
					return
				end
				HTTPS:send("User" , {m="init",a="init",init = "land",name = self.account:getString(),password = self.account1:getString()} )    -- 登录
			end})
		self.optLayer:addChild(login_button:getLayer())
		
		self.layer:addChild(self.optLayer)
	elseif state == 3 then
		local login_button = Btn:new(IMG_BTN,{"login_opt.png", "login_opt_press.png"},150,100,{
			callback = 
			function()
				CONFIG_HTTP_URL = "http://ztczs.com:4755/"
				local open_id = self.account:getString()
				local open_id1 = self.account1:getString()
				local open_id2 = self.account2:getString()
				open_id = string.trim( open_id )
				open_id1 = string.trim( open_id1 )
				open_id2 = string.trim( open_id2 )
				if open_id == "" or open_id1 == "" or open_id2 == "" then
					Dialog.tip("请输入新密码")
					return
				end
				HTTPS:send("User" , {m="init",a="init",init = "manage",name = self.account:getString(),old_password = self.account1:getString(),new_password = self.account2:getString()} )    -- 登录
			end})
		self.optLayer:addChild(login_button:getLayer())
		
		self.layer:addChild(self.optLayer)
	end
	
	if state ~= 3 then
		local accountText = newSprite(IMG_TEXT.."account_text.png")
		setAnchPos(accountText,40,485)
		accountLayer:addChild(accountText)
		
		accountText = newSprite(PATH.."input_bg.png")
		setAnchPos(accountText,120,480)
		accountLayer:addChild(accountText)
		
		
		local pwdText = newSprite(IMG_TEXT.."password_text.png")
		setAnchPos(pwdText,40,405)
		accountLayer:addChild(pwdText)
		
		pwdText = newSprite(PATH.."input_bg.png")
		setAnchPos(pwdText,120,400)
		accountLayer:addChild(pwdText)
		
		
		setAnchPos(accountLayer, 0, -100)
	
		--[[创建输入框]]
		self.account = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 40);
		self.account:setString("")
		--[[设置颜色]]
		self.account:setColor( ccc3(255 , 255 , 0) )
		self.account:setColorSpaceHolder( ccc3(255 , 255 , 0) )
		setAnchPos(self.account, 240, 485, 0.5)
		accountLayer:addChild( self.account )
		
		--[[创建输入框]]
		self.account1 = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 40);
		self.account1:setString("")
		--[[设置颜色]]
		self.account1:setColor( ccc3(255 , 255 , 0) )
		self.account1:setColorSpaceHolder( ccc3(255 , 255 , 0) )
		setAnchPos(self.account1, 240, 405, 0.5)
		accountLayer:addChild( self.account1 )
		
		if state == 2 then
			if user_name == "0" or user_name == nil then
				onAttachWithIME = true
				self.account:attachWithIME()
			else
				self.account:setString(user_name)
				self.account1:setString(user_password)
				CONFIG_HTTP_URL = "http://ztczs.com:4755/"
				HTTPS:send("User" , {m="init",a="init",init = "land",name = self.account:getString(),password = self.account1:getString()} ) 
			end
		end
		
	else
		local accountText = newSprite(IMG_TEXT.."account_text.png")
		setAnchPos(accountText,40,585)
		accountLayer:addChild(accountText)
		
		accountText = newSprite(PATH.."input_bg.png")
		setAnchPos(accountText,120,580)
		accountLayer:addChild(accountText)
		
		
		local pwdText = newSprite(IMG_TEXT.."old_password.png")
		setAnchPos(pwdText,16,505)
		accountLayer:addChild(pwdText)
		
		pwdText = newSprite(PATH.."input_bg.png")
		setAnchPos(pwdText,120,500)
		accountLayer:addChild(pwdText)		
		
		
		local newText = newSprite(IMG_TEXT.."new_password.png")
		setAnchPos(newText,16,425)
		accountLayer:addChild(newText)
		
		newText = newSprite(PATH.."input_bg.png")
		setAnchPos(newText,120,420)
		accountLayer:addChild(newText)		
	
		
		
		--[[创建输入框]]
		self.account = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 40);
		self.account:setString("")
		--[[设置颜色]]
		self.account:setColor( ccc3(255 , 255 , 0) )
		self.account:setColorSpaceHolder( ccc3(255 , 255 , 0) )
		setAnchPos(self.account, 240, 585, 0.5)
		accountLayer:addChild( self.account )
		
		--[[创建输入框]]
		self.account1 = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 40);
		self.account1:setString("")
		--[[设置颜色]]
		self.account1:setColor( ccc3(255 , 255 , 0) )
		self.account1:setColorSpaceHolder( ccc3(255 , 255 , 0) )
		setAnchPos(self.account1, 240, 505, 0.5)
		accountLayer:addChild( self.account1 )
		
		
		--[[创建输入框]]
		self.account2 = CCTextFieldTTF:textFieldWithPlaceHolder("Open ID" , "Thonburi" , 40);
		self.account2:setString("")
		--[[设置颜色]]
		self.account2:setColor( ccc3(255 , 255 , 0) )
		self.account2:setColorSpaceHolder( ccc3(255 , 255 , 0) )
		setAnchPos(self.account2, 240, 425, 0.5)
		accountLayer:addChild( self.account2 )
		
		self.account:setString(user_name)
		self.account1:setString(user_password)
	end
	setAnchPos(accountLayer, 0, -100)
	self.optLayer:addChild(accountLayer)
end

function M:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	x = x + parent:getPositionX()
	y = y + parent:getPositionY()
	while parent:getParent() do
		parent = parent:getParent()
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()		
	end
	return CCRectMake(x,y,self.layer:getContentSize().width,self.layer:getContentSize().height)
end

return M
