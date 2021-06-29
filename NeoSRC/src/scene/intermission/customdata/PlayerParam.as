package scene.intermission.customdata
{
    import common.CommonSystem;
    import system.custom.customData.CData;
    
    /**
     * ...
     * @author ishikawa
     */
    public class PlayerParam extends CData
    {
        
        public var money:int = 0;
        public var sideName:String = null;
        public var nextEve:String = null;
        public var nowEve:String = null;
        public var clearEve:String = null;
        public var playingMapBGM:String = null;
        public var playingMapBGMVol:Number = 1.0;
        public var keepBGMFlg:Boolean = false;
        
        public var intermissonData:Vector.<ShowInterMissionData> = null;
        public var intermissionBackURL:String = null;
        
        /**選択軍師名*/
        public var selectCommanderName:String;
        public var selectCommanderLv:int = 1;
        
        /** ローカル変数 */
        public var playerVariable:Vector.<PlayerVariable> = null;
        //勝利敗北条件
        public var victoryConditions:String = null;
        public var defeatConditions:String = null;
        
        public function PlayerParam()
        {
            sideName = "味方";
            intermissonData = new Vector.<ShowInterMissionData>();
            
            playerVariable = new Vector.<PlayerVariable>();
            
            victoryConditions = null;
            defeatConditions = null;
        }
        
        public function setIntermissionParam(name:String, state:int):void
        {
            var i:int = 0;
            for (i = 0; i < intermissonData.length; i++)
            {
                if (intermissonData[i].name === name)
                {
                    intermissonData.splice(i, 1);
                    break;
                }
            }
            
            if ((int)(CommonSystem.INTERMISSION_DATA[name].show) != state)
            {
                var interMissionItem:ShowInterMissionData = new ShowInterMissionData();
                interMissionItem.setState(name, state);
                intermissonData.push(interMissionItem);
            }
        }
        
        //グローバル以外の変数を削除
        public function refreshVariable():void
        {
            var i:int = 0;
            for (i = 0; i < playerVariable.length; i++)
            {
                if (!playerVariable[i].global)
                {
                    playerVariable[i] = null;
                    playerVariable.splice(i, 1);
                    i--;
                }
            }
            
            keepBGMFlg = false;
            victoryConditions = null
            defeatConditions = null;
            
        }
        
        override public function loadObject(data:Object):void
        {
            var i:int = 0;
            super.loadObject(data);
            var j:int = 0;
        }
    }
}