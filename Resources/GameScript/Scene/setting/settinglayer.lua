local PATH = IMG_SCENE.."set/"
local SetLayer = {
	layer,
	mainlayer,
	showlayer
}

function SetLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite("images/common/menu_bg.png")
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
	
	for i = 0,2 do
		local block = newSprite(PATH.."block.png")
		setAnchPos(block, 0, 620 - i * 160)
		self.mainlayer:addChild(block)
	end
	
	local stone = Btn:new(IMG_COMMON, {"icon_bg"..DATA_User:get("icon_start")..".png", "icon_bg"..DATA_User:get("icon_start")..".png"},  20 , 635,{
				other = {{IMG_ICON .. "hero/s_"..DATA_User:get("icon_id")..".png",46,46},{IMG_COMMON .. "icon_border"..DATA_User:get("icon_start")..".png",46,46}},
				callback = function()  
					
				end}
			)
	self.mainlayer:addChild(stone:getLayer())
	
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() switchScene("menu") end})
	self.mainlayer:addChild(back:getLayer())
	
	local sound = newSprite(PATH.."sound.png")
	setAnchPos(sound, 60, 315)
	self.mainlayer:addChild(sound)
	
	local audio = newSprite(PATH.."audio.png")
	setAnchPos(audio, 60, 470)
	self.mainlayer:addChild(audio)
	
	--sound 开，关按钮
	local open_btn = Btn:new(IMG_BTN, {"open.png", "open_press.png", "open_press.png"}, 190, 337,{callback = function() end})
	self.mainlayer:addChild(open_btn:getLayer())
	
	local close_btn = Btn:new(IMG_BTN, {"close.png", "close_press.png", "close_press.png"}, 300, 337,{callback = function() end})
	self.mainlayer:addChild(close_btn:getLayer())
	
	--audio 开，关按钮
	local open_btn = Btn:new(IMG_BTN, {"open.png", "open_press.png", "open_press.png"}, 190, 492,{callback = function() end})
	self.mainlayer:addChild(open_btn:getLayer())
	
	local close_btn = Btn:new(IMG_BTN, {"close.png", "close_press.png", "close_press.png"}, 300, 492,{callback = function() end})
	self.mainlayer:addChild(close_btn:getLayer())  	
	
	local back = Btn:new(IMG_BTN, {"updata_hero.png", "updata_hero_press.png"}, 180, 650,{callback = function() HTTPS:send("Book", {book = "open", a = "book", m = "book"}, {success_callback = function(data)
					self:show()
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
	
	local temp = nil
	local book_data = DATA_Book:get()
	temp = book_data["hero"]
	
	local sv = ScrollView:new(0,110,480,610,0,false)
	local temp_count = 0
	local temp_line = 1
	local layers = {}
	for k,v in pairs(temp) do
		temp_count = temp_count + 1
		if layers[ temp_line ] == nil then
			layers[ temp_line ] = display.newLayer()
			layers[ temp_line ]:setContentSize( CCSizeMake(480 , 100) )
		end
		local stone 
			
			stone = Btn:new(IMG_COMMON, {"icon_bg"..v["start"]..".png", "icon_bg"..v["start"]..".png"},  20 + 116 * (temp_count - 1), 0,{
			other = {{IMG_ICON .. "hero/S_"..v["id"]..".png",46,46},{IMG_COMMON .. "icon_border"..v["start"]..".png",46,46}},
			callback = function()  
				
			end}
			)
			
			
		layers[ temp_line ]:addChild(stone:getLayer())
		if temp_count == 4 then
			temp_line = temp_line + 1
			temp_count = 0
		end
	end
	
	for i = 1 , #layers do
		sv:addChild( layers[i] )
	end
	self.showlayer:addChild(sv:getLayer())
	
	
	
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() self:main() end})
	self.showlayer:addChild(back:getLayer())
	
	self.layer:addChild(self.showlayer)
end

function SetLayer:getLayer()
	return self.layer
end


return SetLayer
