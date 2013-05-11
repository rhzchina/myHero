local PATH = IMG_SCENE.."embattle/"
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
	local card

--	for i = 1,num do
--		if i <= size then
--			if _G.next (DATA_Battle:get(i) )  ~= nil then
--				card = CILayer:create(1,DATA_Battle:get(1)["cid"],56,680,{parent = sv,
--																callback = function(card_this,card_x,card_y)
--																					print(i)
--																end})
--				sv:addChild(card:getLayer(),card)
--			elseif _G.next (DATA_Battle:get(i) )  == nil  then
--				card = CILayer:create(2,DATA_Battle:get(1)["cid"],56,680,{parent = sv,
--																callback = function(card_this,card_x,card_y)
--																					print(i)
--																end})
--				sv:addChild(card:getLayer(),card)
--			end
--		else
--				card = CILayer:create(3,nil,56,680,{parent = sv,
--																callback = function(card_this,card_x,card_y)
--																					print(i)
--																end})
--				sv:addChild(card:getLayer(),card)
--		end
--
--	end
--	this.layer:addChild(sv:getLayer())


	local lef = newSprite("image/UserAvatar/left_1.png")
	setAnchPos(lef,20,680)
	this.layer:addChild(lef)

	local rig = newSprite("image/UserAvatar/right_1.png")
	setAnchPos(rig,350,680)
	this.layer:addChild(rig)

	local info = newSprite(PATH.."box.png")
	setAnchPos(info,15,130)
	this.layer:addChild(info)


	---[[英雄信息滑块]]
	local infolayer = require"GameScript/Scene/lineup/lineupInfo"
	local ksv = ScrollView:new(15,100,450,550,0,true,1)
	local infos
	local card_x = 56
	local card_y = 680
	for i = 1,DATA_LineUp:size() do
		infos = infolayer:new(i,ksv,DATA_LineUp:get(i),0,100,{parent = ksv,
																callback = function(card_this,card_x,card_y)
--																					if card_this:get_click() == true then
--																						LineUp_Index = i
--																						print("~~~~~~~~~~~~~~~~~~~~~~~fadfadfsadf~~~~~~~~~~~~~~~")
--																						HTTPS:send("AddHero" ,  {m="Heros",a="Heros",heros = "Info",
--																						card_id = card_this:get_gid()} ,{success_callback = function()
--																									switchScene("lineupCardInfo")
--																								end
--																						})
--																					elseif card_this:get_select() == true then
--																						LineUp_Index = i
--																						HTTPS:send("AddHero" ,  {m="Heros",a="Heros",heros = "all"} ,{success_callback = function()
--																									switchScene("herolup")
--																								end
--																							})
--																					end
HTTPS:send("Battle",{m = "battle",a = "battle",battle = "up",index = 1,id = 2317,cid =77 })
																end}
													 )

		ksv:addChild(infos:getLayer(),infos)
		card_x = card_x + 480
	end
	this.layer:addChild(ksv:getLayer())


	--阵容
	local temps

	    temps = Btn:new("image/buttonUI/Lineup/lineup/",{"def.png","pre.png"},390,675,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()

							HTTPS:send("Battle" ,  {m="battle",a="battle",battle = "select_up"} ,{success_callback = function()
								switchScene("battlere")
							end })
	    				 end
	    		 })

		this.layer:addChild(temps:getLayer())



return this
end

function lineuplayer:getLayer()
	return self.layer
end

return lineuplayer
