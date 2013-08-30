local PATH = IMG_SCENE.."explore/"
local CommEmbattle = require(SRC.."Scene/common/CommEmbattle")

local ExploreLayer= {
	layer,
	contentLayer,
	data
}
function ExploreLayer:create(data)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.data = data
	this.layer = newLayer()
	
	local bg = newSprite(PATH.."explore_bg.png")
	this.layer:addChild(bg)
	
	this:createContent()

	
	local oneKey = Btn:new(PATH, {"onekey.png", "onekey_press.png"}, 120, 100, {
		callback = function()
			HTTPS:send("Explore", {m = "explore", a = "explore", explore = "click"}, {
				success_callback = function(data)
					this.data = data.change	 	
					for k, v in pairs(data.gift) do
						DATA_Bag:setByKey(v.type, k, v)
					end
					this:createContent()
					MsgBox.create():flashShow("探索成功，奖励物品已放入背包")
				end
			})
		end
	})
	this.layer:addChild(oneKey:getLayer())
	
	local set = Btn:new(PATH, {"set.png", "set_press.png"}, 280, 100, {
		callback = function()
			switchScene("embattle")
		end
	})
	this.layer:addChild(set:getLayer())
	
	
    return this
end

function  ExploreLayer:getLayer()
	return self.layer
end

function ExploreLayer:createContent()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	
	self.contentLayer = newLayer()
	
	local pos = {
		{100, 200},	
		{240, 360},	
		{50, 450},	
		{280, 620},	
		{100, 650},	
	}
	
	for i = 1, #pos do
		local bg 
		if self.data[i].normal == 1 then
			bg =  {(i * 100 + 1)..".png", (i * 100 + 2)..".png" }
		else
			bg =  {(i * 100 + 3)..".png"}
		end
		local btn = Btn:new(PATH, bg, pos[i][1], pos[i][2], {
			other = {IMG_SCENE.."navigation/silver_bg.png", 70, -10},
			text = {self.data[i].Money, 18, ccc3(255, 255, 255), ccp(50, -22), 1, 17},
			callback = function()
				if self.data[i].normal == 1 then
					HTTPS:send("Explore", {m = "explore", a = "explore", explore = "execute", position = i}, {
						success_callback = function(data)
							if data.msg then
								MsgBox.create():flashShow(data.msg)
								return 
							end
							
							for k, v in pairs(data.change) do
								self.data[v.Lev] = v
							end
							
							for k, v in pairs(data.gift) do
								DATA_Bag:setByKey(v.type, k, v)
								MsgBox.create():flashShow("获得物品"..v.name)
							end
							self:createContent()
						end
						
					})
				end
			end
		})
		self.contentLayer:addChild(btn:getLayer())	
	end
	self.layer:addChild(self.contentLayer)
end


return ExploreLayer
