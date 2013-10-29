local PATH = IMG_SCENE.."set/"
local Item = requires(SRC.."Scene/common/ItemsPage")
local SetLayer = {
	layer,
	mainlayer,
	showlayer,
}

function SetLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite(IMG_PATH.."images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(IMG_TEXT.."set.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	this:main()
	
	
	
	return this
end

function SetLayer:main()
	if self.showlayer then
		self.layer:removeChild(self.showlayer,true)
	end
	
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	self.mainlayer = CCLayer:create()
	
	for i = 0,3 do
		local block = newSprite(PATH.."block.png")
		setAnchPos(block, 0, 620 - i * 160)
		self.mainlayer:addChild(block)
	end
	
	local stone = Btn:new(IMG_COMMON, {"icon_bg"..DATA_User:get("icon_start")..".png", "icon_bg"..DATA_User:get("icon_start")..".png"},  20 , 635,{
				other = {{IMG_ICON .. "hero/S_"..DATA_User:get("icon_id")..".png",46,46},{IMG_COMMON .. "icon_border"..DATA_User:get("icon_start")..".png",46,46}},
				callback = function()  
					
				end}
			)
	self.mainlayer:addChild(stone:getLayer())
	
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() switchScene("menu") end})
	self.mainlayer:addChild(back:getLayer())
	
	local sound_bg = newSprite(PATH.."sound.png")
	setAnchPos(sound_bg, 60, 315)
	self.mainlayer:addChild(sound_bg)
	
	local audio_bg = newSprite(PATH.."audio.png")
	setAnchPos(audio_bg, 60, 470)
	self.mainlayer:addChild(audio_bg)
	
	
	
	local function createBtn( target )
		if target then target:removeFromParentAndCleanup( true ) end 
		
		local isEffect = audio.isMusicPlaying()
		local musicBtn
		musicBtn = Btn:new(IMG_BTN, isEffect and { "open_press.png" } or { "open.png" } , 190 , 20 , {
			priority = -130,
			callback = function()
				if isEffect then
					
				else
					FileManager.updatafile("savefile.txt" , "sound" , "=" , 0)
					audio.enable()
					if audio.isMusicPlaying() == false then
						audio.playMusic( SOUND .. "/home_bg.ogg" , true )
					end
					
				end
				createBtn( musicBtn )				
			end
		}):getLayer()
		sound_bg:addChild(musicBtn)
		
		
		local musicBtn1
		musicBtn1 = Btn:new(IMG_BTN, isEffect and { "close.png" } or { "close_press.png" } , 300 , 20 , {
			priority = -130,
			callback = function()
				if isEffect then
					audio.stopMusic( false )
					audio.disable()
					FileManager.updatafile("savefile.txt" , "sound" , "=" , 1)
				else
					
				end
				createBtn( musicBtn1 )
			end
		}):getLayer()
		sound_bg:addChild(musicBtn1)
		
		
	end
	createBtn()
	
	
	
	
	local function createEffect( target )
		if target then target:removeFromParentAndCleanup( true ) end 
		
		local isPlay = audio.getIsEffect()
		local sound_effectBtn
		sound_effectBtn = Btn:new(IMG_BTN, isPlay and { "open_press.png" } or { "open.png" } , 190 , 20 , {
			priority = -130,
			callback = function()
				if isPlay then
					
				else
					FileManager.updatafile("savefile.txt" , "audio" , "=" , 0)
					audio.setIsEffect( true )
					createEffect( sound_effectBtn )
				end
				
				
			end
		}):getLayer()
		audio_bg:addChild(sound_effectBtn)
		
		local sound_effectBtn1
		sound_effectBtn1 = Btn:new(IMG_BTN, isPlay and { "close.png" } or { "close_press.png" } , 300 , 20 , {
			priority = -130,
			callback = function()
				if isPlay then
					FileManager.updatafile("savefile.txt" , "audio" , "=" , 1)
					audio.setIsEffect( false )					
					createEffect( sound_effectBtn1 )
				else
					
				end
				
				
			end
		}):getLayer()
		audio_bg:addChild(sound_effectBtn1)
		
	end
	createEffect()	
	
	local font_text = newLabel("QQ群账号：", 24, {x = 20, y = 230, color = ccc3(255, 0, 0)})
	self.mainlayer:addChild(font_text)
	
	local get_data = DATA_Set:get("QQ")
	local QQ_data = INIT_FUNCTION.split(get_data.QQ , "@@")
	for k,v in pairs(QQ_data)do
		local qq_text
		qq_text = newLabel(v, 20, {x = 140, y = 260 - (k*30), color = ccc3(255, 0, 0)})
		self.mainlayer:addChild(qq_text)
	end
	
	local luntan = Btn:new(IMG_BTN, {"comnon_bnt.png", "comnon_bnt_press.png"}, 290, 180,{
				text = {"进入论坛", 20, ccc3(205, 133, 63), ccp(0, 0)},
				callback = function() 
					UpdataRes:getInstance():openUrl(get_data.URL)
				end})
	self.mainlayer:addChild(luntan:getLayer())
	
	local back = Btn:new(IMG_BTN, {"updata_hero.png", "updata_hero_press.png"}, 180, 650,{callback = function() HTTPS:send("Book", {book = "open", a = "book", m = "book"}, {success_callback = function(data)
					local legal 
					for k, v in pairs(DATA_Book:get()["hero"]) do
						if v.id ~= DATA_User:get("icon_id") then
							legal = true
							break
						end
					end
					if legal then
						self:show()
					else
						Dialog.tip("没有更多的头像可选择，请在商城购买英雄吧")
					end
				end}) end})
	self.mainlayer:addChild(back:getLayer())
	
	self.layer:addChild(self.mainlayer)
end

function SetLayer:show()
	--更好头像
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	
	if self.showlayer then
		self.layer:removeChild(self.showlayer,true)
	end
	self.showlayer = CCLayer:create()
	
	local tabGroup = RadioGroup:new()
	local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_hero.png", "tab_hero_select.png"}, 12, 721, { 
			callback = function()
				
			end
		},tabGroup)
	self.showlayer:addChild(btn:getLayer())	
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,720)
	self.showlayer:addChild(separator)
	
	tabGroup:chooseByIndex(1,true)
	
	--local select_yes = newSprite(IMG_COMMON.."box_choose.png")
	--self.showlayer:addChild(select_yes)
	local temp = nil
	local book_data = DATA_Book:get()
	temp = book_data["hero"]
	local hero_icon_id = 0
	local selectGroup = RadioGroup:new()
	local sv = ScrollView:new(0,110,480,610,0,false)
	local temp_count = 0
	local temp_line = 1
	local layers = {}
	--local num = 0
	for k,v in pairs(temp) do
		if v["id"] ~= DATA_User:get("icon_id") then
			temp_count = temp_count + 1
			if layers[ temp_line ] == nil then
				layers[ temp_line ] = display.newLayer()
				layers[ temp_line ]:setContentSize( CCSizeMake(480 , 100) )
			end
			local stone 
				stone = Btn:new(IMG_COMMON, {"icon_bg"..v["start"]..".png", "box_choose.png"},  20 + 116 * (temp_count - 1), 0,{
					other = {{IMG_ICON .. "hero/S_"..HeroConfig[v["id"]..""].look..".png",46,46},{IMG_COMMON .. "icon_border"..v["start"]..".png",46,46}},
					noHide = true,
					parent = sv,
					selectZOrder = 20,
					selectOffset = {20, -20},
					selectable = true,
					callback = function()  
						hero_icon_id = v["id"]
					end},selectGroup
				)
				
				
			layers[ temp_line ]:addChild(stone:getLayer())
			
			--if num == 0 then
			--	select_yes:setPosition(stone:getLayer():getPositionX() - 3, 610 - stone:getLayer():getPositionY() - 3)
			--	num = num +1 
			--end
			if temp_count == 4 then
				temp_line = temp_line + 1
				temp_count = 0
			end
		end
	end
	
	for i = 1 , #layers do
		sv:addChild( layers[i] )
	end
	self.showlayer:addChild(sv:getLayer())
	selectGroup:chooseByIndex(1,true)
	
	
	local back = Btn:new(IMG_BTN, {"cancel.png", "cancel_press.png"}, 280, 18,{callback = function() 
		self:main() 
	end})
	self.showlayer:addChild(back:getLayer())
	
	local back = Btn:new(IMG_BTN, {"ok.png", "ok_press.png"}, 70, 18,{callback = function() 
		if hero_icon_id ~= 0 then
			HTTPS:send("Battle", {a = "battle", m = "battle",battle = "seticon", icon_id = hero_icon_id}, {success_callback=
										function()
											self:main()
										end
									})
		end
		
	end})
	self.showlayer:addChild(back:getLayer())
	
	self.layer:addChild(self.showlayer)
	
	
end

function SetLayer:getLayer()
	return self.layer
end


return SetLayer
