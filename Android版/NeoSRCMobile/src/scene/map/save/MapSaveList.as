package scene.map.save
{
    import common.CommonDef;
    import common.CommonSystem;
    import scene.intermission.save.SaveList;
    import scene.intermission.save.item.DataListItem;
    import scene.intermission.save.item.SaveListItem;
    import main.MainController;
    import starling.events.Event;
    import system.custom.customSprite.CImgButton;
    import system.file.DataLoad;
    import system.file.DataSave;
    
    /**
     * ...
     * @author ...
     */
    public class MapSaveList extends SaveList
    {
        
        public function MapSaveList()
        {
            super();
        }
        
        override public function dispose():void
		{
			CommonDef.disposeList(_saveList);
			
			if (_closeBtn != null)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.closeSaveList);
				_closeBtn.dispose();
			}
			_closeBtn = null;
			
			super.dispose();
		}
        
        override protected function setListItem():void
        {
            var i:int = 0;
            var saveMax:int = CommonSystem.SAVE_NUM;
            _saveList = new Vector.<SaveListItem>();
            _saveCompCount = 0;
            
            MainController.$.view.waitDark(true);
            for (i = 0; i < saveMax; i++)
            {
                var saveCount:int = i + 1;
                var saveName:String = CommonSystem.SAVE_NAME.replace("{0}", CommonDef.formatZero(saveCount, 2) + ".srcsav");
                DataLoad.loadSaveData(saveName, i, setListData);
            }
            
            MAX_LIST_AREA = (DataListItem.LIST_HEIGHT + 20) * saveMax - 20;
            
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 820;
            _closeBtn.y = 460;
            
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.closeSaveList);
            addChild(_closeBtn);
        }
        
        override protected function setListData(data:String, num:int):void
        {
            var saveData:SaveListItem = new SaveListItem(MainController.$.view.returnSaveFunc, num, data);
            saveData.x = 0;
            saveData.y = (DataListItem.LIST_HEIGHT + 20) * num;
            _listSpr.addChild(saveData);
            _saveList.push(saveData);
            
            _saveCompCount++;
            if (_saveCompCount >= CommonSystem.SAVE_NUM)
            {
                MainController.$.view.waitDark(false);
            }
        }
    
    }

}