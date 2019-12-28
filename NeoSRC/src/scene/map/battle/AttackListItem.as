package scene.map.battle
{
	import common.CommonBattleMath;
	import system.custom.customData.CData;
	import database.master.MasterSkillData;
	import database.master.MasterWeaponData;
	import scene.map.BattleMap;
	import scene.map.tip.TerrainData;
	import scene.unit.BattleUnit;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class AttackListItem extends CData
	{
		private var _type:int = 0;
		private var _side:int
		private var _unit:BattleUnit;
		private var _weapon:MasterWeaponData;
		private var _counterWeapon:MasterWeaponData;
		private var _skill:MasterSkillData;
		private var _target:BattleUnit;
		public var enable:Boolean;
		private var _support:Boolean;
		private var _hit:int = 0;
		private var _distance:int = 0;
		
		public function AttackListItem()
		{
			super();
		}
		
		public function setAttack(unit:BattleUnit, side:int, weapon:MasterWeaponData, target:BattleUnit, counterWeapon:MasterWeaponData):void
		{
			_type = BattleMap.ACT_TYPE_ATK;
			_side = side;
			_unit = unit;
			_weapon = weapon;
			_target = target;
			_counterWeapon = counterWeapon;
			enable = true;
			
			_distance = Math.abs(unit.PosX - target.PosX) + Math.abs(unit.PosY - target.PosY);
			
			if (_weapon != null)
			{
				_hit = CommonBattleMath.HitRate(this);
			}
			else
			{
				_hit = 0;
			}
		
		}
		
		public function setSkill(unit:BattleUnit, side:int, skill:MasterSkillData, target:BattleUnit):void
		{
			
			_type = BattleMap.ACT_TYPE_SKILL;
			_side = side;
			_unit = unit;
			_skill = skill;
			_target = target;
			enable = true;
		}
		
		public function get side():int 
		{
			return _side;
		}
		
		public function get unit():BattleUnit 
		{
			return _unit;
		}
		
		public function get weapon():MasterWeaponData 
		{
			return _weapon;
		}
		
		public function get target():BattleUnit 
		{
			return _target;
		}
		
		public function get hit():int 
		{
			return _hit;
		}
		
		public function get counterWeapon():MasterWeaponData 
		{
			return _counterWeapon;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function get skill():MasterSkillData 
		{
			return _skill;
		}
		
		public function get distance():int 
		{
			return _distance;
		}
	
	}

}