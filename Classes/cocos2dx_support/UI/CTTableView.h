#ifndef __CTTableView_h__
#define __CTTableView_h__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "CTScrollView.h"
#include <set>

USING_NS_CC;
USING_NS_CC_EXT;
class CTTableView;
class CCScrollView;
typedef enum {
    kCTTableViewFillTopDown,
    kCTTableViewFillBottomUp
} CTTableViewVerticalFillOrder;

/**
 * Sole purpose of this delegate is to single touch event in this version.
 */
class CTTableViewDelegate : public CCScrollViewDelegate
{
public:
    /**
     * Delegate to respond touch event
     *
     * @param table table contains the given cell
     * @param cell  cell that is touched
     */
    virtual void tableCellTouched(CTTableView* table, CCTableViewCell* cell) = 0;
};


/**
 * Data source that governs table backend data.
 */
class CTTableViewDataSource
{
public:
    /**
     * cell height for a given table.
     *
     * @param table table to hold the instances of Class
     * @return cell size
     */
    virtual CCSize cellSizeForTable(CTTableView *table) = 0;
    /**
     * a cell instance at a given index
     *
     * @param idx index to search for a cell
     * @return cell found at idx
     */
    virtual CCTableViewCell* tableCellAtIndex(CTTableView *table, unsigned int idx) = 0;
    /**
     * Returns number of cells in a given table view.
     * 
     * @return number of cells
     */
    virtual unsigned int numberOfCellsInTableView(CTTableView *table) = 0;

};


/**
 * UITableView counterpart for cocos2d for iphone.
 *
 * this is a very basic, minimal implementation to bring UITableView-like component into cocos2d world.
 * 
 */
class CTTableView : public CTScrollView, public CCScrollViewDelegate
{
public:
    CTTableView();
    virtual ~CTTableView();
	void MoveBy(float fDistance);
    /**
     * An intialized table view object
     *
     * @param dataSource data source
     * @param size view size
     * @return table view
     */
    static CTTableView* create(CTTableViewDataSource* dataSource, CCSize size);
    /**
     * An initialized table view object
     *
     * @param dataSource data source;
     * @param size view size
     * @param container parent object for cells
     * @return table view
     */
    static CTTableView* create(CTTableViewDataSource* dataSource, CCSize size, CCNode *container);
    
    /**
     * data source
     */
    CTTableViewDataSource* getDataSource() { return m_pDataSource; }
    void setDataSource(CTTableViewDataSource* source) { m_pDataSource = source; }
    /**
     * delegate
     */
    CTTableViewDelegate* getDelegate() { return m_pTableViewDelegate; } 
    void setDelegate(CTTableViewDelegate* pDelegate) { m_pTableViewDelegate = pDelegate; }

    /**
     * determines how cell is ordered and filled in the view.
     */
    void setVerticalFillOrder(CTTableViewVerticalFillOrder order);
    CTTableViewVerticalFillOrder getVerticalFillOrder();


    bool initWithViewSize(CCSize size, CCNode* container = NULL);
    /**
     * Updates the content of the cell at a given index.
     *
     * @param idx index to find a cell
     */
    void updateCellAtIndex(unsigned int idx);
    /**
     * Inserts a new cell at a given index
     *
     * @param idx location to insert
     */
    void insertCellAtIndex(unsigned int idx);
    /**
     * Removes a cell at a given index
     *
     * @param idx index to find a cell
     */
    void removeCellAtIndex(unsigned int idx);
    /**
     * reloads data from data source.  the view will be refreshed.
     */
    void reloadData();
    /**
     * Dequeues a free cell if available. nil if not.
     *
     * @return free cell
     */
    CCTableViewCell *dequeueCell();

    /**
     * Returns an existing cell at a given index. Returns nil if a cell is nonexistent at the moment of query.
     *
     * @param idx index
     * @return a cell at a given index
     */
    CCTableViewCell *cellAtIndex(unsigned int idx);


    virtual void scrollViewDidScroll(CCScrollView* view);
    virtual void scrollViewDidZoom(CCScrollView* view) {}
	virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
    virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);

protected:
    
    /**
     * vertical direction of cell filling
     */
    CTTableViewVerticalFillOrder m_eVordering;
    
    /**
     * index set to query the indexes of the cells used.
     */
    std::set<unsigned int>* m_pIndices;
    //NSMutableIndexSet *indices_;
    /**
     * cells that are currently in the table
     */
    CCArrayForObjectSorting* m_pCellsUsed;
    /**
     * free list of cells
     */
    CCArrayForObjectSorting* m_pCellsFreed;
    /**
     * weak link to the data source object
     */
    CTTableViewDataSource* m_pDataSource;
    /**
     * weak link to the delegate object
     */
    CTTableViewDelegate* m_pTableViewDelegate;

	CCScrollViewDirection m_eOldDirection;

    int __indexFromOffset(CCPoint offset);
    unsigned int _indexFromOffset(CCPoint offset);
    CCPoint __offsetFromIndex(unsigned int index);
    CCPoint _offsetFromIndex(unsigned int index);
    void _updateContentSize();

    CCTableViewCell* _cellWithIndex(unsigned int cellIndex);
    void _moveCellOutOfSight(CCTableViewCell *cell);
    void _setIndexForCell(unsigned int index, CCTableViewCell *cell);
    void _addCellIfNecessary(CCTableViewCell * cell);
public:
	CCPoint m_beginPos;
};


#endif /* __CCTABLEVIEW_H__ */

