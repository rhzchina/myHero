local PATH = IMG_SCENE.."transcrip/"
local info_layer = requires(SRC.."Scene/transcript/infolayer")
local TranscriptLayer = {
	layer,
	mainlayer,
	smalllayer,
	old_layer,
	show_layer,
	move_layer,
	type_id,
	mask,
	is_error,
	quick_layer,
	all_max_layer
}
function TranscriptLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	if data.type == 1 then
		this:create_big()
	else	
		this:create_small(data.temp)
	end
	
	
	return this
end

function TranscriptLayer:create_big()
	if self.smalllayer then
		self.layer:removeChild(self.smalllayer,true)
	end
	self.type_id = 1001
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	self.mainlayer = CCLayer:create()
	
	local bg = newSprite(IMG_PATH.."images/common/main.png")
	self.mainlayer:addChild(bg)
	
	local title = newSprite(PATH.."title.png")
	setAnchPos(title, 0, 670)
	self.mainlayer:addChild(title)
	
	local rank = Btn:new(IMG_BTN, {"all_rands.png", "all_rands_press.png"},  330 , 670,{
				callback = function()  
					HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "duplicate",type_id = self.type_id,page=0} ,{success_callback = 
						function()
							switchScene("randsSport",{page=0,type="copy"})
						end })
				end}
			)
	self.mainlayer:addChild(rank:getLayer())
	
	
	
	local scroll = ScrollView:new(0,90,480,581,10)
	local tra_data = DATA_Transcript:get()
	
	local temp
	for k, v in pairs(tra_data) do
		local temp
		temp = info_layer:new(self,v,k)
		scroll:addChild(temp:getLayer(),temp)
	end
	scroll:alignCenter()
	self.mainlayer:addChild(scroll:getLayer())
	
	self.layer:addChild(self.mainlayer)
end

function TranscriptLayer:create_small(temp_data)
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	if self.smalllayer then
		self.layer:removeChild(self.smalllayer,true)
	end
	
	self.smalllayer = CCLayer:create()
	self.old_layer = temp_data.cur_layer
	self.is_error = false
	local bg = newSprite(PATH.."bg2.png")
	self.smalllayer:addChild(bg)
	
	
	
	self:draw_map(temp_data.cur_layer,temp_data.type_id,0,false)
	
	--self.mask = Mask:new({item = self.smalllayer})
	self.layer:addChild(self.smalllayer)
	
end
--[[
	cur_layer:当前层
	type_id：塔类型
	max_layer:最高层
	is_quick:是否快速爬塔
]]
function TranscriptLayer:draw_map(cur_layer,type_id,max_layer,is_quick)
	--cur_layer = 3
	if is_quick == true then
		if cur_layer == max_layer - 1 then
		
		else
			self:show_map(cur_layer,type_id,false,max_layer,is_quick)
		end
	else
		self:show_map(cur_layer,type_id,false,max_layer,is_quick)
	end
	
	if cur_layer > self.old_layer and is_quick == false then
		self:moveto(cur_layer,type_id,max_layer,is_quick)
	elseif cur_layer < max_layer and is_quick == true then
		self:moveto(cur_layer,type_id,max_layer,is_quick)
	end
end

function TranscriptLayer:moveto(cur_layer,type_id,max_layer,is_quick)
	
	--self.old_layer = cur_layer
	if self.show_layer then
		self.smalllayer:removeChild(self.show_layer,true)
	end
	
	if self.move_layer then
		self.smalllayer:removeChild(self.move_layer,true)
	end
	
	self.move_layer = CCLayer:create()
	self.move_layer:setContentSize(CCSizeMake(480,642))
	--local old_layer = self.old_layer
	
	if cur_layer == 1 then
		local bg = newSprite(PATH..type_id.."/one.png")
		setAnchPos(bg, 0, 95)
		self.move_layer:addChild(bg)
		
		local bg1 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
		self.move_layer:addChild(bg1)
		
		local title_desc = display.strokeLabel(cur_layer - 1,126,188,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer ,126,115 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer + 1,126,110 + bg:getContentSize().height + bg1:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local hero_layer = CCLayer:create()
		local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
		hero_bg:setScaleX(0.7)
		setAnchPos(hero_bg, 270, 170 )
		
		hero_layer:addChild(hero_bg)
		
		local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
		hero_bg1:setScaleX(0.7)
		setAnchPos(hero_bg1, 270, 170 )
		hero_layer:addChild(hero_bg1)
		hero_layer:setContentSize(hero_bg1:getContentSize())
		
		local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
		hero:setScaleX(0.7)
		setAnchPos(hero, 270, 170 )
		hero_layer:addChild(hero)
		
		self.move_layer:addChild(hero_layer)
		
		transition.jumpTo(hero_layer,{time = 1.5,x=0,y=0,height=8,jumps=10,onComplete = function() 
			transition.moveTo(hero_layer,{x= - 120,y = 232,time = 0.5,onComplete = function() 
				if is_quick == true then
					if cur_layer < max_layer - 1 then
						self:draw_map(cur_layer + 1,type_id,max_layer,true)
					else
						self:show_map(cur_layer,type_id,true,max_layer,true) 
					end
				else
					self:show_map(cur_layer,type_id,true,0,false) 
				end
				
			end})
		end})
		
	elseif cur_layer == 2 then
		local bg = newSprite(PATH..type_id.."/one.png")
		setAnchPos(bg, 0, 95)
		self.move_layer:addChild(bg)
		
		local bg1 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
		self.move_layer:addChild(bg1)
		
		local bg2 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg2, 0, 95 + bg:getContentSize().height + bg1:getContentSize().height)
		self.move_layer:addChild(bg2)
		
		local title_desc = display.strokeLabel(cur_layer - 2,126,188,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer - 1,126,115 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer ,126,110 + bg:getContentSize().height + bg1:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer + 1,126,110 + bg:getContentSize().height + bg1:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		
		transition.moveTo(self.move_layer,{x=0,y = - 292,time = 2,onComplete = function() 
		--self:show_map(cur_layer,type_id,true) 
		end})
		
		local hero_layer = CCLayer:create()
		local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
		hero_bg:setScaleX(0.7)
		setAnchPos(hero_bg, 150, 170 + 230 )
		
		hero_layer:addChild(hero_bg)
		
		local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
		hero_bg1:setScaleX(0.7)
		setAnchPos(hero_bg1, 150, 170 + 230 )
		hero_layer:addChild(hero_bg1)
		hero_layer:setContentSize(hero_bg1:getContentSize())
		
		local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
		hero:setScaleX(0.7)
		setAnchPos(hero, 150, 170 + 230 )
		hero_layer:addChild(hero)
		
		
		transition.jumpTo(hero_layer,{time = 1.5,x=0,y=0,height=8,jumps=10,onComplete = function() 
			transition.moveTo(hero_layer,{x= 120,y = 200,time = 0.5,onComplete = function() 
				if is_quick == true then
					if cur_layer < max_layer - 1 then
						self:draw_map(cur_layer + 1,type_id,max_layer,true)
					else
						self:show_map(cur_layer,type_id,true,max_layer,true) 
					end
				else
					self:show_map(cur_layer,type_id,true,0,false) 
				end
				
				
			end})
		end})
		self.move_layer:addChild(hero_layer)
	elseif cur_layer >= 99 then
		local bg = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg, 0, 95)
		self.move_layer:addChild(bg)
		
		local bg1 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
		self.move_layer:addChild(bg1)
		
		local title_desc = display.strokeLabel(cur_layer - 2,126,115 ,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer  - 1,126 ,110 + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer + 1 ,126 ,110 + bg:getContentSize().height + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.move_layer:addChild(title_desc)
			
		
		local hero_layer = CCLayer:create()
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 270, 100 + bg:getContentSize().height/2 )
			
			hero_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 270, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero_bg1)
			hero_layer:setContentSize(hero_bg1:getContentSize())
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 270, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero)
			
			
			transition.jumpTo(hero_layer,{time = 1.5,x=0,y=0,height=8,jumps=10,onComplete = function() 
				transition.moveTo(hero_layer,{x= - 120,y = 210,time = 0.5,onComplete = function() 
					
					if is_quick == true then
						if cur_layer < max_layer - 1 then
							self:draw_map(cur_layer + 1 ,type_id,max_layer,true)
						else
							self:show_map(cur_layer,type_id,true,max_layer,true) 							
						end
					else
							self:show_map(cur_layer,type_id,true,0,false) 
					end
				end})
			end})	
			
			self.move_layer:addChild(hero_layer)
		
	else
		if cur_layer % 2 == 0 then
			
			local bg = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg, 0, 95 - bg:getContentSize().height/2)
			self.move_layer:addChild(bg)
			
			local bg1 = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg1, 0, 95 + bg:getContentSize().height - bg:getContentSize().height/2)
			self.move_layer:addChild(bg1)
			
			local bg1 = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg1, 0, 95 + bg:getContentSize().height*2 - bg:getContentSize().height/2)
			self.move_layer:addChild(bg1)
			
			--local title_desc = display.strokeLabel(cur_layer - 3,126,115 - bg:getContentSize().height/2 ,16,ccc3(255,255,255),nil,nil,{align = 0})
			--self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer - 2 ,126 ,110 + bg:getContentSize().height/2 - bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  - 1,126 ,110 + bg:getContentSize().height - bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 1 ,126 ,110 + bg:getContentSize().height + bg:getContentSize().height/2 ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
		    transition.moveTo(self.move_layer,{x=0,y = - bg:getContentSize().height/2,time = 2,onComplete = function() 
			--self:show_map(cur_layer,type_id,true) 
			end})
		
			local hero_layer = CCLayer:create()
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 150, 100 + bg:getContentSize().height/2 )
			
			hero_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 150, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero_bg1)
			hero_layer:setContentSize(hero_bg1:getContentSize())
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 150, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero)
			
			
			transition.jumpTo(hero_layer,{time = 1.5,x=0,y=0,height=8,jumps=10,onComplete = function() 
				transition.moveTo(hero_layer,{x= 120,y = 210,time = 0.5,onComplete = function() 
					if is_quick == true then
						if cur_layer < max_layer - 1 then
							self:draw_map(cur_layer + 1,type_id,max_layer,true)
						else
							self:show_map(cur_layer,type_id,true,max_layer,true) 
						end
					else
						self:show_map(cur_layer,type_id,true,0,false) 
					end
				end})
			end})
			
			self.move_layer:addChild(hero_layer)
		else
			
			local bg = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg, 0, 95)
			self.move_layer:addChild(bg)
			
			local bg1 = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
			self.move_layer:addChild(bg1)
			
			local title_desc = display.strokeLabel(cur_layer ,126,115 ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  - 1,126 ,110 + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 1 ,126 ,110 + bg:getContentSize().height + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.move_layer:addChild(title_desc)
			
			transition.moveTo(self.move_layer,{x=0,y = - bg:getContentSize().height/2,time = 2,onComplete = function() 
			--self:show_map(cur_layer,type_id,true) 
			end})
		
			local hero_layer = CCLayer:create()
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 270, 100 + bg:getContentSize().height/2 )
			
			hero_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 270, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero_bg1)
			hero_layer:setContentSize(hero_bg1:getContentSize())
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 270, 100 + bg:getContentSize().height/2 )
			hero_layer:addChild(hero)
			
			
			transition.jumpTo(hero_layer,{time = 1.5,x=0,y=0,height=8,jumps=10,onComplete = function() 
				transition.moveTo(hero_layer,{x= - 120,y = 210,time = 0.5,onComplete = function() 
					
					if is_quick == true then
						if cur_layer < max_layer - 1 then
							self:draw_map(cur_layer + 1 ,type_id,max_layer,true)
						else
							self:show_map(cur_layer,type_id,true,max_layer,true) 							
						end
					else
						self:show_map(cur_layer,type_id,true,0,false) 
					end
				end})
			end})	
			
			self.move_layer:addChild(hero_layer)
		end
		
	end
	
	self.smalllayer:addChild(self.move_layer)
	
end

function TranscriptLayer:show_map(cur_layer,type_id,is_fight,max_layer,is_quick)
	if self.move_layer then
		self.smalllayer:removeChild(self.move_layer,true)
	end
	
	if self.show_layer then
		self.smalllayer:removeChild(self.show_layer,true)
	end
	
	self.show_layer = CCLayer:create()
	self.show_layer:setContentSize(CCSizeMake(480,642))
	--local old_layer = self.old_layer
	
	if cur_layer == 1 or cur_layer == 0 then
		local bg = newSprite(PATH..type_id.."/one.png")
		setAnchPos(bg, 0, 95)
		self.show_layer:addChild(bg)
		
		local bg1 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
		self.show_layer:addChild(bg1)
		
		
		
		if cur_layer == 0 then
			local title_desc = display.strokeLabel(cur_layer,126,188,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 1,126,115 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 2,126,110 + bg:getContentSize().height + bg1:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
		
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 270, 170 )
			
			self.show_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 270, 170 )
			self.show_layer:addChild(hero_bg1)
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 270, 170 )
			self.show_layer:addChild(hero)
		else
			local title_desc = display.strokeLabel(cur_layer - 1,126,188,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer ,126,115 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 1,126,110 + bg:getContentSize().height + bg1:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 150, 170 + 230)
			
			self.show_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 150, 170 +230 )
			self.show_layer:addChild(hero_bg1)
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 150, 170 +230)
			self.show_layer:addChild(hero)
		end
		
		local one_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 20, 90,{text = {"进入第"..(cur_layer + 1 ).."层", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
				
				if cur_layer >= 100 then

				else
					if self.is_error == true then
						self.is_error = false
						HTTPS:send("Fighting",
									{a = "fighting",
									 m = "fighting", 
									 fighting = "start", 
									 type = "copy",
									 mode = "fast",
									 type_id = type_id, 
									 layer = cur_layer },{success_callback= function()
										self.old_layer = cur_layer
										switchScene("fighting","copy")
									 end,
									 error_callback = function()
										self.is_error = true
									 end
									 })
					else
						self:draw_map(cur_layer + 1,type_id,0,false)
					end
				end
					
					
			end})
		self.show_layer:addChild(one_layer:getLayer())
		
		local title_max = display.strokeLabel("免费",155,100,30,ccc3(255,255,255))
		self.show_layer:addChild(title_max)
		
		if cur_layer >= 100 then
			max_the_layer = 100
		else
			if cur_layer + 16 >= 100 then
				max_the_layer = 100
			else
				max_the_layer = cur_layer + 16
			end			
		end
		if max_the_layer > tonumber(self.all_max_layer) then
			max_the_layer = tonumber(self.all_max_layer)
		else
		
		end

		if cur_layer ~= (max_the_layer - 1) and cur_layer <= max_the_layer then
			local other_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 240, 90,{text = {"进入第"..(max_the_layer -  1).."层", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
					
					if cur_layer >= 100 then
					
					else
						if self.is_error == true then
							self.is_error = false
							HTTPS:send("Duplicate" ,  
							{m="duplicate",a="duplicate",duplicate = "quick",type_id = type_id,layer=self.quick_layer} ,
								{success_callback = function(data)
									Dialog.tip("获取物品")
								end,
								 error_callback = function()
									self.is_error = true
								 end 
								
							})
						else
							self.quick_layer = cur_layer
							self:draw_map(cur_layer + 1,type_id, max_the_layer,true)
						end
						
					end
			end})
			self.show_layer:addChild(other_layer:getLayer())
			local gold_leaf = newSprite(IMG_COMMON.."gold_leaf.png")
			gold_leaf:setScaleX(0.7)
			setAnchPos(gold_leaf, 380, 100 )
			self.show_layer:addChild(gold_leaf)
			
			local gold_num = display.strokeLabel("100",405,105,20,ccc3(255,255,255))
			self.show_layer:addChild(gold_num)
		end
		
	
		
		
	elseif cur_layer >= 99 then
		local bg = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg, 0, 95)
		self.show_layer:addChild(bg)
		
		local bg1 = newSprite(PATH..type_id.."/tow.png")
		setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
		self.show_layer:addChild(bg1)
		local title_desc = display.strokeLabel(cur_layer -2,126,115 ,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.show_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer  -1,126 ,110 + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.show_layer:addChild(title_desc)
		
		local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
		self.show_layer:addChild(title_desc)
		
		local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
		hero_bg:setScaleX(0.7)
		setAnchPos(hero_bg, 150, 100 + bg:getContentSize().height )
		
		self.show_layer:addChild(hero_bg)
		
		local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
		hero_bg1:setScaleX(0.7)
		setAnchPos(hero_bg1, 150, 100 + bg:getContentSize().height )
		self.show_layer:addChild(hero_bg1)
		
		local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
		hero:setScaleX(0.7)
		setAnchPos(hero, 150, 100 + bg:getContentSize().height )
		self.show_layer:addChild(hero)
		
		local tra_data = DATA_Transcript:get()
		for k,v in pairs(tra_data) do
			if tonumber(v.type_id) > tonumber(type_id) then
				local other_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 240, 90,{text = {"下一个塔", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
					HTTPS:send("Duplicate" ,  
						{m="duplicate",a="duplicate",duplicate = "emigrated",type_id = v.type_id} ,
						{success_callback = function(temp_data)
							self:create_small(temp_data)
						end })
				end})
				self.show_layer:addChild(other_layer:getLayer())
			
			elseif tonumber(v.type_id) < tonumber(type_id) then
				local one_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 0, 90,{text = {"上一个塔", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
					HTTPS:send("Duplicate" ,  
						{m="duplicate",a="duplicate",duplicate = "emigrated",type_id = v.type_id} ,
						{success_callback = function(temp_data)
							self:create_small(temp_data)
						end })
				end})
				self.show_layer:addChild(one_layer:getLayer())
			end
		end
		
	else
		if cur_layer %2 == 0 then
			local bg = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg, 0, 95)
			self.show_layer:addChild(bg)
			
			local bg1 = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg1, 0, 95 + bg:getContentSize().height)
			self.show_layer:addChild(bg1)
			
			local title_desc = display.strokeLabel(cur_layer -1,126,115 ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer +1 ,126 ,110 + bg:getContentSize().height,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 270, 100 + bg:getContentSize().height/2 )
			
			self.show_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 270, 100 + bg:getContentSize().height/2 )
			self.show_layer:addChild(hero_bg1)
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 270, 100 + bg:getContentSize().height/2 )
			self.show_layer:addChild(hero)
			
			
			
		else
			local bg = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg, 0, 95 - bg:getContentSize().height/2)
			self.show_layer:addChild(bg)
			
			local bg1 = newSprite(PATH..type_id.."/tow.png")
			setAnchPos(bg1, 0, 95 + bg:getContentSize().height - bg:getContentSize().height/2)
			self.show_layer:addChild(bg1)
			
			local title_desc = display.strokeLabel(cur_layer - 2,126,115 - bg:getContentSize().height/2 ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  - 1,126 ,110 + bg:getContentSize().height/2 - bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer  ,126 ,110 + bg:getContentSize().height - bg:getContentSize().height/2,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local title_desc = display.strokeLabel(cur_layer + 1 ,126 ,110 + bg:getContentSize().height ,16,ccc3(255,255,255),nil,nil,{align = 0})
			self.show_layer:addChild(title_desc)
			
			local hero_bg = newSprite(IMG_COMMON.."icon_bg"..DATA_User:get("icon_start")..".png")
			hero_bg:setScaleX(0.7)
			setAnchPos(hero_bg, 150, 100 + bg:getContentSize().height/2 )
			
			self.show_layer:addChild(hero_bg)
			
			local hero_bg1 = newSprite(IMG_COMMON.."icon_border"..DATA_User:get("icon_start")..".png")
			hero_bg1:setScaleX(0.7)
			setAnchPos(hero_bg1, 150, 100 + bg:getContentSize().height/2 )
			self.show_layer:addChild(hero_bg1)
			
			local hero = newSprite(IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png")
			hero:setScaleX(0.7)
			setAnchPos(hero, 150, 100 + bg:getContentSize().height/2 )
			self.show_layer:addChild(hero)
		end
		
		
		local one_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 0, 90,{text = {"进入第"..(cur_layer + 1).."层", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()
				if cur_layer >= 100 then
				
				else
					if self.is_error == true then
						self.is_error = false
						HTTPS:send("Fighting",
									{a = "fighting",
									 m = "fighting", 
									 fighting = "start", 
									 type = "copy",
									 mode = "fast",
									 type_id = type_id, 
									 layer = cur_layer },{success_callback= function()
										self.old_layer = cur_layer
										switchScene("fighting","copy")
									 end,
									 error_callback = function()
										self.is_error = true
									 end
									 })
					else
						self:draw_map(cur_layer + 1,type_id,0,false)
					end
				end
			end})
		self.show_layer:addChild(one_layer:getLayer())
		local title_max = display.strokeLabel("免费",155,100,30,ccc3(255,255,255))
		self.show_layer:addChild(title_max)
		
		local max_the_layer = 0
		
		if cur_layer >= 100 then
			max_the_layer = 100
		else
			if cur_layer + 16 >= 100 then
				max_the_layer = 100
			else
				max_the_layer = cur_layer + 16
			end			
		end
		if max_the_layer > tonumber(self.all_max_layer) then
			max_the_layer = tonumber(self.all_max_layer)
		else
		
		end
		
		if cur_layer ~= (max_the_layer - 1) and cur_layer <= max_the_layer then
			local other_layer = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 240, 90,{text = {"进入第"..(max_the_layer - 1).."层", 24, ccc3(205, 133, 63), ccp(0, 0)},callback = function()					
				if cur_layer >= 100 then
				
				else
					if self.is_error == true then
						self.is_error = false
						HTTPS:send("Duplicate" ,  
						{m="duplicate",a="duplicate",duplicate = "quick",type_id = type_id,layer=self.quick_layer} ,
							{success_callback = function(data)
								Dialog.tip("获取物品")
							end,
							 error_callback = function()
								self.is_error = true
							 end 
							
						})
					else
						self.quick_layer = cur_layer
						self:draw_map(cur_layer +1 ,type_id, max_the_layer,true)
					end
				end
			
			end})
			self.show_layer:addChild(other_layer:getLayer())
			local gold_leaf = newSprite(IMG_COMMON.."gold_leaf.png")
			gold_leaf:setScaleX(0.7)
			setAnchPos(gold_leaf, 380, 100 )
			self.show_layer:addChild(gold_leaf)
			
			local gold_num = display.strokeLabel("100",405,105,20,ccc3(255,255,255))
			self.show_layer:addChild(gold_num)
		end
		
	
			
	end
	
	
	
	self.smalllayer:addChild(self.show_layer)
	if is_quick == true then
		if tonumber(cur_layer) == tonumber(max_layer) - 1 then
			if is_fight == true then
				if is_fight == true then
					HTTPS:send("Duplicate" ,  
					{m="duplicate",a="duplicate",duplicate = "quick",type_id = type_id,layer=self.quick_layer} ,
						{success_callback = function(data)
							Dialog.tip("获取物品")
						end,
						 error_callback = function()
							self.is_error = true
						 end 
						
					})
				end
			end
		end
	else
		if is_fight == true then
				HTTPS:send("Fighting",
									{a = "fighting",
									 m = "fighting", 
									 fighting = "start", 
									 type = "copy",
									 mode = "ordinary",
									 type_id = type_id, 
									 layer = cur_layer},{
									 success_callback= function()
										self.old_layer = cur_layer
										switchScene("fighting","copy")
									 end,
									 error_callback = function()
										self.is_error = true
									 end
									 })
		end
	end
	
	
end

function TranscriptLayer:getLayer()
	return self.layer
end


return TranscriptLayer
