local ITEM = requires(SRC.."Scene/common/ItemInfo")
local Detail = requires(SRC.."Scene/common/CardDetail")

local M = {
	layer,
	listLayer,
	tabGroup
}

function M:create( params )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	local params = params or {}
	
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg, 0, 80)
	this.layer:addChild(bg)
	
	this.tabGroup = RadioGroup:new()
	
	local tabs = {
		{"hero", 1}, 
		{"equip", 2},
		{"skill", 3},
		{"prop", 4}
	}
	
	local x = 12
	for k, v in pairs(tabs) do
		local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 668, { 
			callback = function()
				this:createList(v[1],v[2], params.offset or 0)
			end
		},this.tabGroup)
		this.layer:addChild(btn:getLayer())		
		x = x + btn:getWidth() + 5 
	end
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,667)
	this.layer:addChild(separator)
	
	this.tabGroup:chooseByIndex(params.tab or 1, true)

	this.layer:addChild(InfoLayer:create():getLayer())
	return this.layer
end

function M:createList(kind, tab, offset)
	if self.listLayer then
		self.layer:removeChild(self.listLayer,true)
	end
	self.listLayer = CCLayer:create()
	
	local scroll = ScrollView:new(0,90,480,575,5)
	local temp
	for k, v in pairs(DATA_Bag:get(kind)) do
		local item, optBtn 
		local callback, optCallback
		if kind ~= "prop" then
			callback = function()
				self.layer:addChild(Detail:new(kind,v["cid"]):getLayer(),1)
			end
			optCallback = function()
				if kind == "hero" then
					HTTPS:send("Strong", {a = "hero", m = "strong", 
						strong = "hero_get", 
						id = v["id"],
						cid = v["cid"]},{
						success_callback = function(rec)
							switchScene("update", {kind = kind, cid = v["cid"], data = rec})	
						end})
				elseif kind == "equip" then
					HTTPS:send("Strong", {
						strong = "equip_get",
						m = "strong", 
						a = "equip",
						cid = v["cid"],
						id = v["id"]
						},{success_callback = function(value)
							switchScene("update", {kind = "equip", tab = 2, cid = v["cid"], value = value})
						end})
				end
			end
			optBtn = "strength"
		else
			optBtn = "use"
			optCallback = function()	
				HTTPS:send("Shop", {a = "shop", m = "shop", 
					shop = "open",
					type = getBag("prop", item:getId(), "types"), 
					id = getBag("prop", item:getId(), "id")	,
					cid = item:getId()
				},{success_callback = function()
					switchScene("bag",{tab = tab,offset = scroll:getOffset()}, function()
						Dialog.tip("道具使用成功")
					end)
				end})
				print(item:getId(),getBag("prop", item:getId(), "exps"))
			end
		end
		item = ITEM:new(kind,v["cid"],{
			parent = scroll,	
			type = "bag",
			btn = optBtn,
			iconCallback = callback,
			optCallback =  optCallback
		})
		scroll:addChild(item:getLayer(),item)
	end 
	scroll:alignCenter()
	scroll:setOffset(offset or 0)
	self.listLayer:addChild(scroll:getLayer())
	self.layer:addChild(self.listLayer)
end

return M
