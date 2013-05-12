local PATH = IMG_SCENE.."embattle/"
local ItemList = require(SRC.."Scene/common/ItemList")

local lineuplayer = {layer}

function lineuplayer:new(x,y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self

	local size = DATA_Battle:size()

	local num --阵容的个数
	if size < 3 then
		num = 3
	else
		num  = size + 1
	end

	this.layer = CCLayer:create()

	local bg = newSprite(IMG_COMMON.."common_bg.png")
	setAnchPos(bg,10,85)
	this.layer:addChild(bg)

	local title = newSprite(PATH.."title.png")
	setAnchPos(title,40,770)
	this.layer:addChild(title)

	local font = newSprite(PATH.."font.png")
	setAnchPos(font,170,770)
	this.layer:addChild(font)


	local group = RadioGroup:new()

	local sv = ScrollView:new(56,680,300,200,0,true)


	---[[英雄信息滑块]]
	local infolayer = require"GameScript/Scene/lineup/lineupInfo"
	local ksv = ScrollView:new(15,100,450,550,0,true,1)
	local infos
	local card_x = 56
	local card_y = 680
	for i = 1,DATA_LineUp:size() do
		infos = infolayer:new(i,ksv,DATA_LineUp:get(i),0,100,
			{
				parent = ksv,
				equipCallback = function()
					local list
					list = ItemList:new({
						okCallback = function()
							print("确定了")
						end
					})
					this.layer:addChild(list:getLayer())
				end,
				callback = function(card_this,card_x,card_y)
					HTTPS:send("Battle",{
						m = "battle",
						a = "battle",
						battle = "up",
						index = 1,id = 2317,cid =77
					})
				end
			})

		ksv:addChild(infos:getLayer(),infos)
		card_x = card_x + 480
	end
	this.layer:addChild(ksv:getLayer())


	--阵容
	local temps = Btn:new(PATH,{"embattle.png","embattle_press.png"},390,675,
	    		{
	    			highLight = true,
	    			scale = true,
	    			callback= function()
							HTTPS:send("Battle" , 
							 {
								m="battle",
								a="battle",
								battle = "select_up"
							} ,
							{
								success_callback = function()
									switchScene("battlere")
								end 
							})
		    		end
	    		 })
	this.layer:addChild(temps:getLayer())



return this
end

function lineuplayer:getLayer()
	return self.layer
end

return lineuplayer
