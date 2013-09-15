local PATH = IMG_SCENE.."rand/"


local InfoLayer = {
	layer
}

function InfoLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	dump(data)
	local params = data or {}
	this.layer = newLayer()
	setAnchPos(this.layer, 0, 0)
	
	local bg = newSprite(PATH.."block.png")
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	--绘制排名次
	if data.page == 0 then
		if data.num == 1 then
			local num_img = newSprite(PATH.."1st.png")
			setAnchPos(num_img, 25, (bg:getContentSize().height - num_img:getContentSize().height )/2)
			this.layer:addChild(num_img)
		elseif data.num == 2 then
			local num_img = newSprite(PATH.."2nd.png")
			setAnchPos(num_img, 25, (bg:getContentSize().height - num_img:getContentSize().height )/2)
			this.layer:addChild(num_img)
		elseif data.num == 3 then
			local num_img = newSprite(PATH.."3rd.png")
			setAnchPos(num_img, 25, (bg:getContentSize().height - num_img:getContentSize().height )/2)
			this.layer:addChild(num_img)
		else
		
		end
	else
	
	end
	
	local icon_bg = newSprite("images/common/icon_border3.png")
	setAnchPos(icon_bg, 120, 15)
	this.layer:addChild(icon_bg)
	
	local icon_bg1 = newSprite("images/common/icon_bg3.png")
	setAnchPos(icon_bg1, 120, 15)
	this.layer:addChild(icon_bg1)
	
	local icon = newSprite("images/icon/hero/s_"..data.icon_id..".png")
	setAnchPos(icon, 120, 15)
	this.layer:addChild(icon)
	
	local title_font_name = display.strokeLabel(data.name.."   Lv"..data.lv,240,75,22,ccc3(0,0,0))
	this.layer:addChild(title_font_name)
	
	local title_font_prestige = display.strokeLabel("声望:"..data.prestige,240,30,22,ccc3(0,0,0))
	this.layer:addChild(title_font_prestige)
	
	return this
end



function InfoLayer:getLayer()
	return self.layer
end


return InfoLayer
