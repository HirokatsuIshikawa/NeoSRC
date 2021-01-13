package viewitem.status.list
{
    import common.CommonDef;
    import database.user.GenericUnitData;
    import flash.geom.Point;
    import scene.unit.BattleUnit;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import system.custom.customSprite.CButton;
    import system.custom.customSprite.CImage;
    import database.user.UnitCharaData;
    import starling.events.Event;
    import main.MainController;
    import system.custom.customSprite.CSprite;
    import viewitem.parts.numbers.ImgNumber;
    import viewitem.status.list.UnitListBase;
    import viewitem.status.list.listitem.GenericOrganizeListItem;
    import viewitem.status.list.listitem.OrganizeListItem;
    import viewitem.status.list.listitem.OrganizeSelectIcon;
    
    /**
     * ...
     * @author ishikawa
     */
    public class OrganizeList extends UnitListBase
    {
        public static const TYPE_ALL:String = "ALL";
        public static const TYPE_UNIQUE:String = "UNIQUE";
        public static const TYPE_GENERIC:String = "GENERIC";
        public static const TYPE_UNIQUE_J:String = "ユニーク";
        public static const TYPE_GENERIC_J:String = "汎用";
        
        /**暗幕画像*/
        private var _itemList:Vector.<OrganizeListItem> = null;
        private var _genericItemList:Vector.<GenericOrganizeListItem> = null;
        private var _uniqueBtn:CButton = null;
        private var _genericBtn:CButton = null;
        private var _startBtn:CButton = null;
        private var _organizeCount:ImgNumber = null;
        private var _costCount:ImgNumber = null;
        
        private var _uniqueSpr:CSprite = null;
        private var _genericSpr:CSprite = null;
        
        //出撃リスト
        private var _organizeSpr:CSprite = null;
        private var _organizeUnitList:Vector.<OrganizeSelectIcon> = null;
        
        private var _unitCount:int = 0;
        private var _posX:int = 0;
        private var _posY:int = 0;
        private var _uWidth:int = 0;
        private var _uHeight:int = 0;
        private var _cost:int = 0;
        private var _maxCost:int = 0;
        
        public function OrganizeList(dataList:Vector.<UnitCharaData>, genericDataList:Vector.<GenericUnitData>, count:int, posX:int, posY:int, uWidth:int, uHeight:int, type:String, cost:int)
        {
            super();
            var i:int = 0;
            /**出撃領域に収まらない場合*/
            var num:int = (int)(Math.ceil(uWidth * uHeight / 2.0));
            if (num < count)
            {
                count = num;
            }
            
            _unitCount = count;
            _posX = posX;
            _posY = posY;
            _uWidth = uWidth;
            _uHeight = uHeight;
            _cost = cost;
            _maxCost = cost;
            
            var listCount:int = 0;
            
            //ユニークユニットリスト
            if (type.indexOf(TYPE_UNIQUE) >= 0 || type.indexOf(TYPE_UNIQUE_J) >= 0 || type.indexOf(TYPE_ALL) >= 0)
            {
                _uniqueSpr = new CSprite();
                _itemList = new Vector.<OrganizeListItem>;
                
                for (i = 0; i < dataList.length; i++)
                {
                    if (i == 0)
                    {
                        listCount++;
                    }
                    
                    if (dataList[i].launched)
                    {
                        continue;
                    }
                    
                    _itemList[i] = new OrganizeListItem(dataList[i], cost > 0,selectUniqueItem);
                    _itemList[i].x = 60 + (OrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
                    _itemList[i].y = (OrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
                    _uniqueSpr.addChild(_itemList[i]);
                }
                _uniqueSpr.visible = false;
                this.addChild(_uniqueSpr);
            }
            
            //汎用ユニットリスト
            if (type.indexOf(TYPE_GENERIC) >= 0 || type.indexOf(TYPE_GENERIC_J) >= 0 || type.indexOf(TYPE_ALL) >= 0)
            {
                _genericSpr = new CSprite();
                _genericItemList = new Vector.<GenericOrganizeListItem>;
                
                for (i = 0; i < genericDataList.length; i++)
                {
                    if (i == 0)
                    {
                        listCount++;
                    }
                    _genericItemList[i] = new GenericOrganizeListItem(genericDataList[i], cost > 0,selectGenericItem, true);
                    _genericItemList[i].x = 60 + (GenericOrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
                    _genericItemList[i].y = (GenericOrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
                    _genericSpr.addChild(_genericItemList[i]);
                }
                
                _genericSpr.visible = false;
                this.addChild(_genericSpr);
            }
            _startBtn = new CButton();
            _startBtn.label = "出撃";
            _startBtn.styleName = "bigBtn";
            _startBtn.x = 780;
            _startBtn.y = 480;
            _startBtn.width = 120;
            _startBtn.height = 40;
            _startBtn.addEventListener(Event.TRIGGERED, compOrganized);
            addChild(_startBtn);
            
            //ユニークのみの場合、最大出撃数をユニーク最大数に合わせる
            if (listCount == 1 && (type.indexOf(TYPE_UNIQUE) >= 0 || type.indexOf(TYPE_UNIQUE_J) >= 0))
            {
                _unitCount = _itemList.length;
            }
            
            //ネームドと汎用を併用する場合
            if (listCount >= 1)
            {
                if (type.indexOf(TYPE_UNIQUE) >= 0 || type.indexOf(TYPE_UNIQUE_J) >= 0 || type.indexOf(TYPE_ALL) >= 0)
                {
                    _uniqueBtn = new CButton();
                    _uniqueBtn.label = "ユニーク";
                    _uniqueBtn.styleName = "bigBtn";
                    _uniqueBtn.x = 640;
                    _uniqueBtn.y = 480;
                    _uniqueBtn.width = 120;
                    _uniqueBtn.height = 40;
                    _uniqueBtn.addEventListener(Event.TRIGGERED, selectUnique);
                    _uniqueBtn.visible = true;
                    _uniqueBtn.alpha = 0.8;
                    addChild(_uniqueBtn);
                }
                
                if (type.indexOf(TYPE_GENERIC) >= 0 || type.indexOf(TYPE_GENERIC_J) >= 0 || type.indexOf(TYPE_ALL) >= 0)
                {
                    _genericBtn = new CButton();
                    _genericBtn.label = "汎用";
                    _genericBtn.styleName = "bigBtn";
                    _genericBtn.x = 500;
                    _genericBtn.y = 480;
                    _genericBtn.width = 120;
                    _genericBtn.height = 40;
                    _genericBtn.addEventListener(Event.TRIGGERED, selectGeneric);
                    _genericBtn.visible = true;
                    _genericBtn.alpha = 0.8;
                    addChild(_genericBtn);
                }
                
                if (_uniqueBtn != null)
                {
                    _uniqueBtn.alpha = 1;
                }
                else if (_genericBtn != null)
                {
                    _genericBtn.alpha = 1;
                }
                
            }
            
            if (_uniqueSpr != null)
            {
                _uniqueSpr.visible = true;
            }
            else if (_genericSpr != null)
            {
                _genericSpr.visible = true;
            }
            
            
            _costCount = new ImgNumber();
            _costCount.x = 20;
            _costCount.y = CommonDef.WINDOW_H - 96;
            
            _organizeCount = new ImgNumber();
            _organizeCount.x = 20;
            _organizeCount.y = CommonDef.WINDOW_H - 48;
            
            //選択ユニットリスト
            _organizeSpr = new CSprite();
                _organizeSpr.addEventListener(TouchEvent.TOUCH, touchGenericSpr);
            _organizeSpr.width = 400;
            _organizeSpr.height = 32;
            _organizeSpr.x = 80;
            _organizeSpr.y = CommonDef.WINDOW_H - 48;
            
            _organizeUnitList = new Vector.<OrganizeSelectIcon>();
            
            addChild(_organizeSpr);
            
            checkOrganize();
        }
        
        public function checkOrganize():void
        {
            var count:int = 0;
            var i:int = 0;
            count = _organizeUnitList.length;
            
            for (i = 0; i < _organizeUnitList.length; i++)
            {
                _organizeUnitList[i].x = 32 * i;
            }
            
            if (count <= 0 || count > _unitCount)
            {
                _startBtn.isEnabled = false;
                _startBtn.alpha = 0.7;
            }
            else
            {
                _startBtn.isEnabled = true;
                _startBtn.alpha = 1;
            }
            checkItemSelect();
            _organizeCount.setMaxNumber(count, _unitCount);
            addChild(_organizeCount);
        }
        
        private function checkItemSelect():void
        {
            if (_maxCost <= 0)
            {
                return;
            }
            
            _cost = _maxCost;
            
            var i:int = 0;
            
            for (i = 0; i < _organizeUnitList.length; i++ )
            {
                if(_organizeUnitList[i].unitCharaData != null)
                {
                    _cost -= _organizeUnitList[i].unitCharaData.masterData.Cost;
                }
                else if (_organizeUnitList[i].genericUnitData != null)
                {
                    _cost -= _organizeUnitList[i].genericUnitData.cost;
                }            
            }
            
            
            for (i = 0; i < _itemList.length; i++ )
            {
                if(_itemList[i].data.masterData.Cost > _cost)
                {
                    _itemList[i].alpha = 0.7;
                    _itemList[i].touchable = false;
                }
                else
                {
                    _itemList[i].alpha = 1;
                    _itemList[i].touchable = true;
                }
            }
            
            for (i = 0; i < _genericItemList.length; i++ )
            {
                if(_genericItemList[i].data.cost > _cost)
                {
                    _genericItemList[i].alpha = 0.7;
                    _genericItemList[i].touchable = false;
                }
                else
                {
                    _genericItemList[i].alpha = 1;
                    _genericItemList[i].touchable = true;
                }
            }
            
            
            _costCount.setMaxNumber(_cost, _maxCost)
        }
        
        
        override public function dispose():void
        {
            var i:int = 0;
            if (_itemList != null)
            {
                for (i = 0; i < _itemList.length; i++)
                {
                    _uniqueSpr.removeChild(_itemList[i]);
                    _itemList[i].dispose();
                    _itemList[i] = null;
                }
            }
            
            if (_genericItemList != null)
            {
                for (i = 0; i < _genericItemList.length; i++)
                {
                    _genericSpr.removeChild(_genericItemList[i]);
                    _genericItemList[i].dispose();
                    _genericItemList[i] = null;
                }
            }
            
            if (_organizeSpr != null)
            {
                _organizeSpr.removeEventListener(TouchEvent.TOUCH, touchGenericSpr);
            }
            
            
            CommonDef.disposeList([_uniqueSpr, _genericSpr, _organizeSpr]);
            if (_startBtn != null)
            {
                removeChild(_startBtn);
                _startBtn.removeEventListener(Event.TRIGGERED, compOrganized);
                _startBtn.dispose();
            }
            if (_uniqueBtn != null)
            {
                removeChild(_uniqueBtn);
                _uniqueBtn.removeEventListener(Event.TRIGGERED, selectUnique);
                _uniqueBtn.dispose();
            }
            if (_genericBtn != null)
            {
                removeChild(_genericBtn);
                _genericBtn.removeEventListener(Event.TRIGGERED, selectGeneric);
                _genericBtn.dispose();
            }
            
            _startBtn = null;
            _uniqueBtn = null;
            _genericBtn = null;
            
            super.dispose();
        }
        
        private function compOrganized(e:Event):void
        {
            MainController.$.map.startOrganized(_organizeUnitList);
        }
        
        //ユニークボタン選択
        private function selectUnique(e:Event):void
        {
            _genericSpr.visible = false;
            _uniqueSpr.visible = true;
            _genericBtn.alpha = 0.8;
            _uniqueBtn.alpha = 1;
        }
        
        //汎用ボタン選択
        private function selectGeneric(e:Event):void
        {
            _genericSpr.visible = true;
            _uniqueSpr.visible = false;
            _genericBtn.alpha = 1;
            _uniqueBtn.alpha = 0.8;
        }
        
        //ユニークユニットアイテム選択
        private function selectUniqueItem(data:UnitCharaData, isSelect:Boolean):void
        {
            var i:int = 0;
            if (isSelect)
            {
                var icon:OrganizeSelectIcon = new OrganizeSelectIcon(data, null);
                icon.x = _organizeUnitList.length * 32;
                _organizeUnitList.push(icon);
                _organizeSpr.addChild(icon);
            }
            else
            {
                for (i = 0; i < _organizeUnitList.length; i++)
                {
                    if (_organizeUnitList[i].unitCharaData != null)
                    {
                        if (_organizeUnitList[i].unitCharaData === data)
                        {
                            var getData:OrganizeSelectIcon = _organizeUnitList.splice(i, 1)[0];
                            getData.dispose();
                            getData = null;
                            break;
                        }
                    }
                }
            }
            checkOrganize();
        }
        
        //汎用ユニットアイテム選択
        private function selectGenericItem(genericData:GenericUnitData, isSelect:Boolean):void
        {
            if (_unitCount <= _organizeUnitList.length)
            {
                return;
            }
            
            var icon:OrganizeSelectIcon = new OrganizeSelectIcon(null, genericData);
            icon.x = _organizeUnitList.length * 32;
            _organizeUnitList.push(icon);
            _organizeSpr.addChild(icon);
            checkOrganize();
        }
        
        private function touchGenericSpr(e:TouchEvent):void
        {
            var touch:Touch = e.getTouch(_organizeSpr);
            //タッチしているか
            if (touch)
            {
                //クリック上げた時
                switch (touch.phase)
                {
                //ボタン離す
                case TouchPhase.ENDED: 
                    resetOrganizeItem(_organizeSpr.globalToLocal(new Point(touch.globalX, touch.globalY)));
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
            }
        }
        
        private function resetOrganizeItem(pos:Point):void
        {
            var i:int = 0;
            var num:int = pos.x / 32;
            var getData:OrganizeSelectIcon = null;
            
            if (_organizeUnitList.length > num)
            {
                if (_organizeUnitList[num].unitCharaData != null)
                {
                    for (i = 0; i < _itemList.length; i++)
                    {
                        if (_itemList[i].data === _organizeUnitList[num].unitCharaData)
                        {
                            _itemList[i].setSelected(false);
                            break;
                        }
                    }
                }
                
                getData = _organizeUnitList.splice(num, 1)[0];
                getData.dispose();
                getData = null;
                
            }
            checkOrganize();
        }
        
        public function get posX():int
        {
            return _posX;
        }
        
        public function get posY():int
        {
            return _posY;
        }
        
        public function get itemList():Vector.<OrganizeListItem>
        {
            return _itemList;
        }
        
        public function get uWidth():int
        {
            return _uWidth;
        }
        
        public function get uHeight():int
        {
            return _uHeight;
        }
    
    }

}