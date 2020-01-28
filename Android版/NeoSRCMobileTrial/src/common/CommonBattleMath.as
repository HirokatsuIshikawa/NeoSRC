package common
{
	import database.master.MasterWeaponData;
	import flash.desktop.NativeApplication;
	import starling.events.Event;
	import scene.map.battle.AttackListItem;
	import scene.unit.BattleUnit;
	
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
			hit = Math.max(Math.min(hit, 100), 0);
			
			return (int)(hit);
		}
		
		/**ダメージ計算式*/
		public static function battleDamage(data:AttackListItem):int
		{
			/**
			   var baseAtk:int = data.unit.ATK * data.weapon.value;
			   var baseDef:int = (int)(5 * data.target.DEF * data.counterWeapon.defRate / 100.0 + data.counterWeapon.defPlus);
			   // ダメージ表示、最低１保障
			   var baseDamage:int = Math.max(baseAtk - baseDef, 1);
			 */
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
			
			var damage:int = Math.max((int)(baseDamage), 1);
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
			damageExp = (31 - (targetUnit.nowLv - enemyUnit.nowLv) ) / 3;
			//撃破経験値
			if (!enemyUnit.alive)
			{
				defeatExp = 20 + (targetUnit.nowLv - enemyUnit.nowLv) * 3 + enemyUnit.masterData.exp;
			}
			
			return damageExp + defeatExp;
		}
	
	}

}