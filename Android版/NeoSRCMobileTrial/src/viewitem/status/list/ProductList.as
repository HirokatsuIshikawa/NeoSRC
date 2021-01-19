package viewitem.status.list
{
    import common.CommonDef;
    import database.user.GenericUnitData;
    import main.MainController;
    import scene.base.BaseTip;
    import starling.events.Event;
    import system.custom.customSprite.CButton;
    import system.custom.customSprite.CSprite;
    import viewitem.parts.numbers.ImgNumber;
    import viewitem.status.list.UnitListBase;
    import viewitem.status.list.listitem.GenericOrganizeListItem;
    import viewitem.status.list.listitem.OrganizeSelectIcon;
    
    /**
     * ...
     * @author ishikawa
     */
    public class ProductList extends UnitListBase
    {
        /**暗幕画像*/
        private var _genericItemList:Vector.<GenericOrganizeListItem> = null;
        private var _startBtn:CButton = null;
        private var _closeBtn:CButton = null;
        private var _costCount:ImgNumber = null;
        
        private var _productCallBack:Function = null;
        private var _closeCallBack:Function = null;
        
        private var _baseData:BaseTip = null;
        
        public function ProductList(genericDataList:Vector.<GenericUnitData>, baseData:BaseTip, productCallBack:Function, closeCallBack:Function)
        {
            super();
            var i:int = 0;
            _productCallBack = productCallBack;
            _closeCallBack = closeCallBack;
            _baseData = baseData;
            _genericItemList = new Vector.<GenericOrganizeListItem>;
            
            for (i = 0; i < genericDataList.length; i++)
            {
                //生産フラグは仮
                _genericItemList[i] = new GenericOrganizeListItem(genericDataList[i], MainController.$.map.sideState[0].cost >= 0, selectGenericItem, false);
                _genericItemList[i].x = 60 + (GenericOrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
                _genericItemList[i].y = (GenericOrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
                addChild(_genericItemList[i]);
            }
            
            _startBtn = new CButton();
            _startBtn.label = "出撃";
            _startBtn.styleName = "bigBtn";
            _startBtn.x = 780;
            _startBtn.y = 480;
            _startBtn.width = 120;
            _startBtn.height = 40;
            _startBtn.addEventListener(Event.TRIGGERED, compOrganized);
            _startBtn.isEnabled = false;
            addChild(_startBtn);
            
            _closeBtn = new CButton();
            _closeBtn.label = "閉じる";
            _closeBtn.styleName = "bigBtn";
            _closeBtn.x = 640;
            _closeBtn.y = 480;
            _closeBtn.width = 120;
            _closeBtn.height = 40;
            _closeBtn.addEventListener(Event.TRIGGERED, closeWindow);
            addChild(_closeBtn);
            
            if (MainController.$.map.sideState[0].cost >= 0)
            {
                _costCount = new ImgNumber();
                _costCount.x = 20;
                _costCount.y = CommonDef.WINDOW_H - 96;
                _costCount.setMaxNumber(0, MainController.$.map.sideState[0].cost);
                addChild(_costCount);
            }
            checkItemSelect();
        }
        
        override public function dispose():void
        {
            var i:int = 0;
            
            if (_genericItemList != null)
            {
                for (i = 0; i < _genericItemList.length; i++)
                {
                    removeChild(_genericItemList[i]);
                    _genericItemList[i].dispose();
                    _genericItemList[i] = null;
                }
            }
            
            if (_startBtn != null)
            {
                removeChild(_startBtn);
                _startBtn.removeEventListener(Event.TRIGGERED, closeWindow);
                _startBtn.dispose();
            }
            
            if (_closeBtn != null)
            {
                removeChild(_closeBtn);
                _closeBtn.removeEventListener(Event.TRIGGERED, compOrganized);
                _closeBtn.dispose();
            }
            
            if (_costCount != null)
            {
                removeChild(_costCount);
                _costCount.dispose();
            }
            
            _startBtn = null;
            
            super.dispose();
        }
        
        private function compOrganized(e:Event):void
        {
            //MainController.$.map.startOrganized(_organizeUnitList);
            var i:int = 0;
            var selectNum:int = -1;
            for (i = 0; i < _genericItemList.length; i++)
            {
                if (_genericItemList[i].selected)
                {
                    selectNum = i;
                    break;
                }
            }
            
            if (MainController.$.map.sideState[0].cost >= 0)
            {
                MainController.$.map.sideState[0].cost -= _genericItemList[selectNum].data.cost;
            }
            
            if (selectNum >= 0)
            {
                _productCallBack(_genericItemList[selectNum].data, _baseData);
            }
        
        }
        
        private function closeWindow(e:Event):void
        {
            _closeCallBack();
        }
        
        //汎用ユニットアイテム選択
        private function selectGenericItem(genericData:GenericUnitData, isSelect:Boolean):void
        {
            var i:int = 0;
            for (i = 0; i < _genericItemList.length; i++)
            {
                if (_genericItemList[i].data === genericData)
                {
                    
                }
                else
                {
                    _genericItemList[i].setSelected(false);
                }
            }
            _startBtn.isEnabled = true;
            if (MainController.$.map.sideState[0].cost >= 0)
            {
                _costCount.setMaxNumber(genericData.cost, MainController.$.map.sideState[0].cost);
            }
        }
        
        private function checkItemSelect():void
        {
            var i:int = 0;
            if (MainController.$.map.sideState[0].cost >= 0)
            {
                for (i = 0; i < _genericItemList.length; i++)
                {
                    if (_genericItemList[i].data.cost > MainController.$.map.sideState[0].cost)
                    {
                        _genericItemList[i].alpha = 0.7;
                        _genericItemList[i].touchable = false;
                    }
                    else
                    {
                        _genericItemList[i].alpha = 1;
                        _genericItemList[i].touchable = true;
                    }
                }
            }
        }
    
    }
}