local InfoLayer = {
	layer,
	Parent
}
local PATH = IMG_SCENE.."transcrip/"
function InfoLayer:new(Parent,data,_index)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.Parent = Parent
	
	local params = data or {}
	this.layer = newLayer()
	setAnchPos(this.layer, 3, 0)
	local bg = newSprite(PATH.."bolck_bg.png")
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	this.Parent.old_layer = params.new_layer

	local icon_bg = newSprite(PATH..params.resource_id..".png")
	setAnchPos(icon_bg, 23, 18)
	this.layer:addChild(icon_bg)
	
	local title_name = display.strokeLabel(params.name,220,240,28,ccc3(255,255,255))
	this.layer:addChild(title_name)
	
	local title_max = display.strokeLabel("最好成绩："..params.max_layer.."层",220,210,18,ccc3(255,255,255))
	this.layer:addChild(title_max)
	
	local title_old = display.strokeLabel("昨天成绩："..params.old_layer.."层",220,180,18,ccc3(255,255,255))
	this.layer:addChild(title_old)
	
	local title_new = display.strokeLabel("当前成绩："..params.new_layer.."层",220,150,18,ccc3(255,255,255))
	this.layer:addChild(title_new)
	
	local title_num = display.strokeLabel("今日免费重置次数："..params.num.."次",220,120,18,ccc3(255,255,255))
	this.layer:addChild(title_num)
	
	local title_desc = display.strokeLabel("掉落:\n"..params.desc,220,70,18,ccc3(255,255,255),nil,nil,{align = 0})
	this.layer:addChild(title_desc)
	
	local reset = Btn:new(IMG_BTN, {"reset.png", "reset_press.png"}, 380, 225,{callback = function() 
			HTTPS:send("Duplicate" ,  
					{m="duplicate",a="duplicate",duplicate = "reset",type_id = data.type_id} ,
					{success_callback = function(data)
						
						this.Parent:create_big()
					end })
	end})
	this.layer:addChild(reset:getLayer())
	
	local rush = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 260, 10,{text = {"闯", 30, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
		--[[if tonumber(params.num) <= 0 then
			Dialog.tip("免费次数为0，请使用"..params.money.."代币重置!")
		else]]
		
			HTTPS:send("Duplicate" ,  
					{m="duplicate",a="duplicate",duplicate = "emigrated",type_id = data.type_id} ,
					{success_callback = function(temp_data)
						this.Parent.all_max_layer = tonumber(params.max_layer) + 1
						this.Parent:create_small(temp_data)
					end })
		--end
	end})
	this.layer:addChild(rush:getLayer())
	return this
end


function InfoLayer:getLayer()
	return self.layer
end


return InfoLayer
