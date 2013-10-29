Guide = {layer}
requires(SRC.."Config/guideNpc")
function Guide:new( the_layer , params )
	local this = {}
	setmetatable(this, self)
	self.__index = self
	
	this.layer = newLayer()
	this.layer:ignoreAnchorPointForPosition(false)
	this.params = params or {}
	
	
	return this
end

function Guide:selects()
	if DATA_User:get("steps") == 1 then
		local getdata = GuideNpc[STEPS]
		if tonumber(getdata.look) > 19999 and tonumber(getdata.look) < 29999 then
			self:draw_npc()
		end
		
		if tonumber(getdata.look) > 9999 and tonumber(getdata.look) < 19999 then
			self:draw_execute()
		end
	end
end

function Guide:draw_npc()
	local scene = display.getRunningScene()
	self.layer:setScale(0)
	
	local dialog_bg = newSprite(IMG_SCENE.."guide/".."dialog_bg.png")
	setAnchPos(dialog_bg, 240, 425, 0.5, 0.5)
	self.layer:addChild(dialog_bg)
	print("~~~~~~~~~~~~~~~~~~~~~~~~")
	print("exp")
	print("~~~~~~~~~~~~~~~~~~~~~~~~")
	scene:addChild(self.layer)
end



function Guide:draw_execute()
	print("~~~~~~~~~~~~~~~~~~~~~~~~")
	print("exp")
	print("~~~~~~~~~~~~~~~~~~~~~~~~")
end

function Guide.show(layers, params)
	local temp = Guide:new(layers, params)
	temp:draw_npc()	
end
return Guide