package viewitem.status.list
{
    import database.user.GenericUnitData;
    import main.MainController;
    import starling.events.Event;
    import system.custom.customSprite.CImgButton;
    import viewitem.status.list.listitem.StatusGenericListItem;
    /**
     * ...
     * @author ishikawa
     */
    public class GenericStatusList extends UnitListBase
    {
        /**暗幕画像*/
        private var _itemList:Vector.<StatusGenericListItem> = null;
        private var _closeBtn:CImgButton = null;
        
        public function GenericStatusList(datalist:Vector.<GenericUnitData>)
        {
            super();
            
            _itemList = new Vector.<StatusGenericListItem>;
            
            for (var i:int = 0; i < datalist.length; i++)
            {
                _itemList[i] = new StatusGenericListItem(datalist[i]);
                _itemList[i].x = 60 + (StatusGenericListItem.LIST_WIDTH + 40) * (int)(i % 3);
                _itemList[i].y = (StatusGenericListItem.LIST_HEIGHT + 24) * (int)(i / 3);
                _listContena.addChild(_itemList[i]);
            }
            
            setSlider(_itemList.length);
            
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 960 - 96;
            _closeBtn.y = 460;
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeGenericStatusList);
            addChild(_closeBtn);
        }
        
        override public function dispose():void
        {
            
            for (var i:int = 0; i < _itemList.length; i++)
            {
                this.removeChild(_itemList[i]);
                _itemList[i].dispose();
                _itemList[i] = null;
            }
            
            if (_closeBtn)
            {
                removeChild(_closeBtn);
                _closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusList);
                _closeBtn.dispose();
            }
            _closeBtn = null;
            
            super.dispose();
        }
    
    }

}