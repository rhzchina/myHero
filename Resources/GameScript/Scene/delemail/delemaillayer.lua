local PATH = IMG_SCENE.."mailbox/"


local sendMailLayer = {
	layer,
	account
}

function sendMailLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite("images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(PATH.."title.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	
	--for i = 0,2 do
		local title_font = newSprite(PATH.."title_box_2.png")
		setAnchPos(title_font, 240, 734, 0.5)
		this.layer:addChild(title_font)
	--end
	
	local title_font_text = display.strokeLabel(data["title"],220,744,20)
	this.layer:addChild(title_font_text)
	
	
	local text, line = createLabel({noFont = true, str = data["content"], size = 24, width = 480, color = ccc3(191,207,18)})
	
	setAnchPos(text,0,710 - (line * 24))
	
	this.layer:addChild(text)
	
	
	local opt = {
			{"dele_m", 10, 23, false, function() 
				HTTPS:send("Mail", {mail = "delect", a = "mail", m = "mail",id=data["id"]}, {success_callback = function(data)
					switchScene("mailbox")
				end})
			end},
			
			{"back_m",238,23,false,function() 
					HTTPS:send("Mail" ,{m="mail",a="mail",mail = "open"} ,{success_callback = 
							function()
								switchScene("mailbox")
							end }) 	
			end}
			}	
			
	local btn = Btn:new(IMG_BTN, {opt[1][1]..".png", opt[1][1].."_press.png"}, opt[1][2], opt[1][3],{callback = opt[1][5]})
	this.layer:addChild(btn:getLayer())
			
	local back_btn = Btn:new(IMG_BTN, {opt[2][1]..".png", opt[2][1].."_press.png"}, opt[2][2], opt[2][3],{callback = opt[2][5]})
	this.layer:addChild(back_btn:getLayer())
	return this
end


function sendMailLayer:getLayer()
	return self.layer
end


return sendMailLayer
