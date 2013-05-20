local PATH = IMG_SCENE.."embattle/"
local CardInfo = require(SRC.."Scene/common/CardInfo")
local ItemList = require(SRC.."Scene/common/ItemList")

local lineuinfoplayer = {
	layer,
	point_x,
	point_y,
	is_clickon,
	is_select,
	datas,
	gid
}

function lineuinfoplayer:new(index,sv,data,x,y,params)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.params = params or {}
	this.point_x = x
	this.point_y = y
	this.is_clickon = false
	this.is_select = false
	this.layer = CCLayer:create()
	setAnchPos(this.layer,this.point_x,this.point_y)
	this.layer:setContentSize(CCSize(450,624))

	local data = data or {}
	
	local main_bt = {{"arm",5,540-this.point_y,1},
								{"armour",5,415-this.point_y,2},
								{"ornament",5,290-this.point_y,3},
								{"skill",360,540-this.point_y, 0}, --天赋技能
								{"skill",360,415-this.point_y,4},
								{"skill",360,290-this.point_y,5}
							   }

	local temp,bg,other
	for i ,v in pairs(main_bt) do
		local front, kind
		
		if v[4] == 0 or v[4] >3 then
			kind = "skill"
		else
			kind = "equip"
		end
		
		bg = v[1]..".png"
		other = nil
		if data["cid"] and DATA_Dress:get(data["cid"],v[4]) then --若阵容 有武将，且已有装备
			local equipId = DATA_Dress:get(data["cid"], v[4], "cid")
			
			for dk, dv in pairs(DATA_Dress:get(data["cid"])) do
				if dk == v[4].."" then
					front = IMG_ICON..kind.."/S_" .. getBag(kind,equipId,"look") ..".png"
					bg = "icon_bg"..getBag(kind,equipId,"star")..".png"
					other = {IMG_COMMON.."icon_border"..DATA_Bag:get(kind,equipId,"star")..".png",45,45}
					break
				end					
			end
		end
		
		local scale
		if v[4] == 0 then --天赋技能不可更换
			scale = false
		else
			scale = 1.05 
		end
	    temp = Btn:new(IMG_COMMON,{bg},v[2],v[3],
	    		{
					parent = sv,
	    			scale = scale,
	    			front = front,
	    			other = other,
	    			callback= function()
	    				if scale then
	    					if data["cid"] then
	    						this.params.equipCallback(kind,v[1],v[4])
	    					else
	    						KNMsg.getInstance():flashShow("请选 择要上阵列的武将")
	    					end
	    				else
	    				end
	    			end
	    		 })
		this.layer:addChild(temp:getLayer())
	end


	local card = CardInfo:new(95,190,{
		type = "hero",
		cid = data["cid"],
		callback= function()
			this.params.cardCallback(index)
--			HTTPS:send("AddHero", {a = "heros", m = "heros", heros = "add", star = 5})
--			HTTPS:send("Skill", {a = "skill", m = "skill", skill="arm_add",id = 6307})
--			HTTPS:send("Skill", {a = "skill", m = "skill", skill="shiping_add",id = 7304})
		end
	})
	this.layer:addChild(card:getLayer())
	
	--------[[英雄描述]]
	local desc_cald = newSprite(PATH.."line.png")----英雄
	setAnchPos(desc_cald,10,160-this.point_y)
	this.layer:addChild(desc_cald)

if _G.next (data)  ~= nil then
		this.is_click = false
		this.gid = data["cid"]
		

--		local blood = newSprite("image/card/blood.png")----英雄
--		setAnchPos(blood,129,342-this.point_y)
--		this.layer:addChild(blood)
--
--
--		local text_blood = newLabel(getBag("hero",this.gid,"hp")..index,  15)
--		setAnchPos(text_blood,170,352-this.point_y)
--		this.layer:addChild(text_blood )
--
--		local anti = newSprite("image/card/anti.png")----英雄
--	setAnchPos(anti,200,342-this.point_y)
--	this.layer:addChild(anti)
--
--
--		local text_anti = newLabel(getBag("hero",this.gid,"defe") , 15)
--		setAnchPos(text_anti,240,352-this.point_y)
--		this.layer:addChild(text_anti )
--
--		local Attack = newSprite("image/card/Attack.png")----英雄
--		setAnchPos(Attack,270,342-this.point_y)
--		this.layer:addChild(Attack)
--
--
--		local text_att = newLabel(getBag("hero",this.gid,"att") , 15)
--		setAnchPos(text_att,310,352-this.point_y)
--		this.layer:addChild(text_att )
--
--		local lev_box = newSprite("image/card/lever_box.png")----英雄
--		setAnchPos(lev_box,125,298-this.point_y)
--		this.layer:addChild(lev_box)
--
--
--		local KNBar = require("GameScript/Common/KNBar")
--		local card_bar = KNBar:new("cardinfo" , 122 , 512 +this.point_y, {maxValue=getBag("hero",this.gid,"quick"), curValue=getBag("hero",this.gid,"scalequ")})
--		card_bar:setIsShowText(false)
--		this.layer:addChild(card_bar)

		--------[[英雄描述]]
		local desc_test = {
												{"事实上事实上",30,238-this.point_y},
												{"事实上事实上",30,200-this.point_y},
												{"事实上事实上",30,162-this.point_y}}

		for i,v in pairs(desc_test) do
			local text_desc = newLabel(v[1] , 20)
			setAnchPos(text_desc,v[2],v[3])
			this.layer:addChild(text_desc )
		end

	end

--	this.layer:setTouchEnabled(true)
	function this.layer:onTouch(type, x, y)

		if this.params["parent"] and not this.params["parent"]:isLegalTouch(x,y) then
			return false
		end
		if type == CCTOUCHBEGAN then

		elseif type == CCTOUCHMOVED then

		elseif type == CCTOUCHENDED then
					--放开后执行回调
					if this:getRange():containsPoint(ccp(x,y)) then
								print("~~~~~~~~~~~~~~")
								
								if  x > 108 and x < 371 and y > 284 and y < 626 then
									if _G.next (data)  ~= nil then
										this:set_click(true)
									elseif _G.next (data)  == nil then
										this:set_select(true)
									end

									if params["callback"] then
										params["callback"](this,x,y)
									end
								end
					end
		end
		return true
	end
	this.layer:registerScriptTouchHandler(function(type,x,y) return this.layer:onTouch(type,x,y) end,false,-132,false)
	return this
end


--[[判定是否点击到对象]]
function lineuinfoplayer:set_click(is_clicks)
	self.is_clickon = is_clicks
end

function lineuinfoplayer:get_click()
	return self.is_clickon
end


--[[对象是否选中]]
function lineuinfoplayer:set_select(is_selects)

end

function lineuinfoplayer:get_select()
	return self.is_select
end


--[[设置坐标]]
function lineuinfoplayer:set_point(parms)
	self.point_x = parms[1]
	self.point_y = parms[2]
	setAnchPos(self.layer,parms[1],parms[2])
end

function lineuinfoplayer:get_point(parms)
	return {self.point_x,self.point_y}
end

function lineuinfoplayer:getLayer()
	return self.layer
end

function lineuinfoplayer:get_gid()
	return self.gid
end

function lineuinfoplayer:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	x = x + parent:getPositionX()
	y = y + parent:getPositionY()
	while parent:getParent() do
		parent = parent:getParent()
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()
	end
	return CCRectMake(x,y,self.layer:getContentSize().width,self.layer:getContentSize().height)
end
return lineuinfoplayer
