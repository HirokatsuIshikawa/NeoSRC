package scene.intermission
{
    import common.CommonDef;
    import common.CommonSystem;
    import common.util.CharaDataUtil;
    import database.master.MasterCharaData;
    import database.user.CommanderData;
    import database.user.GenericUnitData;
    import main.MainViewer;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.CTextArea;
    import database.user.UnitCharaData;
    import flash.text.TextFormatAlign;
    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;
    import system.file.DataSave;
    import scene.intermission.save.ConfirmPopup;
    import scene.intermission.save.SaveList;
    import main.MainController;
    import scene.unit.BattleUnit;
    import scene.intermission.customdata.ShowInterMissionData;
    import viewitem.status.InterMissionStatus;
    import viewitem.status.StrengthWindow;
    import viewitem.status.list.CommanderStatusList;
    import viewitem.status.list.GenericStatusList;
    import viewitem.status.list.StatusList;
    import viewitem.status.list.StrengthList;
    
    /**
     * ...
     * @author ishikawa
     */
    public class InterMission extends CSprite
    {
        public static const BTN_TOP_LINE:int = 60;
        public static const BTN_WIDTH:int = 128;
        public static const BTN_HEIGHT:int = 80;
        
        private var _backImg:Image = null;
        
        private var _addBtnList:Vector.<CImgButton> = null;
        private var _labelTxtList:Vector.<CTextArea> = null;
        
        private var _saveList:SaveList = null;
        private var _statusList:StatusList = null;
        //強化一覧
        private var _strengthList:StrengthList = null;
        //軍師リスト
        private var _commanderStatusList:CommanderStatusList = null;
        //汎用一覧
        private var _genericStatusList:GenericStatusList = null;
        
        /**ステータス表示*/
        private var _statusWindow:InterMissionStatus = null;
        private var _strengthWindow:StrengthWindow = null;
        
        public function InterMission()
        {
            //出撃状況を元に戻す
            for (var i:int = 0; i < MainController.$.model.PlayerUnitData.length; i++)
            {
                MainController.$.model.PlayerUnitData[i].launched = false;
            }
            
            _addBtnList = new Vector.<CImgButton>();
            _labelTxtList = new Vector.<CTextArea>();
            var data:Object = null;
            for each (data in CommonSystem.INTERMISSION_DATA)
            {
                if (!judgeShow(data))
                {
                    continue;
                }
                
                switch (data.type)
                {
                case "img": 
                    var tex:Texture = null;
                    if (MainController.$.model.playerParam.intermissionBackURL != null)
                    {
                        tex = MainController.$.imgAsset.getTexture(MainController.$.model.playerParam.intermissionBackURL);
                    }
                    else
                    {
                        tex = MainController.$.imgAsset.getTexture(data.img);
                    }
                    //URL
                    var param:Object = new Object();
                    param.size = "fill";
                    setBackImg(tex);
                    break;
                case "btn": 
                    setNewBtn(data);
                    break;
                case "label": 
                    setNewLabel(data);
                    break;
                }
                
            }
        
        }
        
        private function judgeShow(data:Object):Boolean
        {
            var i:int = 0;
            var list:Vector.<ShowInterMissionData> = MainController.$.model.playerParam.intermissonData;
            if (data.show == 0)
            {
                for (i = 0; i < list.length; i++)
                {
                    if (data.name === list[i].name)
                    {
                        if (list[i].show == 1)
                        {
                            return true;
                        }
                        return false;
                    }
                }
                return false;
            }
            else if (data.show == 1)
            {
                for (i = 0; i < list.length; i++)
                {
                    if (data.name === list[i].name)
                    {
                        if (list[i].show == 0)
                        {
                            return false;
                        }
                        return true;
                    }
                }
                return true;
            }
            return false;
        }
        
        private function setNewLabel(data:Object):void
        {
            var i:int = 0;
            if (!data.hasOwnProperty("fontsize"))
            {
                data.fontsize = 24;
            }
            if (!data.hasOwnProperty("color"))
            {
                data.color = 0xFFFFFF;
            }
            if (!data.hasOwnProperty("back"))
            {
                data.back = 0x0;
            }
            
            var title:String = "";
            var txt:String = "";
            var align:String = TextFormatAlign.LEFT;
            
            if (data.hasOwnProperty("align"))
            {
                align = TextFormatAlign[data.align];
            }
            
            var txtLabel:CTextArea = new CTextArea(data.fontsize, data.color, data.back, align);
            txtLabel.name = data.name;
            if (data.key === "資金")
            {
                title = CommonSystem.MONEY_NAME + ":";
                txt = MainController.$.model.playerParam.money + "";
            }
            else
            {
                for (i = 0; i < MainController.$.model.playerParam.playerVariable.length; i++)
                {
                    if (data.key === MainController.$.model.playerParam.playerVariable[i].name)
                    {
                        title = data.name + ":";
                        txt = MainController.$.model.playerParam.playerVariable[i].value + "";
                        break;
                    }
                }
            }
            
            if (data.title == 1)
            {
                txtLabel.text = title + txt;
            }
            else
            {
                txtLabel.text = txt;
            }
            txtLabel.name = "資金ラベル";
            txtLabel.x = data.x;
            txtLabel.y = data.y;
            if (!data.hasOwnProperty("width"))
            {
                data.width = txtLabel.text.length * data.fontsize + 16;
            }
            if (!data.hasOwnProperty("height"))
            {
                data.height = data.fontsize * 1.4;
            }
            
            txtLabel.width = data.width;
            txtLabel.height = data.height;
            txtLabel.touchable = false;
            addChild(txtLabel);
            _labelTxtList.push(txtLabel);
        }
        
        private function setNewBtn(data:Object):void
        {
            
            var addBtn:CImgButton = null;
            
            if (data.hasOwnProperty("action"))
            {
                switch (data.action)
                {
                case "NextStage": 
                case "次のステージ": 
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_next"));
                    addBtn.name = "NextStage";
                    if (MainController.$.model.playerParam.nextEve != null && MainController.$.model.playerParam.nextEve.length > 0 && MainController.$.model.playerParam.nextEve != "未設定")
                    {
                        
                        addBtn.isEnabled = true;
                    }
                    else
                    {
                        
                        addBtn.isEnabled = false;
                    }
                    
                    break;
                case "UnitList": 
                case "ユニット一覧": 
                    if (MainController.$.model.PlayerUnitData.length <= 0)
                    {
                        return;
                    }
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_chara"));
                    addBtn.name = "UnitList";
                    break;
                case "CommanderList": 
                case "軍師一覧": 
                    if (MainController.$.model.playerCommanderData.length <= 0)
                    {
                        return;
                    }
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_intermission_commander"));
                    addBtn.name = "CommanderList";
                    break;
                case "GenericList": 
                case "汎用一覧": 
                    if (MainController.$.model.playerGenericUnitData.length <= 0)
                    {
                        return;
                    }
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_intermission_generic"));
                    addBtn.name = "GenericList";
                    break;
                case "DataSave": 
                case "セーブ": 
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_save"));
                    addBtn.name = "DataSave";
                    break;
                case "UnitStrength": 
                case "ユニット強化": 
                    addBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_strength"));
                    addBtn.name = "UnitStrength";
                    break;
                }
            }
            else
            {
                addBtn = new CImgButton(MainController.$.imgAsset.getTexture(data.img));
                addBtn.loadFile = data.file;
                if (data.hasOwnProperty("label"))
                {
                    addBtn.loadLabel = "スタート";
                }
                else
                {
                    addBtn.loadLabel = data.label;
                }
            }
            addBtn.x = data.x;
            addBtn.y = data.y;
            addBtn.addEventListener(Event.TRIGGERED, addBtnEvent);
            addChild(addBtn);
            _addBtnList.push(addBtn);
        
        }
        
        private function callSaveList():void
        {
            if (_saveList != null)
            {
                _saveList.dispose();
                _saveList = null;
            }
            
            _saveList = new SaveList();
            addChild(_saveList);
        }
        
        public function returnSaveFunc(num:int):Function
        {
            return function():void
            {
                saveEvent(num);
            }
        }
        
        public function closeSaveList(e:Event):void
        {
            removeChild(_saveList);
            _saveList.dispose();
            _saveList = null;
        }
        
        private function saveEvent(saveNum:int):void
        {
            DataSave.saveGameFile(saveNum);
            _saveList.dispose();
            _saveList = null;
            var compPopup:ConfirmPopup = new ConfirmPopup("セーブ完了しました");
            addChild(compPopup);
        }
        
        private function endTrial():void
        {
            var compPopup:ConfirmPopup = new ConfirmPopup("体験版は１話までです");
            addChild(compPopup);
        }
        
        private function noUse():void
        {
            var compPopup:ConfirmPopup = new ConfirmPopup("この機能は体験版では使用できません");
            addChild(compPopup);
        }
        
        //追加ボタンイベント
        private function addBtnEvent(event:Event):void
        {
            var btn:CImgButton = event.currentTarget as CImgButton;
            switch (btn.name)
            {
            case "NextStage": 
                CONFIG::trial
            {
                endTrial();
            }
                CONFIG::main
            {
                gotoNextStage();
            }
                break;
            case "UnitList": 
                callStatusList();
                break;
            case "CommanderList": 
                callCommanderList();
                break;
            case "GenericList":
                callGenericList();
                break;
            case "DataSave": 
                callSaveList();
                break;
            case "UnitStrength": 
                callStrengthList();
                break;
            default: 
                CONFIG::trial
            {
                noUse();
            }
                CONFIG::trial == false
            {
                MainController.$.view.loadEve(btn.loadFile, btn.loadLabel);
            }
                break;
            }
        
        }
        
        private function gotoNextStage():void
        {
            MainController.$.view.loadEve(MainController.$.model.playerParam.nextEve, MainViewer.START_LABEL);
        }
        
        public function callStrengthList():void
        {
            _strengthList = new StrengthList(MainController.$.model.PlayerUnitData);
            addChild(_strengthList);
        }
        
        //ステータス・強化一覧呼び出し
        public function callStatusList():void
        {
            _statusList = new StatusList(MainController.$.model.PlayerUnitData);
            addChild(_statusList);
        }
        
        //軍師リスト呼び出し
        public function callCommanderList():void
        {
            _commanderStatusList = new CommanderStatusList(MainController.$.model.playerCommanderData);
            addChild(_commanderStatusList);
        }
        
        //汎用ユニット一覧呼び出し
        public function callGenericList():void
        {
            _genericStatusList = new GenericStatusList(MainController.$.model.playerGenericUnitData);
            addChild(_genericStatusList);
        }
        
        public function closeStrengthList(event:Event):void
        {
            removeChild(_strengthList);
            _strengthList.dispose();
            _strengthList = null;
        }
        
        public function closeStatusList(event:Event):void
        {
            removeChild(_statusList);
            _statusList.dispose();
            _statusList = null;
        }
        
        public function closeCommanderStatusList(event:Event):void
        {
            removeChild(_commanderStatusList);
            _commanderStatusList.dispose();
            _commanderStatusList = null;
        }
        
        
        public function closeGenericStatusList(event:Event):void
        {
            removeChild(_genericStatusList);
            _genericStatusList.dispose();
            _genericStatusList = null;
        }
        
        
        public function callStatusWindow(data:UnitCharaData):void
        {
            var battleUnit:BattleUnit = new BattleUnit(data, 0, 0);
            _statusWindow = new InterMissionStatus();
            _statusWindow.setCharaData(battleUnit);
            addChild(_statusWindow);
            _statusWindow.visible = true;
        }
        
        
        public function callGenericStatusWindow(data:GenericUnitData):void
        {
            var charaData:UnitCharaData = new UnitCharaData(0, CharaDataUtil.getMasterCharaDataName(data.name), data.lv);            
            var battleUnit:BattleUnit = new BattleUnit(charaData, 0, 0);
            _statusWindow = new InterMissionStatus();
            _statusWindow.setCharaData(battleUnit);
            addChild(_statusWindow);
            _statusWindow.visible = true;
        }
        
        public function callCommanderStatusWindow(data:CommanderData):void
        {
            _statusWindow = new InterMissionStatus();
            _statusWindow.setCommanderData(data);
            addChild(_statusWindow);
            _statusWindow.visible = true;
        }
        
        public function closeStatusWindow(event:Event):void
        {
            removeChild(_statusWindow);
            _statusWindow.dispose();
            _statusWindow = null;
        }
        
        public function callStrengthWindow(data:UnitCharaData):void
        {
            var battleUnit:BattleUnit = new BattleUnit(data, 0, 0);
            _strengthWindow = new StrengthWindow();
            _strengthWindow.setCharaData(battleUnit);
            addChild(_strengthWindow);
            _strengthWindow.visible = true;
        }
        
        public function compStrengthChara():void
        {
            var i:int = 0;
            var title:String = null;
            var txt:String = null;
            closeStrengthList(null);
            callStrengthList();
            
            for (i = 0; i < _labelTxtList.length; i++)
            {
                var data:Object = CommonSystem.INTERMISSION_DATA["資金"];
                if (_labelTxtList[i].name === "資金ラベル")
                {
                    title = CommonSystem.MONEY_NAME + ":";
                    txt = MainController.$.model.playerParam.money + "";
                    if (data.title == 1)
                    {
                        _labelTxtList[i].text = title + txt;
                    }
                    else
                    {
                        _labelTxtList[i].text = txt;
                    }
                    break;
                }
            }
            
            removeChild(_strengthWindow);
            _strengthWindow.dispose();
            _strengthWindow = null;
        }
        
        public function closeStrengthWindow(event:Event):void
        {
            removeChild(_strengthWindow);
            _strengthWindow.dispose();
            _strengthWindow = null;
        }
        
        override public function dispose():void
        {
            var i:int = 0;
            
            for (i = 0; i < _labelTxtList.length; )
            {
                _labelTxtList[i].dispose();
                _labelTxtList[i] = null;
                _labelTxtList.splice(0, 1);
            }
            
            for (i = 0; i < _addBtnList.length; )
            {
                _addBtnList[i].removeEventListener(Event.TRIGGERED, addBtnEvent);
                _addBtnList[i].dispose();
                _addBtnList[i] = null;
                _addBtnList.splice(0, 1);
            }
            
            this.parent.removeChild(this);
            if (_backImg != null)
            {
                _backImg.dispose();
                _backImg = null;
            }
            if (_saveList != null)
            {
                _saveList.dispose();
                _saveList = null;
            }
            
            super.dispose();
        }
        
        private function setBackImg(tex:Texture):void
        {
            _backImg = new CImage(tex);
            var ratio:Number = _backImg.width / _backImg.height;
            //縦横幅、小さい方に合わせて拡大
            if (_backImg.width >= _backImg.height * CommonDef.WINDOW_RATIO)
            {
                _backImg.height = CommonDef.WINDOW_H;
                _backImg.width = CommonDef.WINDOW_W * ratio;
            }
            else
            {
                _backImg.width = CommonDef.WINDOW_W;
                _backImg.height = CommonDef.WINDOW_H * ratio;
            }
            addChildAt(_backImg, 0);
        }
    }

}