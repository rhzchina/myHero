local PATH = CONFIG_PATH
local Detail = require(SRC.."Scene/common/CardDetail")

local Illustrlayer = {
	layer,
	tabGroup,
	listLayer
}

function Illustrlayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite("images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(IMG_TEXT.."card.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	
	this.tabGroup = RadioGroup:new()
	local tabs = {
		{"hero", 1},
		{"wuqi", 2},
		{"def", 3},
		{"shipin", 4},
		{"miji", 5},
	}
	local x = 12
	for k, v in pairs(tabs) do
		local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 721, { 
			callback = function()
				this:createList(v[2])
			end
		},this.tabGroup)
		this.layer:addChild(btn:getLayer())		
		x = x + btn:getWidth() + 5 
	end
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,720)
	this.layer:addChild(separator)
	
	this.tabGroup:chooseByIndex(1,true)
	
	
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() switchScene("menu") end})
	this.layer:addChild(back:getLayer())
	
	return this
end

function Illustrlayer:createList(kind)
	if self.listLayer then
		self.layer:removeChild(self.listLayer,true)
	end
	self.listLayer = CCLayer:create()
	local data = nil
	local temp = nil
	local obj = {}
	local temp_line = 1
	local temp_count = 0
	if kind == 1 then
		data = require(PATH.."HeroConfig")
		local book_data = DATA_Book:get()
		temp = book_data["hero"]
	elseif kind == 2 then
		data = require(PATH.."ArmConfig")
		local arm_data = {}
		local index = 1
		local book_data = DATA_Book:get()
		local equip = book_data["equip"]
		for k,v in pairs(equip)do
			if tonumber(v["id"]) /1000 >= 6 and tonumber(v["id"]) /1000 < 7 then
				arm_data[v["id"]] = v
			end
		end
		temp = arm_data
	elseif kind == 3 then
		data = require(PATH.."ArmourConfig")
		local arm_data = {}
		local index = 1
		local book_data = DATA_Book:get()
		local equip = book_data["equip"]
		for k,v in pairs(equip)do
			if tonumber(v["id"]) /1000 >= 5 and tonumber(v["id"]) /1000 < 6 then
				arm_data[v["id"]] = v
			end
		end
		temp = arm_data
	elseif kind == 4 then
		data = require(PATH.."OrnamentConfig")
		local arm_data = {}
		local index = 1
		local book_data = DATA_Book:get()
		local equip = book_data["equip"]
		for k,v in pairs(equip)do
			if tonumber(v["id"]) /1000 >= 7 and tonumber(v["id"]) /1000 < 8 then
				arm_data[v["id"]] = v
			end
		end
		temp = arm_data
	elseif kind == 5 then
		data = require(PATH.."SkillConfig")
		local book_data = DATA_Book:get()
		temp = book_data["skill"]
	end
	
	for k,v in pairs(data) do
		local is_true = false
		local hero_start = 0
		local hero_cid = 0
		for k1,v1 in pairs(temp)do
			if tonumber(v["id"]) == tonumber(v1["id"]) then
				is_true = true
				hero_start = v1["start"]
				hero_cid = v1["id"]
			end
		end
		local get_data = {}
		if is_true == true then
			get_data["id"] = v["id"]
			get_data["is"] = 1
			get_data["start"] = hero_start
			get_data["cid"] = hero_cid
			
			if kind == 1 then
				get_data["type"] = "hero"
				get_data["path"] = "hero/S_"
				get_data["info"] = "hero"
			elseif kind == 2 then
				get_data["type"] = "wuqi"
				get_data["path"] = "equip/S_"
				get_data["info"] = "equip"
			elseif kind == 3 then
				get_data["type"] = "def"
				get_data["path"] = "equip/S_"
				get_data["info"] = "equip"
			elseif kind == 4 then
				get_data["type"] = "shipin"
				get_data["path"] = "equip/S_"
				get_data["info"] = "equip"
			elseif kind == 5 then
				get_data["type"] = "miji"
				get_data["path"] = "skill/S_"
				get_data["info"] = "skill"
			end
			
			obj[temp_line] = get_data
		else
			get_data["id"] = v["id"]
			get_data["is"] = 0
			get_data["start"] = v["start"]
			obj[temp_line] = get_data
		end
		temp_line = temp_line + 1
	end
		
		
	local sv = ScrollView:new(0,120,480,600,0,false)
	local temp_count = 0
	local temp_line = 1
	local layers = {}
	for k,v in pairs(obj) do
		temp_count = temp_count + 1
		if layers[ temp_line ] == nil then
			layers[ temp_line ] = display.newLayer()
			layers[ temp_line ]:setContentSize( CCSizeMake(480 , 100) )
		end
		local stone 
			if v["is"] == 1 then
				stone = Btn:new(IMG_COMMON, {"icon_bg"..v["start"]..".png", "icon_bg"..v["start"]..".png"},  20 + 116 * (temp_count - 1), 0,{
				other = {{IMG_ICON .. v["path"]..v["id"]..".png",46,46},{IMG_COMMON .. "icon_border"..v["start"]..".png",46,46}},
				callback = function()  
					self.layer:addChild(Detail:new(v["info"],v["id"]):getLayer(),1)
				end}
				)
			else
				stone = Btn:new(IMG_COMMON, {"icon_bg"..v["start"]..".png", "icon_bg"..v["start"]..".png"},  20 + 116 * (temp_count - 1), 0,{
				other = {{IMG_COMMON .. "icon_empty.png",46,46}},
				callback = function()  end})
			end
			
		layers[ temp_line ]:addChild(stone:getLayer())
		if temp_count == 4 then
			temp_line = temp_line + 1
			temp_count = 0
		end
	end
	
	for i = 1 , #layers do
		sv:addChild( layers[i] )
	end
	self.listLayer:addChild(sv:getLayer())
	self.layer:addChild(self.listLayer)

end

function Illustrlayer:getLayer()
	return self.layer
end


return Illustrlayer
