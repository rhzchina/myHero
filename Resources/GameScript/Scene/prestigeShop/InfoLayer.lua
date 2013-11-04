local PATH = IMG_SCENE.."shop/"


local InfoLayer = {
	layer
}

function InfoLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	local params = data or {}
	this.layer = newLayer()
	setAnchPos(this.layer, 0, 300)
	
	local bg = newSprite(PATH.."shop_item_bg.png")
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	local icon = Btn:new(IMG_COMMON,{"icon_bg1.png"}, 20, 55, {
		front = IMG_ICON.."prop/S_"..data.look..".png",
		other = {IMG_COMMON.."icon_border1.png",45,45},
		scale = true,
		priority = data.payid
	})
	this.layer:addChild(icon:getLayer())
	
	local text = newLabel("名称:"..data.name,20,{x = 130, y = 115, color = ccc3(255,255,255)})
	this.layer:addChild(text)
	
	text = newLabel("价格:"..data.price,20,{x = 130, y = 75, color = ccc3(255,255,255)})
	this.layer:addChild(text)
	
	text = Label:new(data.desc,20, 240, 5)
	setAnchPos(text, 130,10)
	this.layer:addChild(text)
	
	local buy = Btn:new(IMG_BTN, {"buy.png", "buy_pre.png"}, 370, 5, {
			priority = data.payid,
			callback = function() 
				HTTPS:send("Exploreshop", {exlploreshop="pay", a="exlploreshop", m="exlploreshop",type=data.type,payid=data.payid}, {success_callback = function(data)
					Dialog.tip("购买 成功")
				end})
			end
		})
	this.layer:addChild(buy:getLayer())
	return this
end



function InfoLayer:getLayer()
	return self.layer
end


return InfoLayer
