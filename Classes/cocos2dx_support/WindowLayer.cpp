#include "WindowLayer.h"

WindowLayer* WindowLayer::createWindow(){
	WindowLayer* layer = new WindowLayer();
	//if(layer && layer->initWithColor(ccc4(100,100,100,255))){
	if(layer && layer->init()){
		layer->scaleX = CCEGLView::sharedOpenGLView()->getScaleX();
		layer->scaleY = CCEGLView::sharedOpenGLView()->getScaleY();
		layer->autorelease();
		return layer;
	}	
	CC_SAFE_DELETE(layer);
	return NULL;

}

void WindowLayer::showRect(){
	float x = m_tPosition.x;
	float y = m_tPosition.y;

	if(!m_bIgnoreAnchorPointForPosition){
		x -= m_tContentSize.width * m_tAnchorPoint.x; 
		y -= m_tContentSize.height * m_tAnchorPoint.y;
	}

	CCNode* parent = this->getParent();
	while(parent != NULL){
		if(!parent->isIgnoreAnchorPointForPosition()){
			x = x + parent->getPositionX() - parent->getContentSize().width * parent->getAnchorPoint().x;
			y = y + parent->getPositionY() - parent->getContentSize().height * parent->getAnchorPoint().y;
			
		}else{
			x = x + parent->getPositionX();
			y = y + parent->getPositionY();
		}
		parent = parent->getParent();
	}
	this->rect =  CCRectMake(x * scaleX, y * scaleY, m_tContentSize.width * scaleX, m_tContentSize.height * scaleY);

}
	
void WindowLayer::visit(){
	this->showRect();

	glEnable(GL_SCISSOR_TEST);  

	glScissor(this->rect.getMinX(), this->rect.getMinY(), this->rect.getMaxX() - this->rect.getMinX(), this->rect.getMaxY() - this->rect.getMinY());
	CCLayerColor::visit();
	glDisable(GL_SCISSOR_TEST);		
	//对窗口中的元素进行检测，若超出可显示范围则置为不可见
	CCNode* content =(CCNode*) getChildren()->objectAtIndex(0);
	if(false){
		CCRect itemRect;
		CCArray* items = content->getChildren();
		if(items != NULL){
			int n = items->count();
			CCNode* item = NULL;
			for(int i = 0;i < n;i++){
				item = (CCNode*)items->objectAtIndex(i);
				itemRect = CCRectMake((item->getPositionX() + content->getPositionX()) * scaleX + this->rect.getMinX(),
					(item->getPositionY() + content->getPositionY()) * scaleY + this->rect.getMinY(),
					item->getContentSize().width * scaleX,item->getContentSize().height * scaleY);
				if(this->rect.intersectsRect(itemRect)){
					item->setVisible(true);
				}else{
					item->setVisible(false);
				}
			}
		}
	}
}

////这里是在win32平台将使用的字体替换为对应字体
//	#ifdef WIN32
//	 int len = MultiByteToWideChar(CP_UTF8, 0, fontName, -1, NULL, 0);
//	  wchar_t* wstr = new wchar_t[len+1];
//	  memset(wstr, 0, len+1);
//	  MultiByteToWideChar(CP_UTF8, 0, fontName, -1, wstr, len);
//	  len = WideCharToMultiByte(CP_ACP, 0, wstr, -1, NULL, 0, NULL, NULL);
//	  char* temp = new char[len+1];
//	  memset(temp, 0, len+1);
//	  WideCharToMultiByte(CP_ACP, 0, wstr, -1, temp, len, NULL, NULL);
//	  if(wstr) delete[] wstr;
//	  fontName = temp;	
//	#endif