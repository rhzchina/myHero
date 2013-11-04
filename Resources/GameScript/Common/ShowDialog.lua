ShowDialog= {
	layer,     --功能层
	topLayer,
}
function ShowDialog:create(msg,param)
	local this={}
	setmetatable(this,self)
	self.__index = self
	if type(param.success_callback) ~= "function" then 
		param.success_callback = function()
		end 
	end
	--首页的元素拆分开
	this.layer = newLayer()
	local mask 
	
	local layer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."tip_bg.png")
	setAnchPos(bg, (480 - 407)/2, (854 - 259)/2)
	layer:addChild(bg)
	
	local desc = newLabel("提示", 40, {x = 120, y = (854 - 259)/2 + 170, dimensions=CCSizeMake(200, 60),color = ccc3(255, 255, 255)})
	layer:addChild(desc)
	
	local content = newLabel(msg, 20, {
		noFont = true, 
		 width = 355, 
		 color = ccc3(255, 255, 255)
		})
	setAnchPos(content,66,(854 - 259)/2 + 170 - content:getContentSize().height )
	
	layer:addChild(content)
		
	local ok_btn = Btn:new(IMG_BTN,{"ok.png", "ok_press.png"}, 80, (854 - 259)/2 + 20, {
		priority = -131,
		callback = function()
			this.layer:removeChild(mask, true)
			param.success_callback()
		end
	})
	layer:addChild(ok_btn:getLayer())
	
	local close_btn = Btn:new(IMG_BTN,{"cancel.png", "cancel_press.png"}, 260, (854 - 259)/2 + 20, {
		priority = -131,
		callback = function()
			this.layer:removeChild(mask, true)
		end
	})
	layer:addChild(close_btn:getLayer())
	mask = Mask:new({item = layer})
	this.layer:addChild(mask)
	return this
end

function ShowDialog:getLayer()
	return self.layer
end