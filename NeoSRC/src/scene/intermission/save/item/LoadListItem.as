package scene.intermission.save.item
{
    import common.CommonDef;
    import common.CommonSystem;
    import scene.map.panel.BattleMapPanel;
    import starling.events.Event;
    import scene.main.MainController;
    import system.file.DataLoad;
    
    /**
     * ...
     * @author ishikawa
     */
    public class LoadListItem extends DataListItem
    {
        protected var _saveFunc:Function = null;
        protected var _number:int = 0;
        protected var _loadData:Object = null;
        
        public function LoadListItem(num:int, data:String)
        {
            
            super();
            _number = num;
            
            if (data != null)
            {
                var listData:Object = JSON.parse(data);
                _noText.text = "データ" + (num + 1);
                
                //マップ上か否か
                if (listData.hasOwnProperty("mapState"))
                {
                    var addStr:String = listData.playerData.nowEve;
                    if (listData.mapState == BattleMapPanel.PANEL_MAP_TALK)
                    {
                        _clearText.text = addStr.replace(".srceve", "_マップ");
                    }
                    else
                    {
                        _clearText.text = addStr.replace(".srceve", "_中断");
                    }
                    _saveFunc = MainController.$.view.returnLoadFunc(num);
                }
                else
                {
                    //インターミッションの場合
                    if (listData.playerData.hasOwnProperty("clearEve"))
                    {
                        if (listData.playerData.clearEve != null)
                        {
                            var str:String = listData.playerData.clearEve;
                            _clearText.text = str.replace(".srceve", "");
                        }
                    }
                    _saveFunc = MainController.$.view.returnLoadSaveData(listData);
                }
                _timeText.text = listData.time;
                _saveBtn.changeImg(MainController.$.imgAsset.getTexture("btn_listload"));
                _saveBtn.visible = true;
                setEnable(true);
                _loadData = listData;
                _saveBtn.addEventListener(Event.TRIGGERED, _saveFunc);
            }
            else
            {
                _saveBtn.visible = false;
                _noText.text = "空きデータ";
                _clearText.text = "";
                _timeText.text = "";
                setEnable(false);
            }
        
        }
        
        override public function dispose():void
        {
            if (_saveBtn != null)
            {
                _saveBtn.removeEventListener(Event.TRIGGERED, _saveFunc);
            }
            
            _saveFunc = null;
            if (_loadData != null)
            {
                _loadData = null;
            }
            
            super.dispose();
        }
    
    }

}