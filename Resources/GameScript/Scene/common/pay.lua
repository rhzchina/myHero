local PATH = IMG_SCENE.."pay/"
PayInfoLayer= {
	layer,
	modulelayer
}
function PayInfoLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self
	this.layer = newLayer()
	local mask 
	local bg = newSprite(PATH.."pay_bg.png")
	local layer = newLayer()
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	local close_btn = Btn:new(PATH,{"pay_close.png"}, 400, 715, {
		priority = -131,
		scale = true,
		callback = function()
			this.layer:removeChild(mask, true)
			
		end
	})
	layer:addChild(close_btn:getLayer())
	
	if DATA_Pay:get_first() == 0 then
		local first = newSprite(PATH.."first.png")
		setAnchPos(first, 240, 625, 0.5, 0.5)
		layer:addChild(first)
	end
	
	local scroll = ScrollView:new(0,92,480,415,10)
	local temp
	for k, v in pairs(DATA_Pay:get()) do
		local item 
		item = this:module_small(v,scroll)
		scroll:addChild(item,item)
	end
	scroll:alignCenter()
	layer:addChild(scroll:getLayer())
	
	mask = Mask:new({item = layer})
	this.layer:addChild(mask)
	return this
end

function PayInfoLayer:module_small(v,scroll)
	local layer = newLayer()
	local bg = newSprite(PATH.."buttom.png")
	layer:addChild(bg)
	layer:setContentSize(bg:getContentSize())
	local btn = Btn:new(PATH,{"buttom.png"}, 0, 0, {
		priority = -131,
		parent = scroll,
		callback = function()
			HTTPS:send("Pay", {a = "pay", m = "pay", pay = "buy",id = v.id}, {
				success_callback = function()
					
				end
			})
		end
	})
	layer:addChild(btn:getLayer())
	
	local gold = newSprite(PATH.."Gold.png")
	setAnchPos(gold, 20, 55)
	layer:addChild(gold)
	
	local price = newLabel(v.name, 32, {x = 90, y = 60,color = ccc3(255,215,0)})
	layer:addChild(price)
	
	local money = newLabel("￥"..v.price, 28, {x = 330, y = 60,color = ccc3(255,215,0)})
	layer:addChild(money)
	
	local desc = newLabel(v.descs, 24, {x = 20, y = 15,color = ccc3(255,255,255)})
	layer:addChild(desc)
	
	return layer
end

function PayInfoLayer:getLayer()
	return self.layer
end