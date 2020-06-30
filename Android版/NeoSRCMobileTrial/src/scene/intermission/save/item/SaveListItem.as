package scene.intermission.save.item
{
    import common.CommonSystem;
    import scene.main.MainController;
    import scene.map.panel.BattleMapPanel;
    import starling.events.Event;
    
    /**
     * ...
     * @author ishikawa
     */
    public class SaveListItem extends DataListItem
    {
        protected var _saveFunc:Function = null;
        
        public function SaveListItem(func:Function, num:int, data:String)
        {
            
            super();
            _saveFunc = func(num);
            _saveBtn.addEventListener(Event.TRIGGERED, _saveFunc);
            
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
                }
                else
                {
                    if (listData.playerData.hasOwnProperty("clearEve"))
                    {
                        if (listData.playerData.clearEve != null)
                        {
                            var str:String = listData.playerData.clearEve;
                            
                            _clearText.text = str.replace(".srceve", "");
                        }
                    }
                }
                _timeText.text = listData.time;
                
                setEnable(true);
            }
            else
            {
                
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
                _saveBtn.dispose();
                _saveBtn = null;
            }
            super.dispose();
        }
    
    }

}