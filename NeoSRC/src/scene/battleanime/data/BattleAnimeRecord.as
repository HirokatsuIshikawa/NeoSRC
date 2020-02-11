package scene.battleanime.data
{
	
	/**
	 * ...
	 * 戦闘棋譜データ
	 * @author ishikawa
	 */
	public class BattleAnimeRecord
	{
		/**攻撃側*/
		public static const SIDE_LEFT:int = 1;
		public static const SIDE_RIGHT:int = -1;
		
		/**攻撃効果*/
		public static const EFFECT_DAMAGE:int = 1;
		public static const EFFECT_NO_HIT:int = 2;
		
		/**攻撃タイプ*/
		public static const TYPE_NORMAL_ATTACK:int = 1;
		
		private var _side:int = 0;
		private var _damage:int = 0;
		private var _effect:int = 0;
		private var _type:int = 0;
		private var _enable:Boolean = false;
		
		public function BattleAnimeRecord(dmg:int, side:int, effect:int, type:int):void
		{
			_damage = dmg;
			_side = side;
			_effect = effect;
			_type = type;
			_enable = true;
		}
		
		public function get damage():int
		{
			return _damage;
		}
		
		public function get side():int
		{
			return _side;
		}
		
		public function get effect():int
		{
			return _effect;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
		}
	
	}

}