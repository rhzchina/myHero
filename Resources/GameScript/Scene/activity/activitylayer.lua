local PATH = IMG_SCENE.."activity/"

local ActivityLayer= {
	layer,	
	contentLayer,
}
function ActivityLayer:create(data)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	this.layer:addChild(bg)

	this:loginGift(data)	
    return this.layer
end

function ActivityLayer:loginGift(data, offset)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	self.contentLayer = newLayer()
	
	local bg = newSprite(PATH.."login_gift.png")
	setAnchPos(bg, 0, 680)
	self.contentLayer:addChild(bg)
	
	local scroll = ScrollView:new(0, 90, 480, 590)
	self.contentLayer:addChild(scroll:getLayer())
	
	for i = 1, 7 do
		local layer = newLayer()
		local bg = newSprite(PATH.."gift_bg.png")
		layer:setContentSize(bg:getContentSize())
		layer:addChild(bg)
		
		local btn_img, lock
		if data[i].checks == -1 then
			btn_img = {"no_reach.png"}
			lock = true
		elseif data[i].checks == 0 then
			btn_img = {"get.png", "get_press.png"}
		elseif data[i].checks == 1 then
			lock = true
			btn_img = {"get_finish.png"}
		elseif data[i].checks == 2 then
			btn_img = {"sign.png", "sign_press.png"}
		end
		
		local btn = Btn:new(IMG_BTN, btn_img, 290, 35, {
			parent = scroll,
			callback = function()
				if lock then
					MsgBox.create():flashShow("不可领取")
				else
					HTTPS:send("Activity", {m = "activity", a = "activity", activity = "check", day = data[i].did }, {success_callback = function(gift, change)
						MsgBox.create():flashShow("奖励已获得，请前往背包中查看")
						DATA_Bag:insert(gift)
						data[i] = change
						self:loginGift(data, scroll:getOffsetY())			
					end})							
				end
			end
		})
		layer:addChild(btn:getLayer())
--		
		local text = newLabel("第"..data[i].did.."天", 20,{x = 180, y = 60, color = ccc3(0x2c, 0, 0)})
		layer:addChild(text)
		
		local gift = Btn:new(IMG_COMMON,{"icon_bg".."1"..".png"}, 50, 20, {
			front = IMG_ICON.."equip".."/S_".."5101"..".png",
			other = {IMG_COMMON.."icon_border".."1"..".png",45,45},
			parent = scroll,
		})
		layer:addChild(gift:getLayer())
		
		scroll:addChild(layer)
	end	
	scroll:alignCenter()
	if offset then
		scroll:setOffset(offset)
	end
	
	
	self.layer:addChild(self.contentLayer)
end
return ActivityLayer