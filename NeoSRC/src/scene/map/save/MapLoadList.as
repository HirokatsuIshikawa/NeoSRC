package scene.map.save
{
    import common.CommonDef;
    import common.CommonSystem;
    import flash.filesystem.File;
    import scene.intermission.save.LoadList;
    import main.MainController;
    import starling.events.Event;
    import system.custom.customSprite.CImgButton;
    
    /**
     * ...
     * @author ...
     */
    public class MapLoadList extends LoadList
    {
        
        protected var _closeBtn:CImgButton = null;
        
        public function MapLoadList(func:Function)
        {
            super(func);
        
        }
        
        override protected function setInitialButton():void
        {
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 820;
            _closeBtn.y = 360;
            
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.closeLoadList);
            addChild(_closeBtn);
            
            _continueBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_QuickLoad"));
            
            _continueBtn.x = 820;
            _continueBtn.y = 460;
            _continueBtn.width = 96;
            _continueBtn.height = 64;
            _continueBtn.addEventListener(Event.TRIGGERED, MainController.$.view.pushContinueBtn);
            
            var continueName:String = CommonSystem.SAVE_NAME.replace("{0}", CommonDef.formatZero(CommonSystem.LAST_SAVE_NUM, 2) + "");
            var file:File = File.desktopDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + continueName + ".srcsav")
            
            if (file.exists)
            {
                _saveFileFlg = true;
                addChild(_continueBtn);
            }
        }
        
        override public function dispose():void
        {
            if (_closeBtn != null)
            {
                removeChild(_closeBtn);
                _closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.closeLoadList);
                _closeBtn.dispose();
            }
            _closeBtn = null;
            
            super.dispose();
        }
    
    }

}