local PATH = IMG_SCENE.."role/"
local CreateRoleLayer = {
	layer,
	tabGroup,
	account,
	account1
}
local onAttachWithIME
local onAttachWithIME1
function CreateRoleLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	local bg = newSprite(PATH.."bg.png")
	this.layer:addChild(bg)
	
	local left = newSprite(PATH.."left.png")
	setAnchPos(left, 90, 540)
	this.layer:addChild(left)
	
	
	local right = newSprite(PATH.."left.png")
	right:setFlipX(true)
	setAnchPos(right, 360, 540)
	this.layer:addChild(right)
	
	local scroll = ScrollView:new(0,400,480,350,10,true,1)
	local role_data = DATA_Role:get()
	local end_layer = {}
	local hero_id_data = {}
	local num = 1
	for k,v in pairs(role_data) do
		hero_id_data[num] = v.id
		end_layer[num] = newLayer()
		end_layer[num]:setContentSize( CCSizeMake(480 , 400) )
		local drop = newSprite(PATH.."drop.png")
		setAnchPos(drop, 120, 20)
		end_layer[num]:addChild(drop)
		
		local btn = Btn:new(IMG_ICON.."hero/", {"L_"..v.look..".png"}, 100, 0, { 
			parent = scroll,
			callback = function()
				
			end
		})
		end_layer[num]:addChild(btn:getLayer())
		num = num + 1
	end
	
	for k,v in pairs(end_layer) do
		scroll:addChild(end_layer[k],end_layer[k])
	end
	
	this.layer:addChild(scroll:getLayer())
	
	
	local info_bg = newSprite(PATH.."info.png")
	setAnchPos(info_bg, 90, 240)
	this.layer:addChild(info_bg)
	--生成名字
	local disc = Btn:new(IMG_BTN, {"dice.png","dice_press.png"}, 310, 236, { 
					callback = function()
						HTTPS:send("Battle",{m = "battle", a = "battle", battle = "rolename"},{
							success_callback=function()
								this.account:setString(DATA_Role:get_name())
						end})
					end
				})
	this.layer:addChild(disc:getLayer())
		
	--[[创建输入框]]
	this.account = CCTextFieldTTF:textFieldWithPlaceHolder("" , "Thonburi" , 40);
	this.account:setString(DATA_Role:get_name())
	--[[设置颜色]]
	this.account:setColor( ccc3(255 , 255 , 0) )
	this.account:setColorSpaceHolder( ccc3(255 , 255 , 0) )

	setAnchPos(this.account, 100, 242, 0)
	this.layer:addChild( this.account )
	
	local code = newSprite(PATH.."code.png")
	setAnchPos(code, 60, 170)
	this.layer:addChild(code)
	
	local info_bg = newSprite(PATH.."info.png")
	setAnchPos(info_bg, 170, 165)
	this.layer:addChild(info_bg)
	
	--[[创建输入框]]
	this.account1 = CCTextFieldTTF:textFieldWithPlaceHolder("" , "Thonburi" , 40);
	this.account1:setString("暂未开放")
	--[[设置颜色]]
	this.account1:setColor( ccc3(255 , 255 , 0) )
	this.account1:setColorSpaceHolder( ccc3(255 , 255 , 0) )

	setAnchPos(this.account1, 175, 170, 0)
	this.layer:addChild( this.account1 )
	
	--开始游戏
	local start_game = Btn:new(IMG_BTN, {"start_game.png","start_game_press.png"}, 140, 45, { 
					callback = function()
						HTTPS:send("Battle",{m = "battle", a = "battle", battle = "role",name = this.account:getString(),hero_id = hero_id_data[scroll:getCurIndex()]},{
							success_callback=function()
								switchScene("home")
						end})
					end
				})
	this.layer:addChild(start_game:getLayer())
	
	
	
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
	function(type,x,y)
		if type == CCTOUCHBEGAN then
			if this:getRange():containsPoint(ccp(x,y)) then
				if x > 91 and x < 299 and y > 240 and y < 283 then
					if this.account then
						if onAttachWithIME then				
							this.account:detachWithIME()
							onAttachWithIME = false
						else	
							this.account:attachWithIME()
							onAttachWithIME = true
						end
					end
				elseif x > 171 and x < 379 and y > 166 and y < 208 then
					if this.account1 then
						if onAttachWithIME1 then				
							this.account1:detachWithIME()
							onAttachWithIME1 = false
						else	
							this.account1:attachWithIME()
							onAttachWithIME1 = true
						end
					end
				end
				
			end
		end
		return false
	end,false,-150,false)
	
	return this
end



function CreateRoleLayer:getLayer()
	return self.layer
end

function CreateRoleLayer:getRange()
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

return CreateRoleLayer
