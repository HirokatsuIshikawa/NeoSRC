package database.user
{
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
        public var lv:int = 0;
        
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
            _masterData = masterData;
            lv = setLv;
        }
        
        public function get name():String
        {
            return _masterData.name;
        }
        
        public function get nickName():String
        {
            return _masterData.nickName;
        }
        
        public function addLevel(num:int):void
        {
            lv += num;
        }
        
        public function setLevel(num:int):void
        {
            lv = num;
        }
    
    }

}