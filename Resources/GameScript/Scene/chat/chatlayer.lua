local PATH = IMG_SCENE.."chat/"

local chatLayer = {
	layer,
	msgLayer,
	group
}

function chatLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	this.layer = newLayer()

	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	this.group = RadioGroup:new()
	
	local tabs = {
		"announcement", --"活动"
		"system",--系统
		"tall"  --喊话
	}
	
	for i = 1, #tabs do
		local tab = Btn:new(IMG_COMMON.."tabs/", {"tab_"..tabs[i]..".png", "tab_"..tabs[i].."_select.png"},3 + (i - 1) * 90, 670, {
			id = tabs[i],
			disableWhenChoose = true,
			callback = function()
				this:createMsgLayer(tabs[i])
			end
		},this.group)
		this.layer:addChild(tab:getLayer())
	end
	this.group:chooseByIndex(3, true)
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator, 0, 670)
	this.layer:addChild(separator)
	
return this
end

function chatLayer:getLayer()
	return self.layer
end



function chatLayer:refresh()
	if self.group:getId() == "tall" then
		self:createMsgLayer("tall")
	end
end

function chatLayer:createMsgLayer(kind)
	if self.msgLayer then
		self.layer:removeChild(self.msgLayer, true)
	end
	self.msgLayer = newLayer()
	
	local msg = DATA_Chat:get(kind)
		print("消息条数",#msg)
	local preStr = {
		["comprehensive"] = {"【综合】", ccc3(47,118,48)},
		["fight"] = {"【战斗】",ccc3(131,100,35)},
		["announcement"] = {"【活动】",ccc3(18,201,207)},
		["system"] = {"【系统】",ccc3(191,207,18)},
		["tall"] = {"",ccc3(250, 207, 0)}	
	}
	
	local scroll 
	if kind == "tall" then
		scroll = ScrollView:new(0, 165, 480, 500, 10)
	else
		scroll = ScrollView:new(0, 100, 480, 565, 10)
	end
	for i = 1, #msg do
		local text, line = newLabel(preStr[kind][1]..msg[i].content, 24, {
			noFont = true, 
			width = 480,
			align = 0,
			 color = preStr[kind][2]
		})	
		setAnchPos(text)
		
		local layer = newLayer()
		layer:ignoreAnchorPointForPosition(false)
		setAnchPos(layer)
		layer:setContentSize(CCSizeMake(480, text:getContentSize().height))		
		layer:addChild(text)
		
		scroll:addChild(layer)
	end
	scroll:alignCenter()
	if #msg > 0 then
		scroll:setIndex(#msg, true)
	end
	self.msgLayer:addChild(scroll:getLayer())
	
	
	if kind == "tall" then
		local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
		setAnchPos(separator, 0, 160)
		self.msgLayer:addChild(separator)
		
		local inputBg = Btn:new(PATH, {"input_bg.png"}, 5, 97, {
			text = {"点击输入消息", 26, ccc3(250, 207, 0), ccp(-80, 0)},
			
			callback = function()		
				if device.platform == "android" then
					specialCall(0)
				else
					SOCKET:call("tall", {
						content = "这是一条测试消息，看到不"
					})
				end
			end
		})
		self.msgLayer:addChild(inputBg:getLayer())
		
		local send = Btn:new(IMG_BTN, {"send.png", "send_press.png"}, 342, 95, {
			callback = function()
				if device.platform == "android" then
					specialCall(0)
				else
					SOCKET:call("tall", {
						content = "这是一条测试消息，看到不"
					})
				end
			end
		})
		self.msgLayer:addChild(send:getLayer())
	end
	
	self.layer:addChild(self.msgLayer)
end

return chatLayer
