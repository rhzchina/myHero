
local CIBLayer = {layer,is_select,is_Transposition,hero_lief,is_clickon,hero_tra,point_x,point_y,gid}
function CIBLayer:new(data,x,y,params)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.params = params or {}
	this.point_x = x
	this.point_y = y
	this.gid = 1001
	this.is_clickon = false--判定是否在有效范围内点击
	this.is_select = false--是否选中
	this.is_Transposition = false--是否换位
	this.layer = display.newLayer()
	setAnchPos(this.layer,this.point_x,this.point_y)

	local bg = display.newSprite("image/card/card_box.png")
	setAnchPos(bg,6,5)
	bg:setScale(0.54)
	this.layer:addChild(bg)

	local hero = display.newSprite("image/myhero/big/"..data..".png")
	hero:setScale(0.5)
--	setAnchPos(hero,20,23)
	setAnchPos(hero,bg:getContentSize().width * 0.54 / 2, bg:getContentSize().height * 0.54 / 2,0.5, 0.5)
	this.layer:addChild(hero)

	this.hero_lief= display.newSprite("image/card/select.png")
	setAnchPos(this.hero_lief,3)
	this.hero_lief:setVisible(false)
	this.layer:addChild(this.hero_lief)

	this.hero_tra = display.newSprite("image/card/replace.png")
	this.hero_tra:setVisible(false)
	setAnchPos(this.hero_tra,40,-40)
	this.layer:addChild(this.hero_tra)


	this.layer:setTouchEnabled(true)
	function this.layer:onTouch(type, x, y)
		if type == CCTOUCHBEGAN then

			if x > this.point_x and x < this.point_x+132 and y > this.point_y - 170 +170 and y <this.point_y+170 then

				this:set_click(true)
					if this:get_Transposition() == false and this:get_select() == false then
						this:set_select(true)
					end
			end
		elseif type == CCTOUCHMOVED then

		elseif type == CCTOUCHENDED then
					--放开后执行回调
			if params["callback"] then
				params["callback"](this,x,y)
			end
		end
		return true
	end
	this.layer:registerScriptTouchHandler(function(type,x,y) return this.layer:onTouch(type,x,y) end,false,-132,false)
	return this
end


--[[判定是否点击到对象]]
function CIBLayer:set_click(is_clicks)
	self.is_clickon = is_clicks
end

function CIBLayer:get_click()
	return self.is_clickon
end

--[[对象是否选中]]
function CIBLayer:set_select(is_selects)
	self.hero_lief:setVisible(is_selects)
	self.is_select = is_selects
end

function CIBLayer:get_select()
	return self.is_select
end

--[[对象替换]]
function CIBLayer:set_Transposition(is_Tran)
	self.hero_tra:setVisible(is_Tran)
	self.is_Transposition = is_Tran
end

function CIBLayer:get_Transposition()
	return self.is_Transposition
end

--[[设置坐标]]
function CIBLayer:set_point(parms)
	self.point_x = parms[1]
	self.point_y = parms[2]
	setAnchPos(self.layer,parms[1],parms[2])
end

function CIBLayer:get_point(parms)
	return {self.point_x,self.point_y}
end

function CIBLayer:getLayer()
	return self.layer
end

function CIBLayer:get_gid()
	return self.gid
end

return CIBLayer
