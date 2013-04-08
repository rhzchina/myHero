#include "cocos2d.h"
#include "CTTableView.h"

const static float DELTA = 5.0f;
CTTableView* CTTableView::create(CTTableViewDataSource* dataSource, CCSize size)
{
    return CTTableView::create(dataSource, size, NULL);
}

CTTableView* CTTableView::create(CTTableViewDataSource* dataSource, CCSize size, CCNode *container)
{
    CTTableView *table = new CTTableView();
    table->initWithViewSize(size, container);
    table->autorelease();
    table->setDataSource(dataSource);
    table->_updateContentSize();

    return table;
}

bool CTTableView::initWithViewSize(CCSize size, CCNode* container/* = NULL*/)
{
    if (CTScrollView::initWithViewSize(size,container))
    {
        m_pCellsUsed      = new CCArrayForObjectSorting();
        m_pCellsFreed     = new CCArrayForObjectSorting();
        m_pIndices        = new std::set<unsigned int>();
        m_pTableViewDelegate = NULL;
        m_eVordering      = kCTTableViewFillBottomUp;
        this->setDirection(kCCScrollViewDirectionVertical);
        
        CTScrollView::setDelegate(this);
        return true;
    }
    return false;
}

CTTableView::CTTableView()
: m_pIndices(NULL)
, m_pCellsUsed(NULL)
, m_pCellsFreed(NULL)
, m_pDataSource(NULL)
, m_pTableViewDelegate(NULL)
, m_eOldDirection(kCCScrollViewDirectionNone)
{

}

CTTableView::~CTTableView()
{
    CC_SAFE_DELETE(m_pIndices);
    CC_SAFE_RELEASE(m_pCellsUsed);
    CC_SAFE_RELEASE(m_pCellsFreed);
}

void CTTableView::setVerticalFillOrder(CTTableViewVerticalFillOrder fillOrder)
{
    if (m_eVordering != fillOrder) {
        m_eVordering = fillOrder;
        if (m_pCellsUsed->count() > 0) {
            this->reloadData();
        }
    }
}

CTTableViewVerticalFillOrder CTTableView::getVerticalFillOrder()
{
    return m_eVordering;
}

void CTTableView::MoveBy(float fDistance)
{
	return CTScrollView::MoveBy(fDistance);
}
void CTTableView::reloadData()
{
    CCObject* pObj = NULL;
    CCARRAY_FOREACH(m_pCellsUsed, pObj)
    {
        CCTableViewCell* cell = (CCTableViewCell*)pObj;
        m_pCellsFreed->addObject(cell);
        cell->reset();
        if (cell->getParent() == this->getContainer())
        {
            this->getContainer()->removeChild(cell, true);
        }
    }

    m_pIndices->clear();
    m_pCellsUsed->release();
    m_pCellsUsed = new CCArrayForObjectSorting();
    
    this->_updateContentSize();
    if (m_pDataSource->numberOfCellsInTableView(this) > 0)
    {
        this->scrollViewDidScroll(this);
    }
}

CCTableViewCell *CTTableView::cellAtIndex(unsigned int idx)
{
    return this->_cellWithIndex(idx);
}

void CTTableView::updateCellAtIndex(unsigned int idx)
{
    if (idx == CC_INVALID_INDEX || idx > m_pDataSource->numberOfCellsInTableView(this)-1)
    {
        return;
    }
    
    CCTableViewCell *cell;
    
    cell = this->_cellWithIndex(idx);
    if (cell) {
        this->_moveCellOutOfSight(cell);
    } 
    cell = m_pDataSource->tableCellAtIndex(this, idx);
    this->_setIndexForCell(idx, cell);
    this->_addCellIfNecessary(cell);
}

void CTTableView::insertCellAtIndex(unsigned  int idx)
{
    if (idx == CC_INVALID_INDEX || idx > m_pDataSource->numberOfCellsInTableView(this)-1) {
        return;
    }
    CCTableViewCell *cell;
    int newIdx;
    
    cell = (CCTableViewCell*)m_pCellsUsed->objectWithObjectID(idx);
    if (cell) 
    {
        newIdx = m_pCellsUsed->indexOfSortedObject(cell);
        for (unsigned int i=newIdx; i<m_pCellsUsed->count(); i++)
        {
            cell = (CCTableViewCell*)m_pCellsUsed->objectAtIndex(i);
            this->_setIndexForCell(cell->getIdx()+1, cell);
        }
    }
    
 //   [m_pIndices shiftIndexesStartingAtIndex:idx by:1];
    
    //insert a new cell
    cell = m_pDataSource->tableCellAtIndex(this, idx);
    this->_setIndexForCell(idx, cell);
    this->_addCellIfNecessary(cell);
    
    this->_updateContentSize();
}

void CTTableView::removeCellAtIndex(unsigned int idx)
{
    if (idx == CC_INVALID_INDEX || idx > m_pDataSource->numberOfCellsInTableView(this)-1) {
        return;
    }
    
    CCTableViewCell   *cell;
    unsigned int newIdx;
    
    cell = this->_cellWithIndex(idx);
    if (!cell) {
        return;
    }
    
    newIdx = m_pCellsUsed->indexOfSortedObject(cell);
    
    //remove first
    this->_moveCellOutOfSight(cell);
    
    m_pIndices->erase(idx);
//    [m_pIndices shiftIndexesStartingAtIndex:idx+1 by:-1];
    for (unsigned int i=m_pCellsUsed->count()-1; i > newIdx; i--) {
        cell = (CCTableViewCell*)m_pCellsUsed->objectAtIndex(i);
        this->_setIndexForCell(cell->getIdx()-1, cell);
    }
}

CCTableViewCell *CTTableView::dequeueCell()
{
    CCTableViewCell *cell;
    
    if (m_pCellsFreed->count() == 0) {
        cell = NULL;
    } else {
        cell = (CCTableViewCell*)m_pCellsFreed->objectAtIndex(0);
        cell->retain();
        m_pCellsFreed->removeObjectAtIndex(0);
        cell->autorelease();
    }
    return cell;
}

void CTTableView::_addCellIfNecessary(CCTableViewCell * cell)
{
    if (cell->getParent() != this->getContainer())
    {
        this->getContainer()->addChild(cell);
    }
    m_pCellsUsed->insertSortedObject(cell);
    m_pIndices->insert(cell->getIdx());
    // [m_pIndices addIndex:cell.idx];
}

void CTTableView::_updateContentSize()
{
    CCSize     size, cellSize;
    unsigned int cellCount;

    cellSize  = m_pDataSource->cellSizeForTable(this);
    cellCount = m_pDataSource->numberOfCellsInTableView(this);
    
    switch (this->getDirection())
    {
        case kCCScrollViewDirectionHorizontal:
            size = CCSizeMake(cellCount * cellSize.width, cellSize.height);
            break;
        default:
            size = CCSizeMake(cellSize.width, cellCount * cellSize.height);
            break;
    }
    this->setContentSize(size);

	if (m_eOldDirection != m_eDirection)
	{
		if (m_eDirection == kCCScrollViewDirectionHorizontal)
		{
			this->setContentOffset(ccp(0,0));
		}
		else
		{
			this->setContentOffset(ccp(0,this->minContainerOffset().y));
		}
		m_eOldDirection = m_eDirection;
	}

}

CCPoint CTTableView::_offsetFromIndex(unsigned int index)
{
    CCPoint offset = this->__offsetFromIndex(index);
    
    const CCSize cellSize = m_pDataSource->cellSizeForTable(this);
    if (m_eVordering == kCTTableViewFillTopDown) {
        offset.y = this->getContainer()->getContentSize().height - offset.y - cellSize.height;
    }
    return offset;
}

CCPoint CTTableView::__offsetFromIndex(unsigned int index)
{
    CCPoint offset;
    CCSize  cellSize;
    
    cellSize = m_pDataSource->cellSizeForTable(this);
    switch (this->getDirection()) {
        case kCCScrollViewDirectionHorizontal:
            offset = ccp(cellSize.width * index, 0.0f);
            break;
        default:
            offset = ccp(0.0f, cellSize.height * index);
            break;
    }
    
    return offset;
}

unsigned int CTTableView::_indexFromOffset(CCPoint offset)
{
    int index = 0;
    const int maxIdx = m_pDataSource->numberOfCellsInTableView(this)-1;

    const CCSize cellSize = m_pDataSource->cellSizeForTable(this);
    if (m_eVordering == kCTTableViewFillTopDown) {
        offset.y = this->getContainer()->getContentSize().height - offset.y - cellSize.height;
    }
    index = MAX(0, this->__indexFromOffset(offset));
    index = MIN(index, maxIdx);

    return index;
}

int CTTableView::__indexFromOffset(CCPoint offset)
{
    int  index = 0;
    CCSize     cellSize;
    
    cellSize = m_pDataSource->cellSizeForTable(this);
    
    switch (this->getDirection()) {
        case kCCScrollViewDirectionHorizontal:
            index = offset.x/cellSize.width;
            break;
        default:
            index = offset.y/cellSize.height;
            break;
    }
    
    return index;
}

CCTableViewCell* CTTableView::_cellWithIndex(unsigned int cellIndex)
{
    CCTableViewCell *found;
    
    found = NULL;
    
//     if ([m_pIndices containsIndex:cellIndex])
    if (m_pIndices->find(cellIndex) != m_pIndices->end())
    {
        found = (CCTableViewCell *)m_pCellsUsed->objectWithObjectID(cellIndex);
    }
    
    return found;
}

void CTTableView::_moveCellOutOfSight(CCTableViewCell *cell)
{
    m_pCellsFreed->addObject(cell);
    m_pCellsUsed->removeSortedObject(cell);
    m_pIndices->erase(cell->getIdx());
    // [m_pIndices removeIndex:cell.idx];
    cell->reset();
    if (cell->getParent() == this->getContainer()) {
        this->getContainer()->removeChild(cell, true);
    }
}

void CTTableView::_setIndexForCell(unsigned int index, CCTableViewCell *cell)
{
    cell->setAnchorPoint(ccp(0.0f, 0.0f));
    cell->setPosition(this->_offsetFromIndex(index));
    cell->setIdx(index);
}

void CTTableView::scrollViewDidScroll(CCScrollView* view)
{
    unsigned int startIdx = 0, endIdx = 0, idx = 0, maxIdx = 0;
    CCPoint offset;

    offset   = ccpMult(this->getContentOffset(), -1);
    maxIdx   = MAX(m_pDataSource->numberOfCellsInTableView(this)-1, 0);
    
    const CCSize cellSize = m_pDataSource->cellSizeForTable(this);
    
    if (m_eVordering == kCTTableViewFillTopDown) {
        offset.y = offset.y + m_tViewSize.height/this->getContainer()->getScaleY() - cellSize.height;
    }
    startIdx = this->_indexFromOffset(offset);
    
    if (m_eVordering == kCTTableViewFillTopDown)
    {
        offset.y -= m_tViewSize.height/this->getContainer()->getScaleY();
    }
    else 
    {
        offset.y += m_tViewSize.height/this->getContainer()->getScaleY();
    }
    offset.x += m_tViewSize.width/this->getContainer()->getScaleX();
    
    endIdx   = this->_indexFromOffset(offset);   
    
#if 0 // For Testing.
    CCObject* pObj;
    int i = 0;
    CCARRAY_FOREACH(m_pCellsUsed, pObj)
    {
        CCTableViewCell* pCell = (CCTableViewCell*)pObj;
        CCLog("cells Used index %d, value = %d", i, pCell->getIdx());
        i++;
    }
    CCLog("---------------------------------------");
    i = 0;
    CCARRAY_FOREACH(m_pCellsFreed, pObj)
    {
        CCTableViewCell* pCell = (CCTableViewCell*)pObj;
        CCLog("cells freed index %d, value = %d", i, pCell->getIdx());
        i++;
    }
    CCLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
#endif
    
    if (m_pCellsUsed->count() > 0)
    {
        CCTableViewCell* cell = (CCTableViewCell*)m_pCellsUsed->objectAtIndex(0);

        idx = cell->getIdx();
        while(idx <startIdx)
        {
            this->_moveCellOutOfSight(cell);
            if (m_pCellsUsed->count() > 0)
            {
                cell = (CCTableViewCell*)m_pCellsUsed->objectAtIndex(0);
                idx = cell->getIdx();    
            }
            else
            {
                break;
            }
        }
    }
    if (m_pCellsUsed->count() > 0)
    {
        CCTableViewCell *cell = (CCTableViewCell*)m_pCellsUsed->lastObject();
        idx = cell->getIdx();

        while(idx <= maxIdx && idx > endIdx)
        {
            this->_moveCellOutOfSight(cell);
            if (m_pCellsUsed->count() > 0)
            {
                cell = (CCTableViewCell*)m_pCellsUsed->lastObject();
                idx = cell->getIdx();
                
            }
            else
            {
                break;
            }
        }
    }
    
    for (unsigned int i=startIdx; i <= endIdx; i++)
    {
        //if ([m_pIndices containsIndex:i])
        if (m_pIndices->find(i) != m_pIndices->end())
        {
            continue;
        }
        this->updateCellAtIndex(i);
    }
}

void CTTableView::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
    if (!this->isVisible()) {
        return;
    }
    if (m_pTouches->count() == 1 && !this->isTouchMoved()) {
        unsigned int        index;
        CCTableViewCell   *cell;
        CCPoint           point;
        
        point = this->getContainer()->convertTouchToNodeSpace(pTouch);
        if (m_eVordering == kCTTableViewFillTopDown) {
            CCSize cellSize = m_pDataSource->cellSizeForTable(this);
            point.y -= cellSize.height;
        }
        index = this->_indexFromOffset(point);
        cell  = this->_cellWithIndex(index);
        
        if (cell) {
            m_pTableViewDelegate->tableCellTouched(this, cell);
        }
    }
    CTScrollView::ccTouchEnded(pTouch, pEvent);
}

bool CTTableView::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{   
	m_beginPos = pTouch->getLocationInView();
	m_beginPos = CCDirector::sharedDirector()->convertToGL(m_beginPos);
    return CTScrollView::ccTouchBegan(pTouch,pEvent);
}
void CTTableView::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
	CCPoint ptCurrent;
	ptCurrent = pTouch->getLocationInView();
	ptCurrent = CCDirector::sharedDirector()->convertToGL(ptCurrent);
	if (abs(ptCurrent.x-m_beginPos.x) < DELTA && abs(ptCurrent.y-m_beginPos.y) < DELTA)
	{
		CCLog("ddd return!!");
		return;
	}
	
	return CTScrollView::ccTouchMoved(pTouch,pEvent);
}