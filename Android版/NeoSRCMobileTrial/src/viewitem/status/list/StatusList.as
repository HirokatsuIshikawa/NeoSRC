package viewitem.status.list
{
    import common.CommonDef;
    import database.user.UnitCharaData;
    import main.MainController;
    import starling.events.Event;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import viewitem.status.list.UnitListBase;
    import viewitem.status.list.listitem.StatusListItem;
    
    /**
     * ...
     * @author ishikawa
     */
    public class StatusList extends UnitListBase
    {
        /**暗幕画像*/
        private var _itemList:Vector.<StatusListItem> = null;
        private var _closeBtn:CImgButton = null;
        
        
        public function StatusList(datalist:Vector.<UnitCharaData>)
        {
            super();
            
            //一覧リスト
            _itemList = new Vector.<StatusListItem>;
            
            for (var i:int = 0; i < datalist.length; i++)
            {
                _itemList[i] = new StatusListItem(datalist[i]);
                _itemList[i].x = 60 + (StatusListItem.LIST_WIDTH + 40) * (int)(i % 3);
                _itemList[i].y = (StatusListItem.LIST_HEIGHT + 24) * (int)(i / 3);
                _listContena.addChild(_itemList[i]);
            }
            
            setSlider(_itemList.length);
            
            //閉じるボタン
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 960 - 96;
            _closeBtn.y = 460;
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusList);
            addChild(_closeBtn);
        }
        
        override public function dispose():void
        {
            
            for (var i:int = 0; i < _itemList.length; i++)
            {
                _listContena.removeChild(_itemList[i]);
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