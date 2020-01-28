package database.master.base
{
	import database.master.MasterWeaponData;
	import scene.unit.BattleUnit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StateCondition
	{
		/**HP率*/
		public var hpRateMin:int = 0;
		
		public var hpRateMax:int = 0;
		
		/**キャラ名*/
		public var name:String = null;
		
		public var weaponName:String = null;
		
		/**相手名*/
		public var enemy:String = null;
		
		/**表示条件*/
		public function StateCondition()
		{
		
		}
		
		public function judge(unit:BattleUnit, enemyUnit:BattleUnit, weapon:MasterWeaponData):Boolean
		{
			var flg:Boolean = true;
			
			//キャラ名
			if (name != unit.masterData.name)
			{
				return false;
			}
			
			//武器名
			if (weaponName != null)
			{
				if (weaponName != weapon.name)
				{
					return false;
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
	
	}

}