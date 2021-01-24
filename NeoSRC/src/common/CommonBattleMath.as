package common
{
    import database.master.MasterCommanderSkillData;
    import database.master.MasterSkillData;
    import database.master.MasterWeaponData;
    import database.user.buff.SkillBuffData;
    import flash.desktop.NativeApplication;
    import scene.battleanime.data.BattleAnimeRecord;
    import main.MainController;
    import starling.events.Event;
    import scene.map.battle.AttackListItem;
    import scene.unit.BattleUnit;
    import starling.utils.MathUtil;
    
    /**
     * ...
     * @author ishikawa
     */
    public class CommonBattleMath
    {
        /**命中率作成*/
        public static function HitRate(attackItem:AttackListItem):int
        {
            var hit:Number = 0;
            // 命中率計算
            var baseHit:Number = ((attackItem.unit.param.TEC * 3.0 + attackItem.unit.param.SPD) / 2.0 + 50) * attackItem.weapon.hitRate / 100.0;
            // 回避ベース
            var baseAvo:Number = 0;
            
            if (attackItem.counterWeapon != null)
            {
                baseAvo = (attackItem.target.param.SPD * 3.0) / 2.0 * attackItem.counterWeapon.avoRate / 100.0;
                hit = (baseHit - baseAvo) + attackItem.weapon.hitPlus - attackItem.counterWeapon.avoPlus;
            }
            else
            {
                baseAvo = attackItem.target.param.SPD;
                hit = (baseHit - baseAvo) + attackItem.weapon.hitPlus;
            }
            
            //防御側地形番号
            var terrainNo:int = attackItem.target.mathPosX + attackItem.target.mathPosY * MainController.$.map.mapWidth;
            
            //防御側地形回避
            hit -= MainController.$.map.terrain[terrainNo].AgiComp;
            hit = MathUtil.clamp(hit, 0, 100);
            
            return (int)(hit);
        }
        
        /**ダメージ計算式*/
        public static function battleDamage(data:AttackListItem):int
        {
            
            //防御側地形番号
            var terrainNo:int = data.target.mathPosX + data.target.mathPosY * MainController.$.map.mapWidth;
            // 基礎攻撃力
            var baseAtk:Number = data.unit.param.ATK + data.weapon.atkplus;
            // 基礎防御力
            var baseDef:Number = 0;
            if (data.counterWeapon != null)
            {
                baseDef = data.target.param.DEF * data.counterWeapon.defRate / (100.0 * 4.0) + data.counterWeapon.defPlus;
            }
            else
            {
                baseDef = data.target.param.DEF / 4.0;
            }
            // 特技倍率
            var weaponRate:Number = data.weapon.value / 10.0;
            
            var baseDamage:Number = (baseAtk - baseDef) * weaponRate;
            
            // 1/16のブレ
            baseDamage = baseDamage + baseDamage / 16.0 * getRandom(100, -100) / 100.0;
            //防御側地形防御
            baseDamage = baseDamage * (100.0 - MainController.$.map.terrain[terrainNo].DefComp) / 100.0;
            
            var damage:int = MathUtil.max((int)(baseDamage), 1);
            return damage;
        }
        
        /** ランダム作成 */
        public static function getRandom(max:int, min:int):int
        {
            return (int)(Math.floor(Math.random() * max - min + 1) + min);
        }
        
        /**経験値計算*/
        public static function getExp(targetUnit:BattleUnit, enemyUnit:BattleUnit):int
        {
            var damageExp:int = 0;
            var defeatExp:int = 0;
            //ダメージ経験値
            damageExp = Math.max((31 - (targetUnit.showLv - enemyUnit.showLv)) / 3, 1);
            //撃破経験値
            if (!enemyUnit.alive)
            {
                defeatExp = 20 + (enemyUnit.showLv * 1.0 / targetUnit.showLv) * 3 + enemyUnit.masterData.exp;
            }
            
            return damageExp + defeatExp;
        }
        
        /**スキル使用*/
        public static function unitSkillEffect(unit:BattleUnit, skill:MasterSkillData):int
        {
            var i:int = 0;
            var value:int = 0;
            //回復
            if (skill.heal > 0)
            {
                value = skill.heal;
                unit.healHP(skill.heal);
            }
            //補給
            if (skill.supply > 0)
            {
                value = skill.supply;
                unit.supplyFP(skill.supply);
            }
            //効果
            if (skill.buff != null)
            {
                value = skill.turn;
                var findFlg:Boolean = false;
                var buffName:String = skill.buff;
                //該当バフデータを検索
                for (i = 0; i < MainController.$.model.masterBuffData.length; i++)
                {
                    if (buffName === MainController.$.model.masterBuffData[i].name)
                    {
                        findFlg = true;
                        var addBuff:SkillBuffData = new SkillBuffData();
                        addBuff.setMasterData(MainController.$.model.masterBuffData[i], skill.turn, skill.level);
                        //ターゲットにバフを追加
                        unit.buffAdd(addBuff);
                        //軍師ステータス追加
                        if (MainController.$.map.sideState[unit.side].commander != null)
                        {
                            unit.commanderStatusSet(MainController.$.map.sideState[unit.side].commander);
                        }
                        break;
                    }
                }
                
                //見つからなかった場合
                if (!findFlg)
                {
                    MainController.$.view.alertMessage("該当のバフが見つかりません", "BattleResultManager_Error");
                }
            }
            return value;
        }
        
        /**軍師スキル使用*/
        public static function commanderSkillEffect(unit:BattleUnit, skill:MasterCommanderSkillData):int
        {
            var i:int = 0;
            var value:int = 0;
            //回復
            if (skill.heal > 0)
            {
                value = skill.heal;
                unit.healHP(skill.heal);
            }
            //補給
            if (skill.supply > 0)
            {
                value = skill.supply;
                unit.supplyFP(skill.supply);
            }
            //効果
            if (skill.buff != null)
            {
                value = skill.turn;
                var findFlg:Boolean = false;
                var buffName:String = skill.buff;
                //該当バフデータを検索
                for (i = 0; i < MainController.$.model.masterBuffData.length; i++)
                {
                    if (buffName === MainController.$.model.masterBuffData[i].name)
                    {
                        findFlg = true;
                        var addBuff:SkillBuffData = new SkillBuffData();
                        addBuff.setMasterData(MainController.$.model.masterBuffData[i], skill.turn, skill.level);
                        //ターゲットにバフを追加
                        unit.buffAdd(addBuff);
                        //軍師ステータス追加
                        if (MainController.$.map.sideState[unit.side].commander != null)
                        {
                            unit.commanderStatusSet(MainController.$.map.sideState[unit.side].commander);
                        }
                        break;
                    }
                }
                
                //見つからなかった場合
                if (!findFlg)
                {
                    MainController.$.view.alertMessage("該当のバフが見つかりません", "BattleResultManager_Error");
                }
            }
            
            return value;
        }
    }
}