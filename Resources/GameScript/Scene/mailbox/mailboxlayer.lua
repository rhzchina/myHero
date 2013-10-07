local PATH = IMG_SCENE.."mailbox/"


local mailboxLayer = {
	layer
}

function mailboxLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite(IMG_PATH.."images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(PATH.."title.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	local mail_data = DATA_Mail:get()
	--dump(mail_data)
	if _G.next( mail_data ) == nil then
		print("邮箱没有数据")
	else
		--邮箱有数据，排版
		local scroll = ScrollView:new(0,104,480,675,10)
		
		for k,v in pairs(mail_data) do
			local str = v["content"]
			--local num = length(str)
			local num = string.len(str)
			local text = nil
			if num > 30 then
				text = string.sub(str, 0, 30)
			else
				text = string.sub(str, 0, num)
			end
			
			local btns = Btn:new(IMG_BTN, {"mail.png", "mail_press.png"}, 0, 0,{text={{v["title"],18,ccc3(0xff,0xff,0xff), ccp(10,35),1},{text,18,ccc3(0xff,0xff,0xff), ccp(5,5),5}},callback = function() 
				
				switchScene("delemail",v)
			end})
			
			scroll:addChild(btns:getLayer(),btns)
		end
		scroll:alignCenter()
		scroll:setOffset(offset or 0)
		this.layer:addChild(scroll:getLayer())
	end
	
	local opt = {
			{"Appeal", 10, 23, false, function() 					
				switchScene("sendmail")

			end},
			
			{"back_m",238,23,false,function() switchScene("menu") end}
			}	
			
	local btn = Btn:new(IMG_BTN, {opt[1][1]..".png", opt[1][1].."_press.png"}, opt[1][2], opt[1][3],{callback = opt[1][5]})
	this.layer:addChild(btn:getLayer())
			
	local back_btn = Btn:new(IMG_BTN, {opt[2][1]..".png", opt[2][1].."_press.png"}, opt[2][2], opt[2][3],{callback = opt[2][5]})
	this.layer:addChild(back_btn:getLayer())
	
	return this
end

function length(str)

  return #(str.gsub('[\128-\255][\128-\255]',' '))

 end


function mailboxLayer:getLayer()
	return self.layer
end


return mailboxLayer
