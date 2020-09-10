package database.master.base
{
    import database.master.MasterCommanderSkillData;
    import database.master.MasterSkillData;
    import database.master.MasterWeaponData;
    import database.user.CommanderData;
    import scene.unit.BattleUnit;
    
    /**
     * ...
     * @author ...
     */
    public class MessageCondition
    {
        public var message:Vector.<String>;
        
        /**HP率*/
        public var hpRateMin:int = 0;
        
        public var hpRateMax:int = 0;
        
        /**アクション名*/
        public var state:String = null;
        
        public var weaponName:String = null;
        public var skillName:String = null;
        
        /**相手名*/
        public var enemy:String = null;
        
        /**表示条件*/
        public function MessageCondition()
        {
            message = new Vector.<String>();
        }
        
        public function judge(callState:String, unit:BattleUnit, enemyUnit:BattleUnit, weapon:MasterWeaponData, skill:MasterSkillData):Boolean
        {
            var flg:Boolean = true;
            
            //行動タイプ名
            if (state != callState)
            {
                return false;
            }
            
            //武器名
            if (weapon != null)
            {
                if (weaponName != null)
                {
                    if (weaponName != weapon.name)
                    {
                        return false;
                    }
                }
            }
            //スキル名
            if (skill != null)
            {
                if (skillName != null)
                {
                    if (skillName != skill.name)
                    {
                        return false;
                    }
                }
            }
            
            //HP率
            if (hpRateMax > 0)
            {
                if (hpRateMax > unit.nowHp && unit.nowHp < hpRateMin)
                {
                    return false;
                }
            }
            
            //敵名
            if (enemy != null)
            {
                if (enemy != enemyUnit.masterData.name && enemy != enemyUnit.masterData.nickName)
                {
                    return false;
                }
            }
            
            //
            
            return true;
        }
        
        public function commanderSkillJudge(callState:String, commander:CommanderData, skill:MasterCommanderSkillData, target:BattleUnit = null):Boolean
        {
            var flg:Boolean = true;
            
            //行動タイプ名
            if (state != callState)
            {
                return false;
            }
            //スキル名
            if (skill != null)
            {
                if (skillName != null)
                {
                    if (skillName != skill.name)
                    {
                        return false;
                    }
                }
            }
            if (target != null && enemy != null)
            {
                if (target.name != enemy)
                {
                    return false;
                }
            }
            
            return true;
        }
    
    }

}