package scene.map.customdata
{
    import common.CommonDef;
    import database.user.CommanderData;
    import scene.unit.BattleUnit;
    
    /**
     * ...
     * @author ishikawa
     */
    public class SideState
    {
        public static const STATE_DEAD:int = 0;
        public static const STATE_LIVE:int = 1;
        
        private var _name:String = null;
        private var _state:int = 0;
        
        /** 各勢力ユニットリスト */
        private var _battleUnit:Vector.<BattleUnit> = null;
        
        /**軍師*/
        private var _commander:CommanderData = null;
        
        public function SideState(setName:String)
        {
            _name = setName;
            _state = STATE_LIVE;
            _battleUnit = new Vector.<BattleUnit>();
        }
        
        /**ユニット追加*/
        public function addUnit(unit:BattleUnit):void
        {
            _battleUnit.push(unit);
        }
        
        public function setCommander(commander:CommanderData):void
        {
            _commander = commander;
            setCommanderParam();
        }
        
        public function clearCommander():void
        {
            _commander = null;
            setCommanderParam();
        }
        
        /**軍師バフセット*/
        public function setCommanderParam():void
        {
            var i:int = 0;
            //ターン開始時の回復
            for (i = 0; i < battleUnit.length; i++)
            {
                /**レベルステータスリセット*/
                battleUnit[i].levelStatusReset();
                //パラメータセット
                battleUnit[i].commanderStatusSet(commander);
            }
        }
        
        public function dispose():void
        {
            CommonDef.disposeList([_battleUnit]);
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function get state():int
        {
            return _state;
        }
        
        public function set state(value:int):void
        {
            _state = value;
        }
        
        public function get commander():CommanderData
        {
            return _commander;
        }
        
        public function get battleUnit():Vector.<BattleUnit>
        {
            return _battleUnit;
        }
    
    }

}