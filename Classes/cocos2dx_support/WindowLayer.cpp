#include "WindowLayer.h"
WindowLayer* WindowLayer::createWindow(){
	WindowLayer* layer = new WindowLayer();
	if(layer && layer->init()){
		layer->scaleX = CCEGLView::sharedOpenGLView()->getScaleX();
		layer->scaleY = CCEGLView::sharedOpenGLView()->getScaleY();
		layer->autorelease();
		return layer;

	}
	CC_SAFE_DELETE(layer);
	return NULL;

}


void WindowLayer::visit(){
	glEnable(GL_SCISSOR_TEST);  
	glScissor(m_tPosition.x * scaleX - m_tContentSize.width * m_tAnchorPoint.x,
		m_tPosition.y * scaleY- m_tContentSize.height * m_tAnchorPoint.y,
		m_tContentSize.width * scaleX,
		m_tContentSize.height * scaleY);  
	CCLayerColor::visit();
	glDisable(GL_SCISSOR_TEST);		
	//对窗口中的元素进行检测，若超出可显示范围则置为不可见
	CCNode* content =(CCNode*) getChildren()->objectAtIndex(0);
	if(content){
		CCRect showRect = CCRectMake(m_tPosition.x * scaleX ,m_tPosition.y * scaleY,m_tContentSize.width * scaleX,m_tContentSize.height * scaleY);
		CCRect itemRect;
		CCArray* items = content->getChildren();
		if(items != NULL){
			int n = items->count();
			CCNode* item = NULL;
			for(int i = 0;i < n;i++){
				item = (CCNode*)items->objectAtIndex(i);
				itemRect = CCRectMake(item->getPositionX() * scaleX + content->getPositionX() * scaleX + m_tPosition.x * scaleX,
					item->getPositionY() *scaleY + content->getPositionY()* scaleY + m_tPosition.y * scaleY,
					item->getContentSize().width * scaleX,item->getContentSize().height * scaleY);
				if(showRect.intersectsRect(itemRect)){
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
//	#endife