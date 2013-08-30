local PATH = IMG_SCENE.."athletics/"

local AthleticsLayer= {
	layer,	
	contentLayer,
	data
}
function AthleticsLayer:create(data)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.data = data or {}
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
	
	bg = newSprite(PATH.."lost.png")
	setAnchPos(bg, 20, 460)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."win.png")
	setAnchPos(bg, 20, 340)
	this.layer:addChild(bg)
	
	local revenge = Btn:new(IMG_BTN, {"revenge.png", "revenge_press.png"}, 380, 480, {
		
	})
	this.layer:addChild(revenge:getLayer())
	
	local lost_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, 432, {
	
	})
	this.layer:addChild(lost_view:getLayer())
	
	local win_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, 340, {
	
	})
	this.layer:addChild(win_view:getLayer())
	
	local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, 90, {
		callback = function()
		end
	})
	this.layer:addChild(shop:getLayer())
	
	local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, 90, {
		callback = function()
		end
	})
	this.layer:addChild(rank:getLayer())
	
	local refresh = Btn:new(IMG_BTN, {"refresh.png", "refresh_press.png"}, 400, 580, {
		callback = function()
			
		end
	})
	this.layer:addChild(refresh:getLayer())
	
	this.layer:addChild(newLabel("我的声望:", 24, {x = 50, y = 260, color = ccc3(0, 0, 0)}))
	this.layer:addChild(newLabel("我的排名:", 24, {x = 250, y = 260, color = ccc3(0, 0, 0)}))
	this.layer:addChild(newLabel("冷却时间:", 24, {x = 50, y = 210, color = ccc3(0, 0, 0)}))
	this.layer:addChild(newLabel("今日剩余挑战次数:", 24, {x = 50, y = 160, color = ccc3(0, 0, 0)}))
	
	this:createContent()
	
	
    return this.layer
end

function AthleticsLayer:createContent()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer,true)
	end	
	
	self.contentLayer = newLayer()
	
	local scroll = ScrollView:new(10, 555, 380, 150, 20, true)
	self.contentLayer:addChild(scroll:getLayer())
	
	for k, v in pairs(self.data["data"]) do
		local other = Btn:new(PATH, {"bg_green.png", "bg_blue.png"}, 0, 0, {
			other = {{IMG_COMMON.."icon_bg1.png", 53, 90},{IMG_ICON.."hero/S_2301.png", 53, 90}, {IMG_COMMON.."icon_border1.png", 53, 90}},
			text = {{"Lv "..v.lv, 20, ccc3(255,255,255), ccp(0, -45)}, {v.Name, 20, ccc3(255,255,255), ccp(0, -67)}},
			callback = function()
			end
		})
		scroll:addChild(other:getLayer())
	end
	
	
	self.layer:addChild(self.contentLayer)	
end

return AthleticsLayer