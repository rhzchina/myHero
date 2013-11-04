local PATH = IMG_SCENE.."mission/"
local roostLayer = {
	layer,
	fightBtn
}
function roostLayer:new(ksv,data,p_x,p_y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	this.layer = CCLayer:create()
	setAnchPos(this.layer,p_x,p_y+10)
	local bg = newSprite(PATH.."infobox.png")
	setAnchPos(bg,5,0)
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	
	--dump(data)
	local text_name = newLabel(SHurdleConfig[data.id].name.."     执行 "..data["in_num"].."/"..data["num"], 22)
	setAnchPos(text_name,125,135)
	this.layer:addChild(text_name)

	----金叶
	local leaf = newSprite(IMG_COMMON.."gold_leaf.png")
	setAnchPos(leaf,140,105)
	this.layer:addChild(leaf)

	local text_leaf = newLabel("0",  25)
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
	local evn = newSprite(IMG_COMMON.."power.png")
	setAnchPos(evn,140,75)
	this.layer:addChild(evn)

	local text_evn = newLabel(data["csenergy"], 25)
	setAnchPos(text_evn,180,75)
	this.layer:addChild(text_evn)

	----气
	local img_qi = newSprite(IMG_COMMON.."gas.png")
	setAnchPos(img_qi,240,70)
	this.layer:addChild(img_qi)

	local text_qi = newLabel("0", 25)
	setAnchPos(text_qi,280,75)
	this.layer:addChild(text_qi)

	---描述
	--local text_desc = newLabel(data["descs"], 25, {x = 5, y = 15, dimensions = CCSizeMake(375,50)})
	--this.layer:addChild(text_desc)
	
	local des = Label:new(SHurdleConfig[data.id].desc, 22, 320,5)
	setAnchPos(des, 18, 10)
	this.layer:addChild(des)
	
	if tonumber(data.marked) == 0 then
		local img_qi = newSprite(IMG_COMMON.."icon_empty.png")
		setAnchPos(img_qi,20,70)
		this.layer:addChild(img_qi)
		
	   this.fightBtn = Btn:new(PATH,{"fight_grey.png"},377,10,
	    		{
	    			scale = true,
	    			callback=
	    				function()
	    					Dialog.tip("您好，该关卡尚未开启！")
	    				 end
	    		 })
		this.layer:addChild(this.fightBtn:getLayer())
	else
		
		if tonumber(SHurdleConfig[data.id].hero_icon) ~= 0 then
			local img_qi = newSprite(IMG_COMMON.."icon_bg1.png")
			setAnchPos(img_qi,20,70)
			this.layer:addChild(img_qi)
			
			local img_qi = newSprite(IMG_COMMON.."icon_border1.png")
			setAnchPos(img_qi,20,70)
			this.layer:addChild(img_qi)
			local img_qi = newSprite(IMG_ICON .. "hero/S_"..MonConfig[SHurdleConfig[data.id].hero_icon..""].look..".png")
			setAnchPos(img_qi,20,70)
			this.layer:addChild(img_qi)
		end
		
	
		
		if tonumber(SHurdleConfig[data.id].goods_icon) ~= 0 then
			local img_qi = newSprite(IMG_COMMON.."icon_bg1.png")
			setAnchPos(img_qi,370,70)
			this.layer:addChild(img_qi)
			if SHurdleConfig[data.id].goods_icon > 5999 and SHurdleConfig[data.id].goods_icon < 6999 then
				local goods = newSprite(IMG_ICON .. "equip/S_"..ArmConfig[SHurdleConfig[data.id].goods_icon..""].look..".png")
				setAnchPos(goods,375,70)
				this.layer:addChild(goods)
			elseif SHurdleConfig[data.id].goods_icon > 4999 and SHurdleConfig[data.id].goods_icon < 5999 then
				local goods = newSprite(IMG_ICON .. "equip/S_"..ArmourConfig[SHurdleConfig[data.id].goods_icon..""].look..".png")
				setAnchPos(goods,375,70)
				this.layer:addChild(goods)
			elseif SHurdleConfig[data.id].goods_icon > 6999 and SHurdleConfig[data.id].goods_icon < 7999 then
				local goods = newSprite(IMG_ICON .. "equip/S_"..OrnamentConfig[SHurdleConfig[data.id].goods_icon..""].look..".png")
				setAnchPos(goods,375,70)
				this.layer:addChild(goods)
			end
					
			local img_qi = newSprite(IMG_COMMON.."icon_border1.png")
			setAnchPos(img_qi,370,70)
			this.layer:addChild(img_qi)
		
		end		
		
	    this.fightBtn = Btn:new(IMG_BTN,{"fight_normal.png","fight_press.png"},377,10,
	    		{
					--parent = ksv,
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					HTTPS:send("Fighting",
	    						{a = "fighting",
	    						 m = "fighting", 
	    						 fighting = "start", 
	    						 type = "task",
	    						 bHurdle = math.floor(data["id"] / 100), 
	    						 sHurdle = data["id"]},{success_callback= function()
	    						 	switchScene("fighting","task")
	    						 end
	    						 })
	    				 end
	    		 })
		this.layer:addChild(this.fightBtn:getLayer())
	end
	
	

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

function roostLayer:getBtn()
	return self.fightBtn
end

return roostLayer
