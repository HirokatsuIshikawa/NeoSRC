package scene.unit
{
    import common.CommonDef;
    import common.CommonSystem;
    import database.user.CommanderData;
    import scene.commander.CommanderSkillListItem;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import database.master.MasterSkillData;
    import flash.geom.Point;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import main.MainController;
    import scene.map.BattleMap;
    import scene.map.panel.BattleMapPanel;
    
    /**
     * ...
     * @author ...
     */
    public class SkillListPanel extends CSprite
    {
        
        public static const BTN_WIDTH:int = 160;
        private var _pushPos:int = 0;
        private var _pushFlg:Boolean = false;
        
        //-------------------------------------------------------------
        //
        // construction
        //
        //-------------------------------------------------------------
        public function SkillListPanel()
        {
            var i:int = 0;
            _btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _btnBack.x = BattleMapPanel.RIGHT_SIDE;
            _btnBack.y = BattleMapPanel.UNDER_LINE;
            _btnBack.addEventListener(Event.TRIGGERED, pushBackBtn);
            super();
        }
        
        // スキル一覧セット
        public function setSkill(unit:BattleUnit):void
        {
            var datalist:Vector.<MasterSkillData> = unit.masterData.skillDataList;
            _counterEnable = false;
            var i:int = 0;
            var count:int = 0;
            if (_itemList != null)
            {
                removeItemList();
                _itemList = null;
            }
            
            _baseSpr = new CSprite();
            _baseSpr.addEventListener(TouchEvent.TOUCH, touchSpr);
            
            addChild(_baseSpr);
            _itemList = new Vector.<SkillListItem>;
            for (i = 0; i < datalist.length; i++)
            {
                var skillItem:SkillListItem = new SkillListItem(datalist[i], unit);
                
                skillItem.x = (CommonDef.WINDOW_W - skillItem.width) / 2;
                skillItem.y = count * 140;
                skillItem.addEventListener(TouchEvent.TOUCH, touchFunc);
                skillItem.alpha = 1;
                skillItem.enable = true;
                
                //使用回数
                if (datalist[i].maxCount > 0)
                {
                    if (datalist[i].useCount <= 0)
                    {
                        skillItem.enable = false;
                        skillItem.alpha = 0.5;
                    }
                }
                
                //消費エネルギー
                if (datalist[i].useFp > 0)
                {
                    if (unit.nowFp < datalist[i].useFp)
                    {
                        skillItem.enable = false;
                        skillItem.alpha = 0.5;
                    }
                }
                
                //必要TP
                if (datalist[i].enableTp > 0)
                {
                    if (unit.nowTp < datalist[i].enableTp)
                    {
                        skillItem.enable = false;
                        skillItem.alpha = 0.5;
                    }
                }
                
                //消費TP
                if (datalist[i].useTp > 0)
                {
                    if (unit.nowTp < datalist[i].useTp)
                    {
                        skillItem.enable = false;
                        skillItem.alpha = 0.5;
                    }
                }
                
                _baseSpr.addChild(skillItem);
                _itemList.push(skillItem);
                count++;
            }
            
            if (MainController.$.map.selectSide == 0)
            {
                
                addChild(_btnBack);
            }
            else
            {
                removeChild(_btnBack);
            }
        }
        
        //-------------------------------------------------------------
        //
        // override
        //
        //-------------------------------------------------------------
        override public function dispose():void
        {
            
            removeItemList();
            
            CommonDef.disposeList([_itemList, _btnBack, _baseSpr]);
            /*
               _btnBack.removeEventListener(Event.TRIGGERED, pushBackBtn);
               _btnBack.dispose()
               _btnBack = null;
               _selectSkill = null;
               _baseSpr.removeEventListener(TouchEvent.TOUCH, touchSpr);
               _baseSpr.dispose();
               _baseSpr = null;
             */
            _selectSkill = null;
            super.dispose();
        }
        
        public function removeItemList():void
        {
            var i:int = 0;
            if (_itemList != null)
            {
                for (i = 0; i < _itemList.length; i++)
                {
                    _itemList[i].removeEventListener(TouchEvent.TOUCH, touchFunc);
                    _itemList[i].dispose();
                    _itemList[i] = null;
                }
            }
        
        }
        
        //-------------------------------------------------------------
        //
        // component
        //
        //-------------------------------------------------------------
        private var _itemList:Vector.<SkillListItem> = null;
        private var _baseSpr:CSprite = null;
        private var _btnBack:CImgButton = null;
        private var _selectSkill:MasterSkillData = null;
        private var _counterEnable:Boolean = false;
        
        //-------------------------------------------------------------
        //
        // variable
        //
        //-------------------------------------------------------------
        //-------------------------------------------------------------
        //
        // event handler
        //
        //-------------------------------------------------------------
        /**タッチイベント*/
        public function touchFunc(e:TouchEvent):void
        {
            var target:SkillListItem = e.currentTarget as SkillListItem;
            if (target.enable == false)
            {
                return;
            }
            
            var touch:Touch = e.getTouch(target, TouchPhase.ENDED);
            _selectSkill = target.data;
            if (touch != null)
            {
                //クリック上げた時
                switch (touch.phase)
                {
                //ボタン離す
                case TouchPhase.ENDED: 
                    if (_pushFlg)
                    {
                        var pos:Point = touch.getLocation(target);
                        if (target.hitTest(pos))
                        {
                            _selectSkill = target.data;
                            MainController.$.view.battleMap.makeSkillArea(target.data, _selectSkill.target);
                        }
                    }
                    _pushFlg = false;
                    break;
                //マウスオーバー
                case TouchPhase.HOVER: 
                    break;
                case TouchPhase.STATIONARY: 
                    break;
                //ドラッグ
                case TouchPhase.MOVED: 
                    break;
                //押した瞬間
                case TouchPhase.BEGAN: 
                    break;
                }
                
                    //if (MainController.$.view.battleMap.selectSide == 0)
                    //{
                    //MainController.$.view.battleMap.makeAttackArea(target.data);
                    //}
                    //else
                    //{
                    //MainController.$.view.battleMap.selectCounterWeapon(target.data);
                    //}
            }
        }
        
        /**タッチイベント*/
        public function touchSpr(e:TouchEvent):void
        {
            /*
               if (_baseSpr.height < CommonDef.WINDOW_H)
               {
               return;
               }
             */
            var target:CSprite = e.currentTarget as CSprite;
            var touch:Touch = e.getTouch(target);
            if (touch != null)
            {
                //クリック上げた時
                switch (touch.phase)
                {
                //ボタン離す
                case TouchPhase.ENDED: 
                    break;
                //マウスオーバー
                case TouchPhase.HOVER: 
                    break;
                case TouchPhase.STATIONARY: 
                    break;
                //ドラッグ
                case TouchPhase.MOVED:
                    
                    if (_baseSpr.height < CommonDef.WINDOW_H)
                    {
                        return;
                    }
                    
                    var pos:Point = globalToLocal(new Point(touch.globalX, touch.globalY));
                    var addPos:int = touch.globalY - touch.previousGlobalY;
                    if (_baseSpr.y + addPos >= 0)
                    {
                        _baseSpr.y = 0;
                    }
                    else if (_baseSpr.y + addPos <= -(_baseSpr.height - CommonDef.WINDOW_H))
                    {
                        _baseSpr.y = -(_baseSpr.height - CommonDef.WINDOW_H);
                    }
                    else
                    {
                        _baseSpr.y += addPos;
                    }
                    
                    if (Math.abs(_pushPos - touch.globalY) >= 4)
                    {
                        _pushFlg = false;
                    }
                    break;
                //押した瞬間
                case TouchPhase.BEGAN: 
                    _pushFlg = true;
                    _pushPos = touch.globalY;
                    break;
                }
            }
        }
        
        /**武器リスト戻る*/
        public function pushBackBtn(e:Event):void
        {
            MainController.$.view.battleMap.removeSkillList();
        }
        
        public function get selectSkill():MasterSkillData
        {
            return _selectSkill;
        }
        
        public function get counterEnable():Boolean
        {
            return _counterEnable;
        }
    
        //-------------------------------------------------------------
        //
        // private function
        //
        //-------------------------------------------------------------
        //-------------------------------------------------------------
        //
        // public function
        //
        //-------------------------------------------------------------
    
    }

}