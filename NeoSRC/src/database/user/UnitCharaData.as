package database.user
{
    import common.CommonSystem;
    import database.master.MasterBuffData;
    import database.master.MasterCharaData;
    import database.master.base.BaseParam;
    import database.user.buff.CharaBuffData;
    import flash.filesystem.File;
    import scene.main.MainController;
    
    /**
     * ...
     * @author ishikawa
     */
    public class UnitCharaData
    {
        /**識別ID*/
        private var _id:int = 0;
        /**名前*/
        private var _name:String = "";
        /**ユニット画像*/
        //private var _imgNameList:Vector.<String> = null;
        /**移動状態*/
        private var _moveState:int = 0;
        /**出撃中*/
        private var _launched:Boolean = false;
        
        /**強化ポイント*/
        protected var _strengthPoint:int = 0;
        /**カスタムBGMパス*/
        protected var _customBgmPath:String = null;
        
        /**経験値*/
        protected var _exp:int = 0;
        /**レベル*/
        protected var _nowLv:int = 1;
        
        //パッシブスキル
        protected var _passiveList:Vector.<CharaBuffData> = null;
        
        /**基本パラメータ*/
        public function get param():BaseParam
        {
            return _param;
        }
        
        private var _param:BaseParam = null;
        
        private var _HP:int = 0;
        private var _FP:int = 0;
        
        public function get name():String
        {
            return _name;
        }
        
        public function get masterData():MasterCharaData
        {
            return _masterData;
        }
        
        public function get id():int
        {
            return _id;
        }
        
        /**地形適正*/
        private var _terrain:Vector.<int> = null;
        
        public function get terrain():Vector.<int>
        {
            return _terrain;
        }
        
        /**ユニット編成数*/
        public function get maxFormationNum():int
        {
            return _masterData.maxFormationNum;
        }
        
        public function get unitSize():int
        {
            return _masterData.unitSize;
        }
        
        public function get showLv():int
        {
            return _masterData.baseLv + _nowLv;
        }
        
        
        public function get nowLv():int
        {
            return _nowLv;
        }
        
        public function set showName(value:String):void
        {
            _name = value;
        }
        
        public function set nowLv(value:int):void
        {
            _nowLv = value;
        }
        
        public function get exp():int
        {
            return _exp;
        }
        
        public function set exp(value:int):void
        {
            _exp = value;
        }
        
        public function get moveState():int
        {
            return _moveState;
        }
        
        public function set moveState(value:int):void
        {
            _moveState = value;
        }
        
        public function get launched():Boolean
        {
            return _launched;
        }
        
        public function set launched(value:Boolean):void
        {
            _launched = value;
        }
        
        public function get strengthPoint():int
        {
            return _strengthPoint;
        }
        
        public function get customBgmPath():String
        {
            return _customBgmPath;
        }
        
        public function get customBgmHeadPath():String
        {
            if (_customBgmPath == null)
            {
                return null;
            }
            else
            {
                return CommonSystem.FILE_HEAD + _customBgmPath;
            }
        }
        
        public function set customBgmPath(value:String):void
        {
            _customBgmPath = value;
        }
        
        public function get HP():int
        {
            return _HP;
        }
        
        public function set HP(value:int):void
        {
            _HP = value;
        }
        
        public function get FP():int
        {
            return _FP;
        }
        
        public function set FP(value:int):void
        {
            _FP = value;
        }
        
        private var _posX:int = 0;
        private var _posY:int = 0;
        
        private var _masterData:MasterCharaData = null;
        
        public function UnitCharaData(id:int, data:MasterCharaData, lv:int):void
        {
            var i:int = 0;
            _id = id;
            _name = data.name;
            _masterData = data;
            _terrain = new Vector.<int>;
            _param = new BaseParam();
            _passiveList = new Vector.<CharaBuffData>();
            

            //パッシブスキル
            if (data.passiveList != null)
            {
                for (i = 0; i < data.passiveList.length; i++)
                {
                    var buff:CharaBuffData = data.passiveList[i];
                    _passiveList.push(buff);
                }
            }
            
            //地形データ
            for (i = 0; i < 4; i++)
            {
                _terrain[i] = data.terrain[i];
            }
            
            levelSet(lv);
            _HP = param.HP;
            _FP = param.FP;
        }
        
        /**レベルアップ*/
        public function levelUp(lv:int):void
        {
            levelSet(_nowLv + lv);
        }
        
        /**レベルセット*/
        public function levelSet(lv:int):void
        {
            var i:int = 0;
            var setLv:int = lv;
            if (setLv > _masterData.MaxLv)
            {
                setLv = _masterData.MaxLv;
            }
            
            _nowLv = setLv;
            
            // ステータスレシオ
            var ratio:Number;
            if (_masterData.MaxLv == 0)
            {
                ratio = 1;
            }
            else
            {
                ratio = (setLv - 1.0) / (_masterData.MaxLv - 1.0);
            }
            
            for (i = 0; i < MasterCharaData.DATA_TYPE.length; i++)
            {
                var str:String = MasterCharaData.DATA_TYPE[i];
                var addPoint:int = Math.floor((_masterData.maxParam[str] - _masterData.minParam[str]) * ratio);
                
                var point:int = _masterData.minParam[str] + addPoint;
                this.param[BaseParam.STATUS_STR[i]] = point;
            }
        }
        
        public function addStrength(num:int = 1):void
        {
            _strengthPoint += num;
        }
        
        public function setStrength(num:int):void
        {
            _strengthPoint = num;
        }
    
    }

}