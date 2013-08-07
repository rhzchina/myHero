local PATH = IMG_SCENE.."embattle/"
local ItemList = require(SRC.."Scene/common/ItemList")

local Detail = require(SRC.."Scene/common/CardDetail")
local CommEmbattle = require(SRC.."Scene/common/CommEmbattle")
local lineuplayer = {
	layer,
}

function lineuplayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self

	local size = DATA_Embattle:getLen() 

	local num --阵容的个数
	if size < 3 then
		num = 3
	elseif size >= 6 then
		num = 6
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
	local infolayer = require(SRC.."Scene/lineup/lineupInfo")
	local ksv = ScrollView:new(15,100,450,550,0,true,1)
	local card_x = 56
	local card_y = 680
	local selected
	for i = 1, num do
		local infos
		infos = infolayer:new(i,ksv,DATA_Embattle:get(i),0,100,
			{
				parent = ksv,
				equipCallback = function(type,filter,pos)
					local list
					list = ItemList:new({
						type = type,
						filter = filter,
						checkBoxOpt = function()	 --列表复选框回调
							print(filter)
						end,
						okCallback = function()
							if list:getSelectItem() then
								HTTPS:send("Skill", {a = "skill", m = "skill",skill = "inserSkill", index = pos,
									card_id = getBag("hero", infos:get_gid(),"id") , card_cid = infos:get_gid() , skill_id = getBag(type,list:getSelectId(),"id") , skill_cid = list:getSelectId(),}, {success_callback=
									function()
										switchScene("lineup",ksv:getCurIndex())
									end
								})
							else
								MsgBox.create():flashShow("请选 择装备的物口")
							end
						end
					})
					this.layer:addChild(list:getLayer())
				end,
				cardCallback = function(pos)
					if infos:get_gid() then
						this.layer:addChild(Detail:new("hero",infos:get_gid()):getLayer(),1)
					else
						if i > DATA_Embattle:getLen() then  --未解销的关
							MsgBox.create():flashShow("此阵未还未解锁，请继续努力吧！~")
							return 
						end
						local list
						list = ItemList:new({
							type = "hero",
							checkBoxOpt = function()	 --列表复选框回调
								print(filter)
							end,
							okCallback = function()
								if list:getSelectItem() then
									HTTPS:send("Battle", {a = "battle", m = "battle",battle = "up", index = pos,
										id = getBag("hero", list:getSelectId(), "id"), cid = list:getSelectId()}, {success_callback=
										function()
											switchScene("lineup",ksv:getCurIndex())
										end
									})
								else
									MsgBox.create():flashShow("请选择要上阵列的武将")
								end
							end
						})
						this.layer:addChild(list:getLayer())
					end
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




	local embattle = CommEmbattle:new(60, 655, 290)
	this.layer:addChild(embattle:getLayer())
	
	--阵容
	local temps = Btn:new(PATH,{"embattle.png","embattle_press.png"},390,655,
	    		{
	    			highLight = true,
	    			scale = true,
	    			callback= function()
						switchScene("embattle")
		    		end
	    		 })
	this.layer:addChild(temps:getLayer())
	
	if data then
		ksv:setIndex(data)
	end
return this
end

function lineuplayer:getLayer()
	return self.layer
end

return lineuplayer
