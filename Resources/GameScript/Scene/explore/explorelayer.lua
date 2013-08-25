local PATH = IMG_SCENE.."explore/"
local CommEmbattle = require(SRC.."Scene/common/CommEmbattle")

local ExploreLayer= {
	data
}
function ExploreLayer:create(data)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.data = data
	local layer = newLayer()
	local bg = newSprite(PATH.."explore_bg.png")
	layer:addChild(bg)
	
	local pos = {
		{50, 450},	
		{100, 200},	
		{220, 360},	
		{280, 620},	
		{100, 650},	
	}
	
	for i = 1, #pos do
		local bg = {(i * 100 + 1)..".png", (i * 100 + 2)..".png" }
		local btn = Btn:new(PATH, bg, pos[i][1], pos[i][2], {
		})
		layer:addChild(btn:getLayer())	
	end
	
	local oneKey = Btn:new(PATH, {"onekey.png", "onekey_press.png"}, 120, 100, {
		callback = function()
			HTTPS:send("Explore", {m = "explore", a = "explore", explore = "click"}, {
				success_callback = function()
				end
			})
		end
	})
	layer:addChild(oneKey:getLayer())
	
	local set = Btn:new(PATH, {"set.png", "set_press.png"}, 280, 100, {
	})
	layer:addChild(set:getLayer())
	
	
    return layer
end
return ExploreLayer