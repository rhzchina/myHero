KNTextField={}
KNTextField._index=KNTextField
function KNTextField:new(str,x,y,width,height,tyep,param)
	local this={}
	setmetatable(this,KNTextField)
	
	this.str=str or ""
	this.x=x or 0
	this.y=y or 0
	this.width=width or 100
	this.height=height or 20
	
	if(isset(param,"FontSize")) then this.FontSize=param.Fonsize else this.FontSize=14 end
	if(isset(param,"FontFace")) then this.FontFace=param.FontFace else this.FontFace="Arial" end
	if(isset(param,"FontColor")) then this.FontColor=param.FontColor else this.FontColor=cc3(0,0,255)end
	
	local textField=CCLabelTTF:create(this.str,this.FontFace,this.FontSize)
	
	--描边
	function KNTextField:setStroke()
		
	end
	--阴影
	function KNTextField:setShadow()
	
	end
	--发光
	function KNTextField:setGlow()
	
	end
	return textField
end