local PATH = IMG_SCENE.."athletics/"

local AthleticsLayer= {
	layer,	
	contentLayer
}
function AthleticsLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.jpg")
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."role_bg.png")
	setAnchPos(bg, 0, 545)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."result_bg.png")
	setAnchPos(bg, 0, 425)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."result_bg.png")
	setAnchPos(bg, 0, 305)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."win.png")
	setAnchPos(bg, 20, 460)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."lost.png")
	setAnchPos(bg, 20, 340)
	this.layer:addChild(bg)
	
	local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, 110, {
		callback = function()
		end
	})
	this.layer:addChild(shop:getLayer())
	
	local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, 110, {
		callback = function()
		end
	})
	this.layer:addChild(rank:getLayer())
	
	local refresh = Btn:new(IMG_BTN, {"refresh.png", "refresh_press.png"}, 400, 580, {
		callback = function()
			
		end
	})
	this.layer:addChild(refresh:getLayer())
	
	
    return this.layer
end

function AthleticsLayer:createContent(data)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer,true)
	end	
	
	self.layer:addChild(self.contentLayer())	
end

return AthleticsLayer