package scene.map.panel.subpanel
{
    import a24.tween.Tween24;
    import common.CommonDef;
    import common.CommonSystem;
    import scene.map.save.MapLoadList;
    import scene.map.save.MapSaveList;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.CTextArea;
    import flash.text.TextFormatAlign;
    import starling.events.Event;
    import system.file.DataLoad;
    import system.file.DataSave;
    import scene.intermission.save.ConfirmPopup;
    import main.MainController;
    import scene.map.panel.BattleMapPanel;
    
    /**
     * ...
     * @author ishikawa
     */
    public class SystemPanel extends CSprite
    {
        protected var _moving:Boolean = false;
        protected var _menuBtn:CImgButton = null;
        
        protected var _listSprite:CSprite = null;
        protected var _passBtn:CImgButton = null;
        protected var _saveBtn:CImgButton = null;
        protected var _loadBtn:CImgButton = null;
        protected var _commanderBtn:CImgButton = null;
        protected var _returnBtn:CImgButton = null;
        
        private var _posText:CTextArea = null;
        
        public function SystemPanel()
        {
            super();
            _moving = false;
            /*
               _menuBtn = new CImage(MainController.$.imgAsset.getTexture("btn_Menu"));
             */
            _menuBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Menu"));
            _menuBtn.alpha = 1;
            _menuBtn.x = BattleMapPanel.RIGHT_SIDE;
            _menuBtn.y = BattleMapPanel.UNDER_LINE;
            _menuBtn.addEventListener(Event.TRIGGERED, menuBtnHandler);
            addChild(_menuBtn);
            
            _listSprite = new CSprite();
            _listSprite.y = BattleMapPanel.UNDER_LINE;
            _listSprite.visible = false;
            addChild(_listSprite);
            
            _passBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Pass"));
            _passBtn.alpha = 1;
            _passBtn.x = BattleMapPanel.BTN_INTERBAL * 0;
            _passBtn.y = 0;
            _passBtn.addEventListener(Event.TRIGGERED, passBtnHandler);
            _listSprite.addChild(_passBtn);
            
            _saveBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_listsave"));
            _saveBtn.alpha = 1;
            _saveBtn.x = BattleMapPanel.BTN_INTERBAL * 1;
            _saveBtn.y = 0;
            _saveBtn.addEventListener(Event.TRIGGERED, saveBtnHandler);
            _listSprite.addChild(_saveBtn);
            
            _loadBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_listload"));
            _loadBtn.alpha = 1;
            _loadBtn.x = BattleMapPanel.BTN_INTERBAL * 2;
            _loadBtn.y = 0;
            _loadBtn.addEventListener(Event.TRIGGERED, loadBtnHandler);
            _listSprite.addChild(_loadBtn);
            
            _commanderBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_commander"));
            _commanderBtn.alpha = 1;
            _commanderBtn.x = BattleMapPanel.BTN_INTERBAL * 3;
            _commanderBtn.y = 0;
            _commanderBtn.addEventListener(Event.TRIGGERED, commanderBtnHandler);
            _listSprite.addChild(_commanderBtn);
            
            _returnBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _returnBtn.alpha = 1;
            _returnBtn.x = BattleMapPanel.RIGHT_SIDE;
            _returnBtn.y = 0;
            _returnBtn.addEventListener(Event.TRIGGERED, returnBtnHandler);
            _listSprite.addChild(_returnBtn);
            
            _posText = new CTextArea(24, 0xFFFFFF, 0x000000AA);
            _posText.styleName = "noveltext";
            _posText.width = 64;
            _posText.height = 96;
            _posText.x = CommonDef.WINDOW_W - 64;
            _posText.y = 0;
            _posText.text = "";
            addChild(_posText);
        
        }
        
        override public function dispose():void
        {
            if (_posText != null)
            {
                _posText.dispose();
                _posText = null;
            }
            
            if (_menuBtn != null)
            {
                _menuBtn.removeEventListener(Event.TRIGGERED, menuBtnHandler);
                _menuBtn.dispose();
                _menuBtn = null;
            }
            
            if (_passBtn != null)
            {
                _passBtn.removeEventListener(Event.TRIGGERED, passBtnHandler);
                _passBtn.dispose();
                _passBtn = null;
            }
            
            if (_saveBtn != null)
            {
                _saveBtn.removeEventListener(Event.TRIGGERED, saveBtnHandler);
                _saveBtn.dispose();
                _saveBtn = null;
            }
            
            if (_loadBtn != null)
            {
                _loadBtn.removeEventListener(Event.TRIGGERED, loadBtnHandler);
                _loadBtn.dispose();
                _loadBtn = null;
            }
            
            if (_commanderBtn != null)
            {
                _commanderBtn.removeEventListener(Event.TRIGGERED, commanderBtnHandler);
                _commanderBtn.dispose();
                _commanderBtn = null;
            }
            if (_returnBtn != null)
            {
                _returnBtn.removeEventListener(Event.TRIGGERED, returnBtnHandler);
                _returnBtn.dispose();
                _returnBtn = null;
            }
            if (_listSprite != null)
            {
                _listSprite.dispose();
                _listSprite = null;
            }
            
            super.dispose();
        }
        
        public function refresh():void
        {
            _menuBtn.visible = true;
            _listSprite.visible = false;
            _menuBtn.y = CommonDef.WINDOW_H - 64;
            _listSprite.y = CommonDef.WINDOW_H;
            if (MainController.$.map.sideState != null && MainController.$.map.sideState.length > 0 && MainController.$.map.sideState[0].commander != null)
            {
                _commanderBtn.visible = true;
            }
            else
            {
                _commanderBtn.visible = false;
            }
        }
        
        public function showMenuBtn():void
        {
            _menuBtn.visible = true;
            _listSprite.visible = true;
            _moving = true;
            Tween24.serial( //
            Tween24.prop(_listSprite).y(CommonDef.WINDOW_H - 64), Tween24.prop(_menuBtn).y(CommonDef.WINDOW_H), Tween24.tween(_listSprite, 0.1).y(CommonDef.WINDOW_H), //
            Tween24.tween(_menuBtn, 0.1).y(CommonDef.WINDOW_H - 64)//
            ).onComplete(showMenuBtnComp).play();
        }
        
        public function showListBtn():void
        {
            _menuBtn.visible = true;
            _listSprite.visible = true;
            _moving = true;
            Tween24.serial( //
            Tween24.prop(_menuBtn).y(CommonDef.WINDOW_H - 64), Tween24.prop(_listSprite).y(CommonDef.WINDOW_H), Tween24.tween(_menuBtn, 0.1).y(CommonDef.WINDOW_H), //
            Tween24.tween(_listSprite, 0.1).y(CommonDef.WINDOW_H - 64)//
            ).onComplete(showListBtnComp).play();
        }
        
        public function showMenuBtnComp():void
        {
            _menuBtn.y = CommonDef.WINDOW_H - 64;
            _listSprite.y = CommonDef.WINDOW_H;
            _menuBtn.visible = true;
            _listSprite.visible = false;
            _moving = false;
        }
        
        public function showListBtnComp():void
        {
            _menuBtn.y = CommonDef.WINDOW_H;
            _listSprite.y = CommonDef.WINDOW_H - 64;
            _menuBtn.visible = false;
            _listSprite.visible = true;
            _moving = false;
        }
        
        public function setPosText(x:int, y:int):void
        {
            _posText.text = "X:" + x + "\nY:" + y;
        }
        
        //-----------------------------------------------------------------
        //
        // クリック処理
        //
        //-----------------------------------------------------------------
        /**クリック時*/
        protected function menuBtnHandler(event:Event):void
        {
            if (_moving) return;
            showListBtn();
        }
        
        /**クリック時*/
        protected function passBtnHandler(event:Event):void
        {
            if (_moving) return;
            MainController.$.view.battleMap.changePhase();
        }
        
        /**クリック時*/
        protected function saveBtnHandler(event:Event):void
        {
            if (_moving) return;
            MainController.$.view.waitDark(true);
            MainController.$.view.callMapSaveList();
        
        /*
           DataSave.saveMapGameFile();
           var compPopup:ConfirmPopup = new ConfirmPopup("セーブ完了しました");
           addChild(compPopup);
         */
        
        }
        
        /**クリック時*/
        protected function loadBtnHandler(event:Event):void
        {
            if (_moving) return;
            MainController.$.view.waitDark(true);
            MainController.$.view.callMapLoadList();
        
            //DataLoad.loadMapSaveData();
        }
        
        protected function commanderBtnHandler(event:Event):void
        {
            if (_moving) return;
            MainController.$.map.showCommanderStatusWindow(0);            
        }
        
        
        /**クリック時*/
        protected function returnBtnHandler(event:Event):void
        {
            if (_moving) return;
            showMenuBtn();
        }
    
    }
}