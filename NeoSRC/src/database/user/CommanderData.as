package database.user
{
    import database.master.MasterCharaData;
    import database.master.MasterCommanderData;
    import database.master.base.BaseParam;
    
    /**
     * ...
     * @author ...
     */
    public class CommanderData
    {
        
        private var _masterData:MasterCommanderData = null;
        
        /**パラメーター*/
        private var _param:BaseParam = null;
        /**HP*/
        private var _HP:int = 0;
        /**FP*/
        private var _FP:int = 0;
        /**策略ポイント*/
        private var _Point:int = 0;
        /**ターン回復*/
        private var _Heal:int = 0;
        /**ターン補給*/
        private var _Supply:int = 0;
        /**命中*/
        private var _HIT:int = 0;
        /**回避*/
        private var _EVA:int = 0;
        /**レベル*/
        private var _nowLv:int = 0;
        
        public function get masterData():MasterCommanderData
        {
            return _masterData;
        }
        
        public function get param():BaseParam
        {
            return _param;
        }
        
        public function CommanderData(masterData:MasterCommanderData, setLv:int)
        {
            _param = new BaseParam();
            _masterData = masterData;
            _nowLv = setLv;
            levelSet(_nowLv);
        }
        
        public function get name():String
        {
            return _masterData.name;
        }
        
        public function get nickName():String
        {
            return _masterData.nickName;
        }
        
        public function get nowLv():int 
        {
            return _nowLv;
        }
        
        public function get Point():int 
        {
            return _Point;
        }
        
        public function set nowLv(value:int):void 
        {
            _nowLv = value;
        }
        
        public function addLevel(num:int):void
        {
            _nowLv += num;
            levelSet(_nowLv);
        }
        
        public function setLevel(num:int):void
        {
            _nowLv = num;
            levelSet(_nowLv);
        }
        
        public function resetLevelStatus():void
        {
            levelSet(_nowLv);
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
            
            lv = setLv;
            
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
        
        
    
    }

}