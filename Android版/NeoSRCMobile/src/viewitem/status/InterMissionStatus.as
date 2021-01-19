package viewitem.status
{
    import bgm.SingleMusic;
    import common.CommonDef;
    import database.user.CommanderData;
    import main.MainController;
    import scene.unit.BattleUnit;
    import starling.events.Event;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.file.DataLoad;
    import viewitem.status.BaseStatusWindow;
    
    /**
     * ...
     * @author ishikawa
     */
    public class InterMissionStatus extends CSprite
    {
        
        public static const TYPE_NONE:int = 0;
        public static const TYPE_UNIT:int = 1;
        public static const TYPE_COMMANDER:int = 2;
        public static const TYPE_LISTUNIT:int = 3;
        
        private var _type:int = 0;
        private var _blackBackImg:CImage = null;
        private var _closeBtn:CImgButton = null;
        private var _customBGMBtn:CImgButton = null;
        private var _statusWindow:BaseStatusWindow = null;
        private var _unitId:int = 0;
        private var _commanderData:CommanderData = null;
        
        //軍師用
        private var _decideBtn:CImgButton = null;
        
        public function InterMissionStatus()
        {
            
            super();
            
            //暗幕設定
            _blackBackImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
            _blackBackImg.alpha = 0.8;
            _blackBackImg.width = CommonDef.WINDOW_W;
            _blackBackImg.height = CommonDef.WINDOW_H;
            addChildAt(_blackBackImg, 0);
            
            _statusWindow = new BaseStatusWindow();
            _statusWindow.x = 40;
            _statusWindow.y = 10;
            addChild(_statusWindow);
            
            // 閉じるボタン
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 780;
            _closeBtn.y = 360;
            
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusWindow);
            addChild(_closeBtn);
            
            //決定ボタン
            _decideBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_commander"));
            _decideBtn.x = 780;
            _decideBtn.y = 440;
            
            _decideBtn.width = 96;
            _decideBtn.height = 64;
            _decideBtn.addEventListener(Event.TRIGGERED, selectCommander);
            addChild(_decideBtn);
            
            // カスタムBGM
            _customBGMBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_bgm"));
            _customBGMBtn.x = 780;
            _customBGMBtn.y = 240;
            
            _customBGMBtn.width = 64;
            _customBGMBtn.height = 64;
            _customBGMBtn.addEventListener(Event.TRIGGERED, callCustomBgm);
            addChild(_customBGMBtn);
        
        }
        
        override public function dispose():void
        {
            _blackBackImg.dispose();
            _blackBackImg = null;
            
            if (_closeBtn)
            {
                removeChild(_closeBtn);
                _closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusWindow);
                _closeBtn.dispose();
            }
            if (_customBGMBtn)
            {
                removeChild(_customBGMBtn);
                _customBGMBtn.removeEventListener(Event.TRIGGERED, callCustomBgm);
                _customBGMBtn.dispose();
            }
            if (_decideBtn)
            {
                removeChild(_decideBtn);
                _decideBtn.removeEventListener(Event.TRIGGERED, selectCommander);
                _decideBtn.dispose();
            }

            
            _closeBtn = null;
            _customBGMBtn = null;
            super.dispose();
        }
        
        public function setCharaData(unit:BattleUnit):void
        {
            _decideBtn.visible = false;
            _type = TYPE_UNIT;
            _unitId = unit.id;
            _statusWindow.setCharaData(unit);
            
            if (unit.customBgmPath != null && unit.customBgmPath.length > 0)
            {
                try
                {
                    SingleMusic.playBGM(unit.customBgmHeadPath, 1, 1);
                }
                catch (error:Error)
                {
                    
                }
            }
        }
        
        public function setCommanderData(data:CommanderData):void
        {
            _decideBtn.visible = true;
            _type = TYPE_COMMANDER;
            _commanderData = data;
            _statusWindow.setCommanderData(data);
            
            if (data.customBgmPath != null && data.customBgmPath.length > 0)
            {
                try
                {
                    SingleMusic.playBGM(data.customBgmHeadPath, 1, 1);
                }
                catch (error:Error)
                {
                    
                }
            }
        }
        
        /**カスタムBGMセット*/
        public function callCustomBgm(event:Event):void
        {
            var i:int = 0;
            
            DataLoad.LoadPath("カスタムBGM", "*.mid;*.mp3", compLoad);
            function compLoad(path:String):void
            {
                if (_type == TYPE_UNIT)
                {
                    for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
                    {
                        if (MainController.$.model.PlayerUnitData[i].id == _unitId)
                        {
                            MainController.$.model.PlayerUnitData[i].customBgmPath = path;
                            SingleMusic.playBGM(MainController.$.model.PlayerUnitData[i].customBgmHeadPath, 1, 1);
                            break;
                        }
                    }
                }
                else if (_type == TYPE_COMMANDER)
                {
                    _commanderData.customBgmPath = path;
                    SingleMusic.playBGM(_commanderData.customBgmHeadPath, 1, 1);
                }
            }
        }
        
        
        private function selectCommander():void
        {
            MainController.$.model.playerParam.selectCommanderName = _commanderData.name;
            MainController.$.view.interMission.closeStatusWindow(null);
        }
        
    }
}