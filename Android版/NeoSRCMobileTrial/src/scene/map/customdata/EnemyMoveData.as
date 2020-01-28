package scene.map.customdata 
{
	import database.master.MasterWeaponData;
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
		
		
		public function getPriority(posX:int, posY:int, unit:BattleUnit, target:Vector.<SideState>, side:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var weaponNum:int = -1;
			_movePosX = posX;
			_movePosY = posY;
			// 全ユニットを検索
			for (i = 0; i < target.length; i++ )
			{
				if (i == side)
				{
					continue;
				}
				
				for (j = 0; j < target[i].battleUnit.length; j++ )
				{
					if (!target[i].battleUnit[j].moveEnable())
					{
						continue;
					}
					
					var setPriority:int = 0;
					var distance:int = Math.abs(posX - (target[i].battleUnit[j].PosX - 1)) + Math.abs(posY - (target[i].battleUnit[j].PosY - 1));
					var weaponValue:int = 0;
					
					if (distance == 1)
					{
						var fff:int = 0;
					}
					
					// 近いほど優先度をあげる
					setPriority += (99 - distance);
					
					// 射程範囲内の最大攻撃力武器を選択
					for (k = 0; k <  unit.weaponList.length; k++ )
					{
						if (unit.weaponList[k].minRange <= distance && distance <= unit.weaponList[k].maxRange)
						{
							if (weaponValue < unit.weaponList[k].value)
							{
								weaponNum = k;
							}
						}
					}
					
					if (weaponNum >= 0 )
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
						_priority = setPriority;
					}
				}
			}
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