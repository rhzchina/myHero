local roostLayer = {layer}
function roostLayer:new(ksv,data,p_x,p_y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self

	this.layer = CCLayer:create()
	setAnchPos(this.layer,p_x,p_y+10)
	local bg = newSprite("image/scene/task/infobox.png")
	setAnchPos(bg,5,0)
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	local header_bg = newSprite("image/UserAvatar/UserAvatarbg.png")
	setAnchPos(header_bg,22,70)
	this.layer:addChild(header_bg)

	local header_box = newSprite("image/UserAvatar/UserAvatarbox.png")
	local header = newSprite("image/myhero/small/1001.png")

	setAnchPos(header_box,22,70)
	setAnchPos(header,22,70)

	this.layer:addChild(header)
	this.layer:addChild(header_box)

	dump(data)

	local text_name = newLabel(data["name"].."     执行 "..data["in_num"].."/"..data["num"], 22)
	setAnchPos(text_name,125,135)
	this.layer:addChild(text_name)

	----金叶
	local leaf = newSprite(IMG_COMMON.."gold_leaf.png")
	setAnchPos(leaf,140,105)
	this.layer:addChild(leaf)

	local text_leaf = newLabel(data["money"],  25)
	setAnchPos(text_leaf,180,105)
	this.layer:addChild(text_leaf)

	----硬币
	local yinbi = newSprite(IMG_COMMON.."silver.png")
	setAnchPos(yinbi,240,105)
	this.layer:addChild(yinbi)

	local text_yinbi= newLabel(data["money"], 25)
	setAnchPos(text_yinbi,280,105)
	this.layer:addChild(text_yinbi)

	----体力
	local evn = newSprite("image/scene/home/env.png")
	setAnchPos(evn,140,75)
	this.layer:addChild(evn)

	local text_evn = newLabel(data["csenergy"], 25)
	setAnchPos(text_evn,180,75)
	this.layer:addChild(text_evn)

	----气
	local img_qi = newSprite("image/scene/home/qi.png")
	setAnchPos(img_qi,240,70)
	this.layer:addChild(img_qi)

	local text_qi = newLabel("100", 25)
	setAnchPos(text_qi,280,75)
	this.layer:addChild(text_qi)

	---描述
	local text_desc = newLabel(data["descs"], 25)
	setAnchPos(text_desc,30,45)
	this.layer:addChild(text_desc)

	--技能
	--[[local img_qi = newSprite("image/scene/home/qi.png")
	setAnchPos(img_qi,240,225)
	this.layer:addChild(img_qi)
]]

	--[[战斗]]
	local btns = require"GameScript/Common/LuaBtn"
	--local group = RadioGroup:new()
	local fight
	    fight = btns:new("image/buttonUI/task/firt/",{"def.png","pre.png"},377,10,
	    		{
					--parent = ksv,
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	    				 end
	    		 })
		this.layer:addChild(fight:getLayer())

return this
end


function roostLayer:getRange()
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

function roostLayer:getLayer()
	return self.layer
end

return roostLayer
