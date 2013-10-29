local ITEM = requires(SRC.."Scene/shop/shopitem")
local Detail = requires(SRC.."Scene/common/CardDetail")
local PATH = IMG_SCENE.."shop/"
requires(SRC.."Scene/common/pay")
local M = {
	layer,
	listLayer,
	tabGroup,
	infoLayre,
	payfoLayer
}

function M:create( ... )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	local bg = newSprite(IMG_COMMON.."main.jpg")
	setAnchPos(bg, 0, 80)
	this.layer:addChild(bg)
	
	this.tabGroup = RadioGroup:new()
	
	local tabs = {
		{"hot", 1},
		{"card", 2},
		{"prop", 3}
	}
	
	local x = 12
	for k, v in pairs(tabs) do
		local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 668, { 
			callback = function()
				this:createList(v[2])
			end
		},this.tabGroup)
		this.layer:addChild(btn:getLayer())		
		x = x + btn:getWidth() + 5 
	end
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,667)
	this.layer:addChild(separator)
	
	this.tabGroup:chooseByIndex(1,true)
	
	local gift = Btn:new(IMG_BTN, {"gift.png", "gift_pre.png"}, 385, 665, {
		callback = function()
			HTTPS:send("Pay", {a = "pay", m = "pay", pay = "get"}, {
				success_callback = function()
					local scene = display.getRunningScene()
					if self.payfoLayer then
						scene:removeChild(self.payfoLayer,true)
					end
					self.payfoLayer = PayInfoLayer:create():getLayer()
					
					scene:addChild(self.payfoLayer)
				end
			})
			
		end
	})
	this.layer:addChild(gift:getLayer())

	this.infoLayer = InfoLayer:create()
	this.layer:addChild(this.infoLayer:getLayer())
	return this.layer
end

function M:createList(kind)
	if self.listLayer then
		self.layer:removeChild(self.listLayer,true)
	end
	self.listLayer = CCLayer:create()
	
	local scroll = ScrollView:new(0,90,480,575,5)
	local temp
	for k, v in pairs(DATA_Shop:getByFilter(kind)) do
		local item 
		item = ITEM:new(kind, k,{
			parent = scroll,	
			optCallback = function()
				self:buySingle(kind,k)
			end
--			iconCallback = function()
--				self.layer:addChild(Detail:new(kind,v["cid"]):getLayer(),1)
--			end
		})
		scroll:addChild(item:getLayer(),item)
	end
	scroll:alignCenter()
	
	self.listLayer:addChild(scroll:getLayer())
	self.layer:addChild(self.listLayer)
end

function M:buySingle(type, id)
	local numLabel, valueLabel
	local totalNum, perValue = 1, DATA_Shop:get(id, "money") 
	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."tip_bg.png")
	
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	
	local mask 
	
	local okBtn = Btn:new(IMG_BTN, {"ok.png", "ok_press.png"}, 70, 320, {
		priority = -131,
		callback = function()
			HTTPS:send("Shop", {a = "shop", m = "shop", shop = "buy", type = type, pag_id = DATA_Shop:get(id,"id")}, {
				success_callback = function()
					self.layer:removeChild(mask, true)
					--self.infoLayer:createtop()
					Dialog.tip("购买 成功")
				end
			})
		end
	})
	layer:addChild(okBtn:getLayer())
	
	local cancelBtn = Btn:new(IMG_BTN, {"cancel.png", "cancel_press.png"}, 280, 320, {
		priority = -131,
		callback = function()
			self.layer:removeChild(mask, true)
		end
	})
	layer:addChild(cancelBtn:getLayer())
	
	local icon = Btn:new(IMG_COMMON,{"icon_bg1.png"}, 80, 420, {
		front = IMG_ICON.."prop/S_"..DATA_Shop:get(id, "look")..".png",
		other = {IMG_COMMON.."icon_border1.png",45,45},
		text = {DATA_Shop:get(id, "name"),20,ccc3(255,255,255), ccp(0, -60), }
	})
	layer:addChild(icon:getLayer())
	
	local desc = newLabel(DATA_Shop:get(id, "exps"), 25, {x = 180, y = 450, dimensions=CCSizeMake(200, 60)})
	layer:addChild(desc)
	
	mask = Mask:new({item = layer})
	self.layer:addChild(mask)
end

function M:buy(type, id)
	local numLabel, valueLabel
	local totalNum, perValue = 1, DATA_Shop:get(id, "money") 

	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."tip_bg.png")
	
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	
	local mask 
	
	local okBtn = Btn:new(IMG_BTN, {"ok.png", "ok_press.png"}, 70, 320, {
		priority = -131,
		callback = function()
			HTTPS:send("Shop", {a = "shop", m = "shop", shop = "buy", type = type, pag_id = DATA_Shop:get(id,"id")}, {
				success_callback = function()
					self.layer:removeChild(mask, true)
					--self.infoLayer:createtop()
					Dialog.tip("购买 成功")
				end
			})
		end
	})
	layer:addChild(okBtn:getLayer())
	
	local cancelBtn = Btn:new(IMG_BTN, {"cancel.png", "cancel_press.png"}, 280, 320, {
		priority = -131,
		callback = function()
			self.layer:removeChild(mask, true)
		end
	})
	layer:addChild(cancelBtn:getLayer())
	
	local num = newLabel("数量:", 40, {x = 60, y = 480})
	layer:addChild(num)
	
	num = newSprite(PATH.."num_bg.png")
	setAnchPos(num, 160, 480)
	layer:addChild(num)
	
	numLabel = newLabel(totalNum, 40, {x = 240, y = 480, ax = 0.5})
	layer:addChild(numLabel)
	
	
	local addBtn = Btn:new(IMG_BTN, {"add.png", "add_press.png"}, 320, 480, {
		priority = -131,
		callback = function()
			totalNum = totalNum + 1
			numLabel:setString(totalNum.."")
			valueLabel:setString(totalNum * perValue)	
		end
	})
	layer:addChild(addBtn:getLayer())
	
	
	local minusBtn = Btn:new(IMG_BTN,{"minus.png", "minus_press.png"}, 370, 480, {
		priority = -131,
		callback = function()
			if totalNum > 1 then
				totalNum = totalNum - 1
				numLabel:setString(totalNum.."")
				valueLabel:setString(totalNum * perValue)	
			end
		end
	})
	layer:addChild(minusBtn:getLayer())
	local price = newLabel("价格:", 40, {x = 60, y = 410})
	layer:addChild(price)
	
	price = newSprite(PATH.."value_bg.png")
	setAnchPos(price, 160, 410)
	layer:addChild(price)
	
	valueLabel = newLabel(perValue * totalNum, 40, {x = 280, y = 410, ax = 0.5})
	layer:addChild(valueLabel)
	
	
	mask = Mask:new({item = layer})
	self.layer:addChild(mask)
end

return M
