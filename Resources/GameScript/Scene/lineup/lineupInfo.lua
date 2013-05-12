local PATH = IMG_SCENE.."embattle/"
	local CardInfo = require(SRC.."Scene/common/CardInfo")

local lineuinfoplayer = {layer,point_x,point_y,is_clickon,is_select,datas,gid}

function lineuinfoplayer:new(index,sv,data,x,y,params)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.params = params or {}
	this.point_x = x
	this.point_y = y
	this.is_clickon = false
	this.is_select = false
	this.datas = data
	this.layer = CCLayer:create()
	setAnchPos(this.layer,this.point_x,this.point_y)
	this.layer:setContentSize(CCSize(450,624))

	local main_bt = {{"weapon",5,540-this.point_y},
								{"armor",5,415-this.point_y},
								{"jewellery",5,290-this.point_y},
								{"skill",365,540-this.point_y},
								{"skill",365,415-this.point_y},
								{"skill",365,290-this.point_y}
							   }

	local temp
	for i ,v in pairs(main_bt) do
	    temp = Btn:new(PATH,{v[1]..".png"},v[2],v[3],
	    		{
					parent = sv,
	    			scale = true,
	    			callback= this.params.equipCallback 
	    		 })
	    if i == 1 then
	    	--group:chooseBtn(temp)
	    end
		this.layer:addChild(temp:getLayer())
	end


	local card = CardInfo:new(95,190,{type = "hero",cid = data["cid"]})
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
