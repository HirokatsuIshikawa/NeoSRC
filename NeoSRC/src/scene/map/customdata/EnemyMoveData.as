package scene.map.customdata
{
    import database.master.MasterWeaponData;
    import scene.base.BaseTip;
    import scene.map.customdata.SideState;
    import scene.unit.BattleUnit;
    
    /**
     * ...
     * @author ishikawa
     */
    public class EnemyMoveData
    {
        
        /** 移動優先度 */
        private var _priority:int = 0;
        
        private var _movePosX:int = 0;
        private var _movePosY:int = 0;
        private var _distance:int = 0;
        private var _selectWeapon:MasterWeaponData = null;
        private var _targetSide:int = 0;
        private var _targetNum:int = 0;
        
        public function EnemyMoveData()
        {
        
        }
        
        public function getPriority(posX:int, posY:int, stayFlg:Boolean, unit:BattleUnit, target:Vector.<SideState>, baseList:Vector.<BaseTip>,side:int):void
        {
            var i:int = 0;
            var j:int = 0;
            _movePosX = posX;
            _movePosY = posY;
            // 全ユニットを検索
            for (i = 0; i < target.length; i++)
            {
                if (i == side)
                {
                    continue;
                }
                
                //目標ごとに設定
                for (j = 0; j < target[i].battleUnit.length; j++)
                {
                    if (!target[i].battleUnit[j].moveEnable())
                    {
                        continue;
                    }
                    
                    var targetUnit:BattleUnit = target[i].battleUnit[j];
                    var setPriority:int = 0;
                    var distance:int = Math.abs(posX - (target[i].battleUnit[j].PosX - 1)) + Math.abs(posY - (target[i].battleUnit[j].PosY - 1));
                    
                    var weaponNum:int = -1;
                    
                    // 近いほど優先度をあげる
                    setPriority += (99 - distance);
                    
                    //使用武器番号取得
                    weaponNum = getWeaponNum(unit, distance, stayFlg);
                    
                    //武器がある場合
                    if (weaponNum >= 0)
                    {
                        setPriority += unit.weaponList[weaponNum].value * 10;
                    }
                    
                    // 優先度変更
                    if (_priority == 0 || setPriority > _priority)
                    {
                        _distance = distance;
                        _targetSide = i;
                        _targetNum = j;
                        if (weaponNum >= 0)
                        {
                            _selectWeapon = unit.weaponList[weaponNum];
                        }
                        else
                        {
                            _selectWeapon = null;
                        }
                        _priority = setPriority;
                    }
                }
            }
        }
        
        /**武器優先度取得*/
        private function getWeaponNum(unit:BattleUnit, distance:int, stayFlg:Boolean):int
        {
            var k:int = 0;
            var weaponValue:int = 0;
            // 射程範囲内の最大攻撃力武器を選択
            for (k = 0; k < unit.weaponList.length; k++)
            {
                if (unit.weaponList[k].minRange <= distance && distance <= unit.weaponList[k].maxRange)
                {
                    //移動後武器の場合
                    if (!unit.weaponList[k].pWeapon && !stayFlg)
                    {
                        continue;
                    }
                    if (weaponValue < unit.weaponList[k].value)
                    {
                        return k;
                    }
                }
            }
            return -1;
        }
        
        public function get priority():int
        {
            return _priority;
        }
        
        public function get movePosX():int
        {
            return _movePosX;
        }
        
        public function get movePosY():int
        {
            return _movePosY;
        }
        
        public function get selectWeapon():MasterWeaponData
        {
            return _selectWeapon;
        }
        
        public function get targetSide():int
        {
            return _targetSide;
        }
        
        public function get targetNum():int
        {
            return _targetNum;
        }
        
        public function get distance():int
        {
            return _distance;
        }
    
    }
}