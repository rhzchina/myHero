--[[武将信息]]
local cardInfolayer = {layer}

function cardInfolayer:new(data,x,y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.layer = CCLayer:create()

	local bg = CCSprite:create("image/scene/lineup/bg.png")
	setAnchPos(bg,10,100)
	this.layer:addChild(bg)

	local title = CCSprite:create("image/cardInfo/font_bg.png")
	setAnchPos(title,40,788)
	this.layer:addChild(title)

	local font = CCSprite:create("image/cardInfo/font.png")
	setAnchPos(font,170,790)
	this.layer:addChild(font)

	  --------[[英雄信息]]
	local hero_bg = CCSprite:create("image/card/card_box.png")
	setAnchPos(hero_bg,20,435)
	this.layer:addChild(hero_bg)

		local hero_cald = CCSprite:create(IMG_ICON.."role/L_"..DATA_CardInfo:get("card_id")..".png")----英雄
		setAnchPos(hero_cald,33,491)
		this.layer:addChild(hero_cald)

		local blood = CCSprite:create("image/card/blood.png")----英雄
		setAnchPos(blood,39,493)
		this.layer:addChild(blood)


		local text_blood = CCLabelTTF:create(DATA_CardInfo:get("hp"), "Arial" , 15)
		setAnchPos(text_blood,80,503)
		this.layer:addChild(text_blood )

		local anti = CCSprite:create("image/card/anti.png")----英雄
		setAnchPos(anti,110,493)
		this.layer:addChild(anti)


		local text_anti = CCLabelTTF:create(DATA_CardInfo:get("defe"), "Arial" , 15)
		setAnchPos(text_anti,150,503)
		this.layer:addChild(text_anti )

		local Attack = CCSprite:create("image/card/Attack.png")----英雄
		setAnchPos(Attack,180,493)
		this.layer:addChild(Attack)


		local text_att = CCLabelTTF:create(DATA_CardInfo:get("att") , "Arial" , 15)
		setAnchPos(text_att,220,503)
		this.layer:addChild(text_att )

		local lev_box = CCSprite:create("image/card/lever_box.png")----英雄
		setAnchPos(lev_box,35,449)
		this.layer:addChild(lev_box)


		local KNBar = require("GameScript/Common/KNBar")
		local card_bar = KNBar:new("cardinfo" , 32 , 361 , {maxValue=DATA_CardInfo:get("quicek") , curValue=DATA_CardInfo:get("scalequ")})
		card_bar:setIsShowText(false)
		this.layer:addChild(card_bar)



	--[[简介]]
	local intro_bg = CCSprite:create("image/cardInfo/introduction.png")
	setAnchPos(intro_bg,288,435)
	this.layer:addChild(intro_bg)



	--[[组合信息]]
	local zuhe_bg = CCSprite:create("image/cardInfo/line.png")
	setAnchPos(zuhe_bg,25,220)
	this.layer:addChild(zuhe_bg)


	--强化按钮
	--local group = RadioGroup:new()
	local temps

	    temps = Btn:new(IMG_BTN,{"change.png","change_press.png"},30,125,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print(i,"---")
	    				 end
	    		 })

		this.layer:addChild(temps:getLayer())


		--传功
		local temp

	    temp = Btn:new(IMG_BTN,{"pass.png","pass_press.png"},250,125,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print(i,"---")
	    				 end
	    		 })

		this.layer:addChild(temp:getLayer())






return this
end




function cardInfolayer:getLayer()
	return self.layer
end

return cardInfolayer
