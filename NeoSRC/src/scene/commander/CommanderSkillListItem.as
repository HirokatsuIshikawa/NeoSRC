package scene.commander
{
    import common.CommonDef;
    import database.master.MasterCommanderSkillData;
    import database.master.MasterSkillData;
    import database.master.MasterWeaponData;
    import database.user.CommanderData;
    import scene.main.MainController;
    import starling.textures.Texture;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CTextArea;
    import viewitem.parts.numbers.ImgNumber;
    import viewitem.status.list.listitem.ListItemBase;
    
    /**
     * ...
     * @author ...
     */
    public class CommanderSkillListItem extends ListItemBase
    {
        // 名前
        private var _name:CTextArea = null;
        
        // 回復値
        private var _healImg:CImage = null;
        private var _healValue:ImgNumber = null;
        
        // 補給値
        private var _supplyImg:CImage = null;
        private var _supplyValue:ImgNumber = null;
        
        // 射程
        private var _RangeImg:CImage = null;
        private var _RangeMinValue:ImgNumber = null;
        private var _RangeMaxValue:ImgNumber = null;
        private var _RangeBetween:CImage = null;
        
        // 対象
        private var _targetImg:CImage = null;
        private var _targetValue:CImage = null;
        
        //消費FP
        private var _useSpMark:CImage = null;
        private var _useSp:ImgNumber = null;
        
        //使用回数
        private var _useCountMark:CImage = null;
        private var _useCount:ImgNumber = null;
        private var _CountSlashMark:CImage = null;
        private var _maxCount:ImgNumber = null;
        
        //使用TP
        private var _useTpMark:CImage = null;
        private var _useTp:ImgNumber = null;
        
        // 地形
        private var _capImg:Vector.<CImage> = null;
        private var _capState:Vector.<CImage> = null;
        
        private var _data:MasterCommanderSkillData = null;
        
        //-------------------------------------------------------------
        //
        // construction
        //
        //-------------------------------------------------------------
        public function CommanderSkillListItem(data:MasterCommanderSkillData, commander:CommanderData)
        {
            super(640, 140);
            var i:int = 0;
            var nextPosX:int = 0;
            var nextPosY:int = 8;
            _data = data;
            /////////////////////////////////////////一段目/////////////////////////////////////////
            //武器名
            _name = new CTextArea(24, 0xFFFFFF);
            _name.styleName = "custom_text";
            _name.width = 240;
            _name.height = 32;
            _name.x = 8;
            _name.y = nextPosY;
            _name.text = data.name + "";
            addChild(_name);
            
            nextPosY = 46;
            
            /////////////////////////////////////////二段目/////////////////////////////////////////
            
            //回復
            if (data.heal > 0)
            {
                var heal:int = (int)(data.heal);
                _healImg = new CImage(MainController.$.imgAsset.getTexture("Skl_heal"));
                _healImg.x = 8;
                _healImg.y = nextPosY;
                addChild(_healImg);
                nextPosX = _healImg.x + _healImg.width;
                
                _healValue = new ImgNumber();
                if (data.heal <= 0)
                {
                    _healValue.setNone(heal);
                }
                else
                {
                    _healValue.setNumber(heal);
                }
                _healValue.x = nextPosX;
                _healValue.y = nextPosY;
                addChild(_healValue);
                nextPosX = _healValue.x + _healValue.width + 32;
            }
            
            //補給
            if (data.supply > 0)
            {
                var supply:int = (int)(data.supply);
                _supplyImg = new CImage(MainController.$.imgAsset.getTexture("Skl_spl"));
                _supplyImg.x = nextPosX;
                _supplyImg.y = nextPosY;
                addChild(_supplyImg);
                nextPosX = _supplyImg.x + _supplyImg.width;
                
                _supplyValue = new ImgNumber();
                if (data.supply <= 0)
                {
                    _supplyValue.setNone(supply);
                }
                else
                {
                    _supplyValue.setNumber(supply);
                }
                _supplyValue.x = nextPosX;
                _supplyValue.y = nextPosY;
                addChild(_supplyValue);
                nextPosX = _supplyValue.x + _supplyValue.width + 32;
            }
            
            if (data.target != MasterSkillData.SKILL_TARGET_ALL)
            {
                //対象
                _targetImg = new CImage(MainController.$.imgAsset.getTexture("Skl_target"));
                _targetImg.x = nextPosX;
                _targetImg.y = nextPosY;
                addChild(_targetImg);
                nextPosX = _targetImg.x + _targetImg.width;
                
                var tex:Texture = null;
                
                switch (data.target)
                {
                case MasterSkillData.SKILL_TARGET_ALL: 
                    //tex = MainController.$.imgAsset.getTexture("Skl_Tgt_All");
                    break;
                case MasterSkillData.SKILL_TARGET_ALLY: 
                    tex = MainController.$.imgAsset.getTexture("Tgt_ally");
                    break;
                case MasterSkillData.SKILL_TARGET_ENEMY: 
                    tex = MainController.$.imgAsset.getTexture("Tgt_enemy");
                    break;
                }
                
                _targetValue = new CImage(tex);
                _targetValue.x = nextPosX;
                _targetValue.y = nextPosY;
                addChild(_targetValue);
                nextPosX = _targetValue.x + _targetValue.width;
                nextPosX += 32;
            }
            
            
            ///////////////////////////////////////////////2段目//////////////////////////////////////////
            nextPosX = 8;
            nextPosY = 80;
            
            //FP表示
            if (data.useSp > 0)
            {
                _useSpMark = new CImage(MainController.$.imgAsset.getTexture("Wpn_Sp"));
                _useSpMark.x = nextPosX;
                _useSpMark.y = nextPosY;
                addChild(_useSpMark);
                nextPosX = _useSpMark.x + _useSpMark.width;
                
                _useSp = new ImgNumber();
                _useSp.x = nextPosX;
                _useSp.y = nextPosY;
                _useSp.setNumber(data.useSp);
                addChild(_useSp);
                nextPosX = _useSp.x + _useSp.width;
            }
            
            //回数表示
            if (data.maxCount > 0)
            {
                _useCountMark = new CImage(MainController.$.imgAsset.getTexture("Wpn_Count"));
                _useCountMark.x = nextPosX;
                _useCountMark.y = nextPosY;
                addChild(_useCountMark);
                nextPosX = _useCountMark.x + _useCountMark.width;
                
                _useCount = new ImgNumber();
                _useCount.x = nextPosX;
                _useCount.y = nextPosY;
                _useCount.setNumber(data.useCount);
                addChild(_useCount);
                nextPosX = _useCount.x + _useCount.width;
                
                _CountSlashMark = new CImage(MainController.$.imgAsset.getTexture("slash"));
                _CountSlashMark.x = nextPosX;
                _CountSlashMark.y = nextPosY;
                addChild(_CountSlashMark);
                nextPosX = _CountSlashMark.x + _CountSlashMark.width;
                
                _maxCount = new ImgNumber();
                _maxCount.x = nextPosX;
                _maxCount.y = nextPosY;
                _maxCount.setNumber(data.maxCount);
                addChild(_maxCount);
                nextPosX = _maxCount.x + _maxCount.width;
            }
            
            
            ///////////////////////////////////////////////3段目//////////////////////////////////////////
            nextPosX = 8;
            nextPosY = 112;
            
            _capImg = new Vector.<CImage>;
            _capState = new Vector.<CImage>;
            
            var stateList:Vector.<String> = new Vector.<String>;
            
            stateList[MasterWeaponData.WPN_CAP_OTHER] = "Wpn_CapOther";
            stateList[MasterWeaponData.WPN_CAP_SKY] = "Wpn_CapSky";
            stateList[MasterWeaponData.WPN_CAP_GROUND] = "Wpn_CapGround";
            stateList[MasterWeaponData.WPN_CAP_WATER] = "Wpn_CapWater";
            
            //地形対応
            for (i = 0; i < 4; i++)
            {
                _capImg[i] = new CImage(MainController.$.imgAsset.getTexture(stateList[i]));
                _capImg[i].x = nextPosX;
                _capImg[i].y = nextPosY;
                addChild(_capImg[i]);
                nextPosX = _capImg[i].x + _capImg[i].width;
                
                var state:String = null;
                
                if (data.terrain[i] < 5)
                {
                    state = CommonDef.TERRAIN_IMG[data.terrain[i]];
                }
                else
                {
                    state = CommonDef.TERRAIN_IMG[data.terrain[5]];
                }
                
                _capState[i] = new CImage(MainController.$.imgAsset.getTexture(state));
                _capState[i].x = nextPosX;
                _capState[i].y = nextPosY;
                addChild(_capState[i]);
                nextPosX = _capState[i].x + _capState[i].width + 12;
            }
        }
        
        override public function dispose():void
        {
            var i:int = 0;
            _name.dispose();
            
            CommonDef.disposeList([_RangeMinValue, _RangeImg, _RangeMaxValue, _RangeBetween, //
            _targetImg, _targetValue, _healImg, _healValue, _supplyImg, _supplyValue, //
            _useCount, _maxCount, _useCountMark, _CountSlashMark, _useSp, _useSpMark, _useTp, _useTpMark, _useCountMark, _CountSlashMark,]);
            /*
               if (_RangeMinValue != null)
               {
               _RangeMinValue.dispose();
               }
               if (_RangeImg != null)
               {
               _RangeImg.dispose();
               }
               if (_RangeMaxValue != null)
               {
               _RangeMaxValue.dispose();
               }
               if (_RangeBetween != null)
               {
               _RangeBetween.dispose();
               }
            
               if (_targetImg != null)
               {
            
               _targetImg.dispose();
               _targetValue.dispose();
               }
            
               if (_healImg != null)
               {
            
               _healImg.dispose();
               _healValue.dispose();
               }
            
               if (_supplyImg != null)
               {
            
               _supplyImg.dispose();
               _supplyValue.dispose();
               }
            
               if (_useCount != null)
               {
               _useCount.dispose();
               _maxCount.dispose();
               _useCountMark.dispose();
               _CountSlashMark.dispose();
               }
            
               if (_useFp != null)
               {
            
               _useFp.dispose();
               _useFpMark.dispose();
               }
            
               if (_useTp != null)
               {
            
               _useTp.dispose();
               _useTpMark.dispose();
               }
            
               CommonDef.disposeList([_capImg, _capState]);
            
               _RangeImg = null;
               _RangeMinValue = null;
               _RangeBetween = null;
               _RangeMaxValue = null;
            
               _targetImg = null;
               _targetValue = null;
            
               _healImg = null;
               _healValue = null;
            
               _supplyImg = null;
               _supplyValue = null;
            
               _useFp = null;
               _useFpMark = null;
            
               _useTp = null;
               _useTpMark = null;
            
               _useCount = null;
               _maxCount = null;
               _useCountMark = null;
               _CountSlashMark = null
             */
            super.dispose();
        }
        
        public function get data():MasterCommanderSkillData
        {
            return _data;
        }
        //-------------------------------------------------------------
        //
        // component
        //
        //-------------------------------------------------------------
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