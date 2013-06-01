local PATH = IMG_SCENE.."detail/"
--卡牌信息
local CardInfo= {
	layer,  --信息头
}

function CardInfo:new(x,y,params)
	local this={}
	setmetatable(this,self)
	self.__index = self
	this.params = params or {}
	this.layer = newLayer()
	
	local bg
	if this.params.type == "hero" then
		bg = newSprite(PATH..params.type.."_card_bg.png")
	else
		bg = newSprite(PATH.."other_card_bg.png")
	end
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	this.layer:setContentSize(bg:getContentSize())
	setAnchPos(this.layer, x, y)
	
	if this.params.cid then --若阵容位置有武将
		--头像
		local icon = newSprite(IMG_ICON..this.params.type.."/L_"..getBag(this.params.type,this.params.cid,"look")..".png")
		setAnchPos(icon, bg:getContentSize().width / 2, bg:getContentSize().height/ 2, 0.5, 0.5)
		this.layer:addChild(icon)
		
		--星级
		local star, y = nil, 300
		for i = 1, getBag(this.params.type, this.params.cid, "star") do
			star = newSprite(IMG_COMMON.."star.png")
			setAnchPos(star, 220, y)
			
			y = y - star:getContentSize().height
			this.layer:addChild(star)
		end
		
		local exp = Progress:new(IMG_COMMON, {"progress_bg.png", "progress_blue.png"}, 50, 55, {
			cur = 50,
			leftIcon = {"circle_box.png", 10, 12}
		})
		this.layer:addChild(exp:getLayer())
		
		local proBg = newSprite(PATH.."pro_bg_red.png")
		setAnchPos(proBg, 20, 20)
		this.layer:addChild(proBg)
		
		proBg = newSprite(PATH.."name_bg.png")
		setAnchPos(proBg, 20, 190)
		this.layer:addChild(proBg)
		
		local proText = newLabel("血"..getBag(this.params.type, this.params.cid, "hp"), 17, {x = 20, y = 22})
		this.layer:addChild(proText)
		
		proText = newLabel("攻"..getBag(this.params.type ,this.params.cid, "att"), 17, {x = 95, y = 22})
		this.layer:addChild(proText)
		
		proText = newLabel("防"..getBag(this.params.type, this.params.cid, "defe"), 17, {x = 170, y = 22})
		this.layer:addChild(proText)
		
		proText = newLabel(getBag(this.params.type, this.params.cid, "lev")..9, 20, {x = 40, y = 55, ax = 0.5})	
		this.layer:addChild(proText)
		
		local str = getBag(this.params.type, this.params.cid, "name")
		local height = string.len(str) / 3 * 30 
		proText = newLabel(str, 25, {x = 25, y = 190 + (proBg:getContentSize().height - height ) / 2, dimensions = CCSizeMake(30,height)})
		this.layer:addChild(proText)
	end
	
	this.layer:setScaleX(this.params.scaleX or 1)
	this.layer:setScaleY(this.params.scaleY or 1)
	
	local legal,lastX = nil, 0
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
		function(type, x, y)
			if this:getRange():containsPoint(ccp(x,y)) then
				if type == CCTOUCHBEGAN then
					legal = true
					lastX = x
				elseif type == CCTOUCHMOVED then
					if math.abs(x - lastX) > 20 then
						legal = false
					end
				else
					if legal and this.params.callback then
						this.params.callback() 
					end
				end	
			end	
			return true
		end,false,0,false)
	

	return this
end


function CardInfo:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	if parent then
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()
		while parent:getParent() do
			parent = parent:getParent()
			x = x + parent:getPositionX()
			y = y + parent:getPositionY()
		end
	end
	return CCRectMake(x,y,self.layer:getContentSize().width * (self.params.scaleX or 1),self.layer:getContentSize().height * (self.params.scaleY or 1))
end

function CardInfo:getLayer()
	return self.layer
end

function CardInfo:getPosition()
	return self.layer:getPosition()
end

function CardInfo:getWidth()
	return self.layer:getContentSize().width * (self.params.scaleX or 1)
end

function CardInfo:getHeight()
	return self.layer:getContentSize().height * (self.params.scaleY or 1)
end

return CardInfo